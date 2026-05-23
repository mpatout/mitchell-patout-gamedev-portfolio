Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function New-WavFile {
  param(
    [string]$Path,
    [double]$Duration,
    [int]$SampleRate = 22050,
    [scriptblock]$SampleFormula
  )

  $samples = [int]([Math]::Ceiling($Duration * $SampleRate))
  $bitsPerSample = 16
  $channels = 1
  $byteRate = [int]($SampleRate * $channels * ($bitsPerSample / 8))
  $blockAlign = [int]($channels * ($bitsPerSample / 8))
  $dataSize = [int]($samples * $blockAlign)
  $riffSize = [int](36 + $dataSize)

  $dir = Split-Path $Path -Parent
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
  }

  $fs = [System.IO.File]::Open($Path, [System.IO.FileMode]::Create)
  $bw = New-Object System.IO.BinaryWriter($fs)
  try {
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF'))
    $bw.Write($riffSize)
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes('WAVE'))
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes('fmt '))
    $bw.Write([int]16)
    $bw.Write([int16]1)
    $bw.Write([int16]$channels)
    $bw.Write([int]$SampleRate)
    $bw.Write([int]$byteRate)
    $bw.Write([int16]$blockAlign)
    $bw.Write([int16]$bitsPerSample)
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes('data'))
    $bw.Write([int]$dataSize)

    for ($i = 0; $i -lt $samples; $i++) {
      $t = $i / [double]$SampleRate
      $amp = & $SampleFormula $t $Duration
      if ($amp -gt 1.0) { $amp = 1.0 }
      if ($amp -lt -1.0) { $amp = -1.0 }
      $sample = [int16]([Math]::Round($amp * 32767.0))
      $bw.Write($sample)
    }
  }
  finally {
    $bw.Close()
    $fs.Close()
  }
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

$temp = Join-Path $repoRoot '.tmp_audio_gen'
if (-not (Test-Path $temp)) {
  New-Item -ItemType Directory -Path $temp | Out-Null
}

New-WavFile -Path (Join-Path $temp 'catch.wav') -Duration 0.12 -SampleFormula {
  param($t,$d)
  $env = [Math]::Exp(-18.0 * $t)
  $tone = [Math]::Sin(2.0 * [Math]::PI * 720.0 * $t) + 0.4 * [Math]::Sin(2.0 * [Math]::PI * 1080.0 * $t)
  return 0.38 * $env * $tone
}

New-WavFile -Path (Join-Path $temp 'hit.wav') -Duration 0.18 -SampleFormula {
  param($t,$d)
  $env = [Math]::Exp(-10.0 * $t)
  $tone = [Math]::Sin(2.0 * [Math]::PI * 180.0 * $t) + 0.35 * [Math]::Sin(2.0 * [Math]::PI * 95.0 * $t)
  return 0.42 * $env * $tone
}

New-WavFile -Path (Join-Path $temp 'powerup.wav') -Duration 0.30 -SampleFormula {
  param($t,$d)
  $f = 380.0 + (720.0 * ($t / $d))
  $env = [Math]::Exp(-4.0 * $t)
  return 0.32 * $env * [Math]::Sin(2.0 * [Math]::PI * $f * $t)
}

New-WavFile -Path (Join-Path $temp 'round_end.wav') -Duration 0.42 -SampleFormula {
  param($t,$d)
  $env = [Math]::Exp(-3.2 * $t)
  $a = [Math]::Sin(2.0 * [Math]::PI * 330.0 * $t)
  $b = [Math]::Sin(2.0 * [Math]::PI * 247.0 * $t)
  $c = [Math]::Sin(2.0 * [Math]::PI * 196.0 * $t)
  return 0.22 * $env * ($a + $b + $c)
}

New-WavFile -Path (Join-Path $temp 'music_loop.wav') -Duration 4.0 -SampleFormula {
  param($t,$d)
  $beat = [Math]::Sin(2.0 * [Math]::PI * 2.0 * $t)
  $pulse = 0.55 + 0.45 * [Math]::Max(0.0, $beat)
  $pad = 0.52 * [Math]::Sin(2.0 * [Math]::PI * 164.81 * $t) + 0.33 * [Math]::Sin(2.0 * [Math]::PI * 220.0 * $t) + 0.22 * [Math]::Sin(2.0 * [Math]::PI * 246.94 * $t)
  return 0.11 * $pulse * $pad
}

$targets = @(
  'engines/Godot/audio',
  'engines/defold/main/audio',
  'engines/solar2d/audio'
)
$files = @('catch.wav','hit.wav','powerup.wav','round_end.wav','music_loop.wav')

foreach ($target in $targets) {
  $dst = Join-Path $repoRoot $target
  if (-not (Test-Path $dst)) {
    New-Item -ItemType Directory -Path $dst | Out-Null
  }
  foreach ($file in $files) {
    Copy-Item -Path (Join-Path $temp $file) -Destination (Join-Path $dst $file) -Force
  }
}

Get-ChildItem 'engines/Godot/audio','engines/defold/main/audio','engines/solar2d/audio' -File | ForEach-Object {
  "{0}|{1}" -f $_.FullName,$_.Length
}
