import os
import sys
import re
import subprocess

sys.path.append(os.path.dirname(__file__))
from tree_data import PAGES
from generate_html import generate_page_svg

OUTPUT_DIR = "/Users/tushar/Desktop/tracker1/lib/resourse"
os.makedirs(OUTPUT_DIR, exist_ok=True)

CHROME_BIN = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

def sanitize_filename(title):
    # e.g. "1. Login Screen" -> "01_login_screen"
    parts = title.split(".", 1)
    num = int(parts[0].strip())
    name = parts[1].strip()
    slug = re.sub(r'[^a-zA-Z0-9]+', '_', name).strip('_').lower()
    return f"{num:02d}_{slug}"

print(f"Exporting {len(PAGES)} images to {OUTPUT_DIR}...")

svg_files = []
for p in PAGES:
    filename_base = sanitize_filename(p["title"])
    svg_filename = f"{filename_base}.svg"
    svg_path = os.path.join(OUTPUT_DIR, svg_filename)
    
    svg_content = generate_page_svg(p)
    with open(svg_path, "w", encoding="utf-8") as f:
        f.write(svg_content)
        
    svg_files.append((filename_base, svg_path))

print(f"Generated {len(svg_files)} SVG files.")

# Now convert each SVG to PNG using headless Chrome
has_chrome = os.path.exists(CHROME_BIN)
if has_chrome:
    print("Converting SVGs to PNGs using Chrome headless...")
    for filename_base, svg_path in svg_files:
        png_path = os.path.join(OUTPUT_DIR, f"{filename_base}.png")
        
        # Wrap SVG in a minimal HTML file for rendering
        temp_html = os.path.join(OUTPUT_DIR, f"_temp_{filename_base}.html")
        with open(svg_path, "r", encoding="utf-8") as f:
            svg_data = f.read()
            
        html_content = f"""<!DOCTYPE html>
<html>
<head>
  <style>
    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
    body {{ background: white; width: 794px; height: 1123px; overflow: hidden; }}
    svg {{ width: 794px; height: 1123px; display: block; }}
  </style>
</head>
<body>
{svg_data}
</body>
</html>"""
        with open(temp_html, "w", encoding="utf-8") as f:
            f.write(html_content)
            
        cmd = [
            CHROME_BIN,
            "--headless=new",
            "--disable-gpu",
            "--force-device-scale-factor=2",  # Retina 2x crispness
            "--window-size=794,1123",
            f"--screenshot={png_path}",
            f"file://{temp_html}"
        ]
        subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        
        if os.path.exists(temp_html):
            os.remove(temp_html)
            
    print(f"Generated PNG files for all {len(svg_files)} screens!")
else:
    print("Chrome not found; only SVGs generated.")

print("Export complete!")
