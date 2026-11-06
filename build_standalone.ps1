$ErrorActionPreference = 'Stop'
Set-Location 'C:\Users\admin\Documents\Default Project'

$html = [System.IO.File]::ReadAllText('index.html')
$css = [System.IO.File]::ReadAllText('styles.css')
$three = [System.IO.File]::ReadAllText('vendor/three.min.js')
$audio = [System.IO.File]::ReadAllText('src/audio.js')
$models = [System.IO.File]::ReadAllText('src/models.js')
$ui = [System.IO.File]::ReadAllText('src/ui.js')
$game = [System.IO.File]::ReadAllText('src/game.js')
$main = [System.IO.File]::ReadAllText('src/main.js')

# Inline CSS
$out = $html.Replace('<link rel="stylesheet" href="styles.css" />', "<style>`n" + $css + "`n</style>")

# Remove external script tags (handle possible leading whitespace/newlines)
$out = [regex]::Replace($out, '\s*<script src="vendor/three\.min\.js"></script>\s*', "`n")
$out = [regex]::Replace($out, '\s*<script src="src/audio\.js"></script>\s*', "`n")
$out = [regex]::Replace($out, '\s*<script src="src/models\.js"></script>\s*', "`n")
$out = [regex]::Replace($out, '\s*<script src="src/ui\.js"></script>\s*', "`n")
$out = [regex]::Replace($out, '\s*<script src="src/game\.js"></script>\s*', "`n")
$out = [regex]::Replace($out, '\s*<script src="src/main\.js"></script>\s*', "`n")

$scripts = @"
<script>
// === THREE ===
$three
// === AUDIO ===
$audio
// === MODELS ===
$models
// === UI ===
$ui
// === GAME ===
$game
// === MAIN ===
$main
</script>
"@

$out = $out.Replace('</body>', $scripts + "`n</body>")
$outPath = 'VOIDLINE_Standalone.html'
[System.IO.File]::WriteAllText($outPath, $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "OK"
Write-Host ([System.IO.FileInfo]$outPath).Length
