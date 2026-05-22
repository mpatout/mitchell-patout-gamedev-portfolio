import json
import os
import random
from pathlib import Path

from direct.gui.OnscreenText import OnscreenText
from direct.showbase.ShowBase import ShowBase
from panda3d.core import TextNode

LANE_X = [-6.0, -3.0, 0.0, 3.0, 6.0]
PLAYER_Y = -18.0
SPAWN_START = 1.20
SPAWN_FLOOR = 0.34
SPEED_START = 19.0
SPEED_MAX = 34.0
DIFFICULTY_RAMP = 0.055
COLLISION_Y = 1.7

SAVE_FILE = Path(__file__).resolve().parent / "runtime" / "lane_drift_save.json"
TRACE_FILE = Path(__file__).resolve().parent / "runtime" / "lane_drift_latest_run.json"


class LaneDrift(ShowBase):
    def __init__(self):
        super().__init__()

        self.seed = int(os.getenv("PANDA3D_SEED", "0") or "0")
        self.rng = random.Random(self.seed if self.seed else None)

        self.disableMouse()
        self.camera.setPos(0, -42, 18)
        self.camera.lookAt(0, 0, 0)

        self.accept("escape", self.userExit)
        self.accept("arrow_left", self.move_left)
        self.accept("a", self.move_left)
        self.accept("arrow_right", self.move_right)
        self.accept("d", self.move_right)
        self.accept("r", self.restart_round)

        self.best_score = self.load_best_score()
        self.trace = {"seed": self.seed, "events": []}

        self.player = None
        self.lane_lines = []
        self.obstacles = []
        self.score = 0.0
        self.spawn_timer = SPAWN_START
        self.spawn_interval = SPAWN_START
        self.speed = SPEED_START
        self.lane_index = 2
        self.game_over = False

        self.hud = OnscreenText(
            text="",
            pos=(-1.28, 0.90),
            scale=0.06,
            fg=(1, 1, 1, 1),
            align=TextNode.ALeft,
            mayChange=True,
        )
        self.state_text = OnscreenText(
            text="",
            pos=(0, 0),
            scale=0.08,
            fg=(1, 1, 0.8, 1),
            align=TextNode.ACenter,
            mayChange=True,
        )

        self.build_scene()
        self.start_round()

        self.taskMgr.add(self.update_task, "update_task")

    def build_scene(self):
        self.setBackgroundColor(0.05, 0.07, 0.1, 1)

        for lane_x in LANE_X:
            line = self.loader.loadModel("models/box")
            line.reparentTo(self.render)
            line.setScale(0.05, 26.0, 0.03)
            line.setPos(lane_x, 0.0, -0.2)
            line.setColor(0.25, 0.25, 0.33, 1)
            self.lane_lines.append(line)

        self.player = self.loader.loadModel("models/smiley")
        self.player.reparentTo(self.render)
        self.player.setScale(0.9)
        self.player.setColor(0.20, 0.85, 0.55, 1)

    def start_round(self):
        for obstacle in self.obstacles:
            obstacle.removeNode()
        self.obstacles = []

        self.score = 0.0
        self.spawn_timer = SPAWN_START
        self.spawn_interval = SPAWN_START
        self.speed = SPEED_START
        self.lane_index = 2
        self.game_over = False
        self.state_text.setText("")
        self.update_player_pos()
        self.refresh_hud()
        self.log_event("round_start", {"seed": self.seed})

    def restart_round(self):
        if self.game_over:
            self.start_round()

    def move_left(self):
        if self.game_over:
            return
        self.lane_index = max(0, self.lane_index - 1)
        self.update_player_pos()

    def move_right(self):
        if self.game_over:
            return
        self.lane_index = min(len(LANE_X) - 1, self.lane_index + 1)
        self.update_player_pos()

    def update_player_pos(self):
        self.player.setPos(LANE_X[self.lane_index], PLAYER_Y, 0.2)

    def spawn_obstacle(self):
        lane_idx = self.rng.randint(0, len(LANE_X) - 1)
        obstacle = self.loader.loadModel("models/box")
        obstacle.reparentTo(self.render)
        obstacle.setScale(0.95, 0.95, 0.95)
        obstacle.setColor(0.88, 0.25, 0.2, 1)
        obstacle.setPos(LANE_X[lane_idx], 28.0, 0.2)

        self.obstacles.append({"node": obstacle, "lane": lane_idx})
        self.log_event("spawn", {"lane": lane_idx, "score": round(self.score, 2)})

    def refresh_hud(self):
        self.hud.setText(
            f"Lane Drift\nScore: {int(self.score)}\nBest: {self.best_score}\n"
            f"Spawn: {self.spawn_interval:.2f}s  Speed: {self.speed:.1f}"
        )

    def trigger_game_over(self):
        self.game_over = True
        final_score = int(self.score)
        if final_score > self.best_score:
            self.best_score = final_score
            self.save_best_score(self.best_score)

        self.state_text.setText(
            f"GAME OVER\nScore: {final_score}  Best: {self.best_score}\nPress R to restart"
        )
        self.log_event("game_over", {"score": final_score, "best": self.best_score})
        self.write_trace()
        self.refresh_hud()

    def update_task(self, task):
        dt = globalClock.getDt()
        if self.game_over:
            return task.cont

        self.score += dt * 9.0

        self.spawn_interval = max(SPAWN_FLOOR, SPAWN_START - self.score * 0.005)
        self.speed = min(SPEED_MAX, SPEED_START + self.score * DIFFICULTY_RAMP)

        self.spawn_timer -= dt
        if self.spawn_timer <= 0:
            self.spawn_timer = self.spawn_interval
            self.spawn_obstacle()

        player_lane = self.lane_index
        survived = []
        for obs in self.obstacles:
            node = obs["node"]
            lane = obs["lane"]
            node.setY(node.getY() - self.speed * dt)

            dy = abs(node.getY() - PLAYER_Y)
            if lane == player_lane and dy <= COLLISION_Y:
                self.trigger_game_over()
                return task.cont

            if node.getY() < -30:
                node.removeNode()
            else:
                survived.append(obs)

        self.obstacles = survived
        self.refresh_hud()
        return task.cont

    def log_event(self, event_name, payload):
        self.trace["events"].append({
            "event": event_name,
            "payload": payload,
        })

    def load_best_score(self):
        try:
            if SAVE_FILE.exists():
                data = json.loads(SAVE_FILE.read_text(encoding="utf-8"))
                return int(data.get("best_score", 0))
        except Exception:
            return 0
        return 0

    def save_best_score(self, value):
        SAVE_FILE.parent.mkdir(parents=True, exist_ok=True)
        SAVE_FILE.write_text(
            json.dumps({"best_score": int(value)}, indent=2),
            encoding="utf-8",
        )

    def write_trace(self):
        TRACE_FILE.parent.mkdir(parents=True, exist_ok=True)
        TRACE_FILE.write_text(json.dumps(self.trace, indent=2), encoding="utf-8")


if __name__ == "__main__":
    app = LaneDrift()
    app.run()
