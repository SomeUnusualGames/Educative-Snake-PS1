using namespace System.Collections
class Walls {
  [ArrayList]$position = @()
  [Color]$color

  Walls() {
    $this.color = New-Color 0 0 0 255
  }

  addBorder() {
    $this.create(0, 120, 1280, 20)
    $this.create(1260, 120, 20, 720)
    $this.create(0, 700, 1280, 20)
    $this.create(0, 120, 20, 720)    
  }

  create([float]$x, [float]$y, [float]$width, [float]$height) {
    $this.position += , (New-Rectangle $x $y $width $height)
  }

  [boolean]checkCollision([Rectangle]$head) {
    foreach ($currentWall in $this.position) {
      $col = collisionRectPoint $currentWall ($head.x+10) ($head.y+10)
      if ($col) {
        return $true
      }
    }
    return $false
  }

  draw() {
    foreach ($wall in $this.position) {
      [Raylib]::DrawRectangleRec($wall, $this.color)
    }
  }
}