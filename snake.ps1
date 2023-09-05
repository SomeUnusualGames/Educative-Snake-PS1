using namespace System.Collections

enum Movement {
  North = 0
  South
  East
  West
}

class Snake {
  [ArrayList]$body = @()
  [int]$length = 5
  [float]$size = 20.0
  [Color]$color

  [float]$maxTimer = 0.5
  [float]$movTimer
  [Movement]$movement

  Snake([float]$initialX, [float]$initialY) {
    for ($i = 0; $i -lt $this.length; $i++) {
      $x = $initialX - ($this.size * $i)
      $this.body += (New-Rectangle $x $initialY $this.size $this.size)
    }
    $this.color = New-Color 0 255 0 255
    $this.movement = [Movement]::East
    $this.movTimer = $this.maxTimer
  }

  [void]checkMovement() {
    # TODO: add keyboard functions to raylib.cs, do proper movement
  }

  [void]updateMovement() {
    $this.movTimer -= [Raylib]::GetFrameTime()
    if ($this.movTimer -lt 0) {
      $this.movTimer = $this.maxTimer
      $oldHeadX = $this.body[0].x
      $oldHeadY = $this.body[0].y
      $tail = $this.body[-1]
      switch ($this.movement) {
        ([Movement]::East) {
          $this.body[0].x += $this.size
          $tail.x = $oldHeadX
          break
        }
        ([Movement]::West) {
          $this.body[0].x -= $this.size
          $tail.x = $oldHeadX
          break
        }
        ([Movement]::North) {
          $this.body[0].y -= $this.size
          $tail.x = $oldHeadY
          break
        }
        ([Movement]::South) {
          $this.body[0].y += $this.size
          $tail.x = $oldHeadY
          break
        }
      }
      $this.body.RemoveAt($this.body.Count-1)
      $this.body.Insert(1, $tail)
    }
  }

  [void]update() {
    $this.checkMovement()
    $this.updateMovement()
  }

  [void]draw() {
    foreach ($rect in $this.body) {
      [Raylib]::DrawRectangleRec($rect, $this.color)
    }
  }
}