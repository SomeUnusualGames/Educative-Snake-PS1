Set-StrictMode -Version 3.0
Import-Module ".\raylib.psm1" -Force

. .\equation.ps1

[Raylib]::InitWindow(800, 600, "Hello from Powershell!")
[Raylib]::SetTargetFPS(60)

$BLACK = New-Color 0 0 0 255
#$WHITE = New-Color 255 255 255 255

$equation = [Equation]::new([EquationType]::Number)
$equation.create()

while (-not [Raylib]::WindowShouldClose()) {
  [Raylib]::BeginDrawing()
  [Raylib]::ClearBackground($BLACK)
  [Raylib]::DrawFPS(0, 0)
  [Raylib]::EndDrawing()
}
[Raylib]::CloseWindow()
exit