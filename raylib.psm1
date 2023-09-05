$compParam = New-Object System.CodeDom.Compiler.CompilerParameters
$compParam.CompilerOptions = "/unsafe"

$raylibFile = Get-Content .\raylib.cs -Raw
Add-Type -TypeDefinition $raylibFile -CompilerParameters $compParam

function New-Rectangle([float]$x, [float]$y, [float]$width, [float]$height) {
    return New-Object Rectangle($x, $y, $width, $height)
}

function New-Color([byte]$r, [byte]$g, [byte]$b, [byte]$a) {
    $col = New-Object Color
    $col.r = $r
    $col.g = $g
    $col.b = $b
    $col.a = $a
    return $col
}

function New-Vector2([float]$x, [float]$y) {
    return New-Object Vector2($x, $y)
}

function New-Camera2D([float]$offsetX, [float]$offsetY, [float]$targetX, [float]$targetY, [float]$rotation, [float]$zoom) {
    return New-Object Camera2D($offsetX, $offsetY, $targetX, $targetY, $rotation, $zoom)
}