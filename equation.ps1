using namespace System.Collections

enum EquationType {
  Operator = 0
  Number
}

class Equation {
  static $precedence = @{ "+" = 0; "-" = 0; "x" = 1; "/" = 1 }
  [EquationType]$type
  [int]$size
  [int]$result
  [int]$unknownIndex
  [ArrayList]$tokenList = @()

  Equation([EquationType]$eqType) {
    $this.type = $eqType
    $this.size = Get-Random -Minimum 2 -Maximum 5
    $this.tokenList = @()
    $this.unknownIndex = 0
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

    # Division: remainder always zero.
    # Multiplication: no huge numbers.
    # Substraction: avoid negative numbers.
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
          }
          "-" {
            $maxRand = [int]($num[0]/2 + 1) 
            $num2[0] = Get-Random -Maximum $maxRand
          }
        }
        $opResult = [Equation]::performOperation($num[0], $num2[0], $token)
        $res += , @($opResult, -1)
      }
    }
    $this.result = $res[0][0]
    $divUnknown = if ($this.type -eq [EquationType]::Operator) { 1 } else { 0 }
    do {
      $this.unknownIndex = Get-Random -Minimum 1 -Maximum ($this.size+1)
    } while ($this.unknownIndex % 2 -ne $divUnknown)
  }
}