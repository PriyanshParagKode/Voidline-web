import os
import json

# Read all files
with open('index.html', 'r', encoding='utf-8') as f:
    html = f.read()

with open('styles.css', 'r', encoding='utf-8') as f:
    css = f.read()

with open('vendor/three.min.js', 'r', encoding='utf-8') as f:
    three = f.read()

with open('src/audio.js', 'r', encoding='utf-8') as f:
    audio = f.read()

with open('src/models.js', 'r', encoding='utf-8') as f:
    models = f.read()

with open('src/ui.js', 'r', encoding='utf-8') as f:
    ui = f.read()

with open('src/game.js', 'r', encoding='utf-8') as f:
    game = f.read()

with open('src/main.js', 'r', encoding='utf-8') as f:
    main = f.read()

# Replace CSS link with style tag
html_out = html.replace('<link rel="stylesheet" href="styles.css" />', '<style>\n' + css + '\n</style>')

# Remove script tags
html_out = html_out.replace('  <script src="vendor/three.min.js"></script>\n', '')
html_out = html_out.replace('  <script src="src/audio.js"></script>\n', '')
html_out = html_out.replace('  <script src="src/models.js"></script>\n', '')
html_out = html_out.replace('  <script src="src/ui.js"></script>\n', '')
html_out = html_out.replace('  <script src="src/game.js"></script>\n', '')
html_out = html_out.replace('  <script src="src/main.js"></script>\n', '')

# Add all scripts before </body>
scripts = '\n<script>\n// === THREE ===\n' + three + '\n// === AUDIO ===\n' + audio + '\n// === MODELS ===\n' + models + '\n// === UI ===\n' + ui + '\n// === GAME ===\n' + game + '\n// === MAIN ===\n' + main + '\n</script>\n'
html_out = html_out.replace('</body>', scripts + '</body>')

# Write
with open('VOIDLINE_Standalone.html', 'w', encoding='utf-8') as f:
    f.write(html_out)

print('done')
