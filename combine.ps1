$html = Get-Content -Raw index.html
$css = Get-Content -Raw styles.css
$audio = Get-Content -Raw src/audio.js
$models = Get-Content -Raw src/models.js
$ui = Get-Content -Raw src/ui.js
$game = Get-Content -Raw src/game.js
$main = Get-Content -Raw src/main.js
$three = Get-Content -Raw vendor/three.min.js

$out = $html
$out = $out.Replace('<link rel="stylesheet" href="styles.css" />', '<style>' + "`n" + $css + "`n" + '</style>')
$out = $out.Replace("  <script src=`"vendor/three.min.js`"></script>`n", "")
$out = $out.Replace("  <script src=`"src/audio.js`"></script>`n", "")
$out = $out.Replace("  <script src=`"src/models.js`"></script>`n", "")
$out = $out.Replace("  <script src=`"src/ui.js`"></script>`n", "")
$out = $out.Replace("  <script src=`"src/game.js`"></script>`n", "")
$out = $out.Replace("  <script src=`"src/main.js`"></script>`n", "")

$scripts = "`n<script>`n"
$scripts += "// === THREE.JS ===`n" + $three + "`n"
$scripts += "// === AUDIO ===`n" + $audio + "`n"
$scripts += "// === MODELS ===`n" + $models + "`n"
$scripts += "// === UI ===`n" + $ui + "`n"
$scripts += "// === GAME ===`n" + $game + "`n"
$scripts += "// === MAIN ===`n" + $main + "`n"
$scripts += "</script>`n"
$out = $out.Replace("</body>", $scripts + "</body>")

$out | Out-File -FilePath VOIDLINE_Standalone.html -Encoding UTF8
Write-Host "Done"
