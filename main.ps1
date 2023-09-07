Set-StrictMode -Version 3.0
Import-Module .\raylib.psm1

. .\equation.ps1
. .\snake.ps1
. .\walls.ps1

[Raylib]::InitWindow(1280, 720, "Educative Snake")
[Raylib]::SetTargetFPS(60)

#$BLACK = New-Color 0 0 0 255
$GREEN = New-Color 20 110 45 255
#$WHITE = New-Color 255 255 255 255

$equation = [Equation]::new([EquationType]::Operator)
$equation.create()

$snake = [Snake]::new(400.0, 300.0, 8, 0.0625)

$wall = [Walls]::new()
$wall.addBorder()

while (-not [Raylib]::WindowShouldClose()) {
  $snake.update()
  [Raylib]::BeginDrawing()
  [Raylib]::ClearBackground($GREEN)
  [Raylib]::DrawFPS(0, 0)
  $snake.draw()
  $equation.draw()
  $equation.drawAnswers()
  $wall.draw()
  [Raylib]::EndDrawing()
}
[Raylib]::CloseWindow()
exit