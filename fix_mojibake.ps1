$ErrorActionPreference = 'Stop'
$p = 'C:\Users\admin\Documents\Default Project\index.html'
$c = [System.IO.File]::ReadAllText($p)
# common mojibake (UTF-8 bytes interpreted as Latin-1/Windows-1252 then saved oddly)
$replacements = @(
  @('Â·', '·'),
  @('â€¹', '‹'),
  @('â€º', '›'),
  @('â€”', '—'),
  @('â€“', '–'),
  @('â€™', "'"),
  @('â€œ', '"'),
  @('â€', '"'),
  @('Ã—', '×'),
  @('âœ•', '✕')
)
foreach ($r in $replacements) { $c = $c.Replace($r[0], $r[1]) }
# close button garble seen in grep/read
$c = $c.Replace('�o' + [char]7, '✕')
$c = $c.Replace('�?s�?s', '❚❚')
$c = $c.Replace('�?s', '❚')
[System.IO.File]::WriteAllText($p, $c, [System.Text.UTF8Encoding]::new($false))
'ok'