$html = Get-Content -Raw index.html
$css = Get-Content -Raw styles.css
$three = Get-Content -Raw vendor/three.min.js
$audio = Get-Content -Raw src/audio.js
$models = Get-Content -Raw src/models.js
$ui = Get-Content -Raw src/ui.js
$game = Get-Content -Raw src/game.js
$main = Get-Content -Raw src/main.js

$out = $html -replace '<link rel="stylesheet" href="styles.css" />', "<style>`n$css`n</style>"
$out = $out -replace '  <script src="vendor/three.min.js"></script>`r`n', ''
$out = $out -replace '  <script src="src/audio.js"></script>`r`n', ''
$out = $out -replace '  <script src="src/models.js"></script>`r`n', ''
$out = $out -replace '  <script src="src/ui.js"></script>`r`n', ''
$out = $out -replace '  <script src="src/game.js"></script>`r`n', ''
$out = $out -replace '  <script src="src/main.js"></script>`r`n', ''

$scripts = "`n<script>`n// === THREE ===`n$three`n// === AUDIO ===`n$audio`n// === MODELS ===`n$models`n// === UI ===`n$ui`n// === GAME ===`n$game`n// === MAIN ===`n$main`n</script>`n"
$out = $out -replace '</body>', "$scripts</body>"

Set-Content -Path VOIDLINE_Standalone.html -Value $out
Write-Host "done"
