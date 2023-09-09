using namespace System.Collections
enum EquationType {
  Operator = 0
  Number
}

enum EquationState {
  Unanswered = 0
  Correct
  Incorrect
}

class Equation {
  static $precedence = @{ "+" = 0; "-" = 0; "x" = 1; "/" = 1 }
  [EquationType]$type
  [EquationState]$state = [EquationState]::Unanswered
  [int]$size
  [int]$result
  [int]$unknownIndex
  [int]$selectedAnswer = -1
  [int]$correctAnswers = 0
  [ArrayList]$tokenList = @()
  [ArrayList]$answers = @()
  [ArrayList]$answersPosition = @()
  [String]$eqStr
  [Color]$eqColor
  [Color]$correctColor
  [Color]$incorrectColor
  [Color]$answerColor
  [float]$resetTimer = 0.0

  Equation([EquationType]$eqType, [int]$correctAnswers, [int]$size) {
    $this.type = $eqType
    $this.size = $size
    $this.tokenList = @()
    $this.unknownIndex = 0
    $this.selectedAnswer = -1
    $this.correctAnswers = $correctAnswers
    $this.eqColor = New-Color 255 255 255 255
    $this.answerColor = New-Color 0 0 0 255
    $this.correctColor = New-Color 0 255 0 255
    $this.incorrectColor = New-Color 255 0 0 255
  }
  
  static [String]getRandomOperator() {
    $n = Get-Random -Maximum 100
    if ($n -lt 25) {
      return "+"
    } elseif ($n -ge 25 -and $n -lt 50) {
      return "-"
    } elseif ($n -ge 50 -and $n -lt 75) {
      return "x"
    }
    return "/"
  }

  static [int[]]getDivisibleNumbers([int]$num) {
    [int[]]$nums = @(1)
    if ($num -eq 0 -or $num -eq 1) {
      return $nums
    }
    $current = if ($num % 2 -eq 0) { 2 } else { 3 }
    $half = [int]($num/2)
    while ($current -le $half) {
      if ($num % $current -eq 0) {
        $nums += $current
      }
      $current++
    }
    $nums += $num
    return $nums
  }

  static [int]performOperation([int]$left, [int]$right, [String]$op) {
    switch ($op) {
      "+" { return $left + $right }
      "-" { return $left - $right }
      "x" { return $left*$right }
      "/" { return [int]($left/$right) }
    }
    return 0
  }

  [void]create() {
    for ($i = 0; $i -lt $this.size; $i++) {
      $num = Get-Random -Minimum 1 -Maximum 16
      # Push the position in the list to be able to change it later
      $this.tokenList += , @($num, $i)
      if ($i+1 -lt $this.size) {
        $this.tokenList += [Equation]::getRandomOperator()
      }
    }
    <#
    # https://en.wikipedia.org/wiki/Shunting_yard_algorithm
    # Write the equation a + b * c in the Reverse Polish notation: a b c * -
    [ArrayList]$output = @()
    [ArrayList]$operatorStack = @()
    for ($i = 0; $i -lt $this.tokenList.Count; $i++) {
      $token = $this.tokenList[$i]
      # Push numbers to the output
      if ($token -is [Array]) {
        $output += , $token
      } else {
        # Check for operators with greater or same precedence
        # and push them to the output
        for ($j = 0; $j -lt $operatorStack.Count; $j++) {
          $op = $operatorStack[$j]
          if ([Equation]::precedence[$token] -le [Equation]::precedence[$op]) {
            $tokenToPush = $operatorStack[$j]
            $output += $tokenToPush
            $operatorStack.RemoveAt($j)
          }
        }
        # Push current operator to the op stack
        $operatorStack.Insert(0, $token)
      }
    }
    # Push the rest of the stack to the output
    $output += $operatorStack
    #>

    # Division: remainder always zero.
    # Multiplication: no huge numbers.
    # Substraction: avoid negative numbers.
    for ($i = 2; $i -lt $this.tokenList.Count; $i += 2) {
      $num2 = $this.tokenList[$i]
      $op = $this.tokenList[$i-1]
      $num = $this.tokenList[$i-2]
      switch ($op) {
        "x" {
          $num2[0] = Get-Random -Minimum 1 -Maximum 11
          break
        }
        "/" {
          $divs = [Equation]::getDivisibleNumbers($num[0])
          $maxValue = if ($divs.Count-1 -eq 0) { 1 } else { $divs.Count-1 }
          $randDiv = Get-Random -Maximum $maxValue
          $num2[0] = $divs[$randDiv]
          break
        }
        "-" {
          $maxRand = [int]($num[0]/2 + 1) 
          $num2[0] = Get-Random -Minimum 1 -Maximum $maxRand
          break
        }
      }
    }
    <#
    [ArrayList]$res = @()
    for ($i = 0; $i -lt $output.Count; $i++) {
      $token = $output[$i]
      if ($token -is [Array]) {
        $res += , $token
      } else {
        $num2 = $res[-1]
        $num = $res[-2]
        $res.RemoveAt($res.Count-1)
        $res.RemoveAt($res.Count-1)
        switch ($token) {
          "x" {
            $num2[0] = Get-Random -Minimum 1 -Maximum 11
            break
          }
          "/" {
            $divs = [Equation]::getDivisibleNumbers($num[0])
            $maxValue = if ($divs.Count-1 -eq 0) { 1 } else { $divs.Count-1 }
            $randDiv = Get-Random -Maximum $maxValue
            $num2[0] = $divs[$randDiv]
            break
          }
          "-" {
            $maxRand = [int]($num[0]/2 + 1) 
            $num2[0] = Get-Random -Minimum 1 -Maximum $maxRand
            if ($num2[1] -ne -1) {
              $this.tokenList[$num2[1]][0] = $num2[0]
            }
            break
          }
        }
        $opResult = [Equation]::performOperation($num[0], $num2[0], $token)
        $res += , @($opResult, -1)
      }
    }
    $this.result = $res[0][0]
    #>
    $divUnknown = if ($this.type -eq [EquationType]::Operator) { 1 } else { 0 }
    do {
      $this.unknownIndex = Get-Random -Minimum 1 -Maximum ($this.size+1)
    } while ($this.unknownIndex % 2 -ne $divUnknown)
    $eqGetResult = ""
    for ($i = 0; $i -lt $this.tokenList.Count; $i++) {
      $value = if ($this.tokenList[$i] -is [Array]) { $this.tokenList[$i][0].ToString() } else { $this.tokenList[$i] }
      $eqGetResult += $value
      if ($i -ne $this.unknownIndex) {
        $this.eqStr += $value
      } else {
        $this.eqStr += "_"
      }
    }
    $this.result = Invoke-Expression $eqGetResult.Replace("x", "*")
    $this.eqStr += "=" + $this.result
    $this.answers += $this.tokenList[$this.unknownIndex][0]
    if ($this.type -eq [EquationType]::Number) {
      $this.answers += $this.answers[0] + (Get-Random -Minimum 1 -Maximum 3)
      $this.answers += $this.answers[0] - (Get-Random -Minimum 1 -Maximum 3)
      $randSign = if ((Get-Random -Maximum 10) -lt 5) { -1 } else { 1 }
      $this.answers += $this.answers[0] + $randSign * (Get-Random -Minimum 4 -Maximum 8)
    } else {
      [String[]]$operators = @("+", "-", "x", "/")
      for ($i = 0; $i -lt 4; $i++) {
        if ($operators[$i] -ne $this.answers[0]) {
          $this.answers += $operators[$i]
        }
      }
    }
    $this.answers = $this.answers | Sort-Object {Get-Random}
    for ($i = 0; $i -lt 4; $i++) {
      $x = ($i*350) + 100
      $y = Get-Random -Minimum 130 -Maximum 600
      $this.answersPosition += (New-Rectangle $x $y 40 40)
    }
  }

  checkCollision([float]$headX, [float]$headY) {
    if ($this.selectedAnswer -ge 0) {
      return
    }
    for ($i = 0; $i -lt 4; $i++) {
      $col = collisionRectPoint $this.answersPosition[$i] $headX $headY
      if ($col) {
        $this.selectedAnswer = $i
        break
      }
    }
  }

  checkAnswer() {
    if ($this.tokenList[$this.unknownIndex] -is [Array]) {
      $this.tokenList[$this.unknownIndex][0] = $this.answers[$this.selectedAnswer]
    } else {
      $this.tokenList[$this.unknownIndex] = $this.answers[$this.selectedAnswer]
    }
    $equationStr = ""
    for ($i = 0; $i -lt $this.tokenList.Count; $i++) {
      $token = if ($this.tokenList[$i][0] -eq "x") { "*" } else { $this.tokenList[$i][0] }
      if ($token -is [int] -and $token -lt 0) {
        $token = "($token)"
      }
      $equationStr += $token.ToString()
    }
    try {
      [int]$userResult = Invoke-Expression $equationStr      
    } catch {
      # To avoid division by zero error
      [int]$userResult = -1
    }
    $equationStr = $equationStr.Replace("*", "x")
    if ($userResult -eq $this.result) {
      $this.state = [EquationState]::Correct
      $this.eqStr = $equationStr + "=$userResult"
      $this.correctAnswers++
      #$this.eqColor = New-Color 0 255 0 255
    } else {
      $this.state = [EquationState]::Incorrect
      $this.eqStr = $equationStr + "NOT=" + $this.result.ToString()
      #$this.eqColor = New-Color 255 0 0 255
    }
    $this.resetTimer = 3.0
  }

  drawAnswers() {
    for ($i = 0; $i -lt $this.answersPosition.Count; $i++) {
      $rect = $this.answersPosition[$i]
      [Raylib]::DrawRectangleRec($this.answersPosition[$i], $this.eqColor)
      [Raylib]::DrawText($this.answers[$i], $rect.x+3, $rect.y, 40, $this.answerColor)
    }
  }

  draw() {
    [Raylib]::DrawText("Remember: PEMDAS", 950, 40, 30, $this.eqColor)
    [Raylib]::DrawText("Correct answers: " + $this.correctAnswers.ToString(), 950, 70, 30, $this.eqColor)
    [Raylib]::DrawText($this.eqStr, 250, 40, 80, $this.eqColor)
    if ($this.state -eq [EquationState]::Correct) {
      [Raylib]::DrawText("Correct!", 10, 40, 40, $this.correctColor)  
    } elseif ($this.state -eq [EquationState]::Incorrect) {
      [Raylib]::DrawText("Incorrect!", 10, 40, 40, $this.incorrectColor)
    }
  }
}