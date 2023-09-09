Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"

Import-Module .\raylib.psm1

. .\equation.ps1
. .\snake.ps1
. .\walls.ps1

[Raylib]::InitWindow(1280, 720, "Educative Snake")
[Raylib]::SetTargetFPS(60)

$GREEN = New-Color 20 110 45 255
$RED = New-Color 255 0 0 255

$equation = [Equation]::new([EquationType]::Number, 0, 2)
$equation.create()

$snake = [Snake]::new(700.0, 600.0, 8, 0.3)

$wall = [Walls]::new()
$wall.addBorder()

$gameover = $false

while (-not [Raylib]::WindowShouldClose()) {
  if ($wall.checkCollision($snake.body[0]) -or $snake.checkCollisionBody()) {
    $gameover = $true
  }
  if (-not $gameover) {
    $snake.update()
  }
  if ($equation.selectedAnswer -ge 0 -and $equation.state -eq [EquationState]::Unanswered) {
    $equation.checkAnswer()
  }
  if ($equation.resetTimer -gt 0 -and -not $gameover) {
    $equation.resetTimer -= [Raylib]::GetFrameTime()
    if ($equation.resetTimer -le 0) {
      $eqSize = $equation.size
      if ($equation.state -eq [EquationState]::Correct) {
        $newTimer = if ($snake.maxTimer-0.05 -lt 0.1) { 0.1 } else { $snake.maxTimer-0.05 }
        #$snake = [Snake]::new($snake.body[0].x, $snake.body[0].y, $snake.length+1, $newTimer)
        $snake.body += , ($snake.body[-1])
        $snake.maxTimer = $newTimer
        if ($equation.correctAnswers % 5 -eq 0 -and $eqSize -le 4) {
          $eqSize++
        }
      }
      $newType = if ($equation.type -eq [EquationType]::Number) { [EquationType]::Operator } else { [EquationType]::Number }
      $equation = [Equation]::new($newType, $equation.correctAnswers, $eqSize)
      $equation.create()
    }
  } else {
    $equation.checkCollision($snake.body[0])
  }
  [Raylib]::BeginDrawing()
  [Raylib]::ClearBackground($GREEN)
  $snake.draw()
  $equation.draw()
  $equation.drawAnswers()
  $wall.draw()
  if ($gameover) {
    [Raylib]::DrawText("Game over! Press R to reset", 300, 400, 60, $RED)
    if ([Raylib]::IsKeyPressed(82)) {
      $snake = [Snake]::new(700.0, 600.0, 8, 0.3)
      $equation = [Equation]::new([EquationType]::Number, 0, 2)
      $equation.create()
      $gameover = $false
    }
  }
  [Raylib]::EndDrawing()
}
[Raylib]::CloseAudioDevice()
[Raylib]::CloseWindow()
exit