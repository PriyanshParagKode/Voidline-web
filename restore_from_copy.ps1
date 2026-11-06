$ErrorActionPreference = 'Stop'
Set-Location 'C:\Users\admin\Documents\Default Project'
$copy = 'VOIDLINE_Standalone - Copy.html'
$s = [System.IO.File]::ReadAllText($copy)

# Extract CSS
$styleStart = $s.IndexOf('<style>')
$styleEnd = $s.IndexOf('</style>')
if ($styleStart -lt 0 -or $styleEnd -lt 0) { throw 'style tags not found' }
$css = $s.Substring($styleStart + 7, $styleEnd - ($styleStart + 7))
# Trim leading/trailing newlines that wrap the style block
$css = $css -replace "^\r?\n", "" -replace "\r?\n$", ""
[System.IO.File]::WriteAllText('styles.css', $css, [System.Text.UTF8Encoding]::new($false))

# Build source index.html: head with link, body up to external scripts, external scripts, close
# Find the title line end and replace style block area
$beforeStyle = $s.Substring(0, $styleStart)
# beforeStyle ends around <title>...</title>\n - replace the style tag with link
$afterStyle = $s.Substring($styleEnd + 8) # after </style>
# afterStyle starts with \n</head>\n<body>... up to external scripts
$extScriptStart = $afterStyle.IndexOf('<script src="vendor/three.min.js"></script>')
if ($extScriptStart -lt 0) { throw 'external scripts not found' }
$bodyPart = $afterStyle.Substring(0, $extScriptStart)
# Find end of external scripts block (ends with main.js script tag line)
$extEndMarker = '<script src="src/main.js"></script>'
$extEnd = $afterStyle.IndexOf($extEndMarker)
if ($extEnd -lt 0) { throw 'main script ref not found' }
$extEnd += $extEndMarker.Length
$extScripts = $afterStyle.Substring($extScriptStart, $extEnd - $extScriptStart).TrimEnd()

$indexHtml = $beforeStyle.TrimEnd() + "`n<link rel=`"stylesheet`" href=`"styles.css`" />" + $bodyPart.TrimEnd() + "`n`n" + $extScripts + "`n</body>`n</html>`n"
[System.IO.File]::WriteAllText('index.html', $indexHtml, [System.Text.UTF8Encoding]::new($false))

# Extract inlined JS bundle
$bundleStart = $s.IndexOf('// === THREE.JS ===')
$audioMark = $s.IndexOf('// === AUDIO ===')
$modelsMark = $s.IndexOf('// === MODELS ===')
$uiMark = $s.IndexOf('// === UI ===')
$gameMark = $s.IndexOf('// === GAME ===')
$mainMark = $s.IndexOf('// === MAIN ===')
$bundleEnd = $s.LastIndexOf('</script>')
if ($bundleStart -lt 0 -or $bundleEnd -lt 0) { throw 'bundle markers not found' }

function Extract-Between($text, $startIdx, $endIdx) {
  $chunk = $text.Substring($startIdx, $endIdx - $startIdx)
  # remove the marker line itself
  $chunk = $chunk -replace "^// === [^=]+ ===\s*\r?\n?", ""
  return $chunk.Trim() + "`n"
}

$three = $s.Substring($bundleStart, $audioMark - $bundleStart) -replace "^// === THREE\.JS ===\s*\r?\n?", ""
$three = $three.Trim() + "`n"
$audio = Extract-Between $s $audioMark $modelsMark
$models = Extract-Between $s $modelsMark $uiMark
$ui = Extract-Between $s $uiMark $gameMark
$game = Extract-Between $s $gameMark $mainMark
$main = $s.Substring($mainMark, $bundleEnd - $mainMark) -replace "^// === MAIN ===\s*\r?\n?", ""
$main = $main.Trim() + "`n"

[System.IO.File]::WriteAllText('vendor/three.min.js', $three, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText('src/audio.js', $audio, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText('src/models.js', $models, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText('src/ui.js', $ui, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText('src/game.js', $game, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText('src/main.js', $main, [System.Text.UTF8Encoding]::new($false))

Write-Host "RESTORED"
Get-Item index.html,styles.css,vendor/three.min.js,src/audio.js,src/models.js,src/ui.js,src/game.js,src/main.js | Select-Object Name,Length
