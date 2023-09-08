Set-StrictMode -Version 3.0
Import-Module .\raylib.psm1

. .\equation.ps1
. .\snake.ps1
. .\walls.ps1

[Raylib]::InitWindow(1280, 720, "Educative Snake")
[Raylib]::SetTargetFPS(60)

$GREEN = New-Color 20 110 45 255

$equation = [Equation]::new([EquationType]::Number)
$equation.create()

$snake = [Snake]::new(400.0, 300.0, 8, 0.3)

$wall = [Walls]::new()
$wall.addBorder()

while (-not [Raylib]::WindowShouldClose()) {
  $snake.update()
  $equation.checkCollision($snake.body[0].x, $snake.body[0].y)
  if ($equation.selectedAnswer -ge 0) {
    # TODO: Get the selected answer, add it to the equation,
    # calculate the result and check if it matches, show a message
    #$equation.tokenList[$equation.unknownIndex] = 
  }
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