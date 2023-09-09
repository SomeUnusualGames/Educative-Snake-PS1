using namespace System.Collections
enum Movement {
  North = 0
  South
  East
  West
}
class Snake {
  [ArrayList]$body = @()
  [int]$length
  [float]$size = 20.0
  [Color]$color

  [float]$maxTimer = 0.5
  [float]$movTimer
  [Movement]$movement

  Snake([float]$initialX, [float]$initialY, [int]$length, [float]$timer) {
    $this.length = $length
    $this.maxTimer = $timer
    $this.movTimer = $this.maxTimer
    for ($i = 0; $i -lt $this.length; $i++) {
      $x = $initialX - ($this.size * $i)
      $this.body += (New-Rectangle $x $initialY $this.size $this.size)
    }
    $this.color = New-Color 0 255 0 255
    $this.movement = [Movement]::East
  }

  [void]checkMovement() {
    # w -> 87 | a -> 65 | s -> 83 | d -> 68
    if ([Raylib]::IsKeyPressed(87) -and $this.movement -ne [Movement]::South) {
      $this.movement = [Movement]::North
      $this.movTimer = 0.0
    } elseif ([Raylib]::IsKeyPressed(83) -and $this.movement -ne [Movement]::North) {
      $this.movement = [Movement]::South
      $this.movTimer = 0.0
    } elseif ([Raylib]::IsKeyPressed(65) -and $this.movement -ne [Movement]::East) {
      $this.movement = [Movement]::West
      $this.movTimer = 0.0
    } elseif ([Raylib]::IsKeyPressed(68) -and $this.movement -ne [Movement]::West) {
      $this.movement = [Movement]::East
      $this.movTimer = 0.0
    }
  }

  [void]updateMovement() {
    $this.movTimer -= [Raylib]::GetFrameTime()
    if ($this.movTimer -lt 0) {
      $this.movTimer = $this.maxTimer
      $oldHeadX = $this.body[0].x
      $oldHeadY = $this.body[0].y
      $tail = $this.body[-1]
      # () is important in this switch
      switch ($this.movement) {
        ([Movement]::East) {
          $this.body[0].x += $this.size
          $tail.x = $oldHeadX
          $tail.y = $oldHeadY
          break
        }
        ([Movement]::West) {
          $this.body[0].x -= $this.size
          $tail.x = $oldHeadX
          $tail.y = $oldHeadY
          break
        }
        ([Movement]::North) {
          $this.body[0].y -= $this.size
          $tail.x = $oldHeadX
          $tail.y = $oldHeadY
          break
        }
        ([Movement]::South) {
          $this.body[0].y += $this.size
          $tail.x = $oldHeadX
          $tail.y = $oldHeadY
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