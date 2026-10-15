import os
import subprocess

OUTPUT_DIR = "/Users/tushar/Desktop/tracker1/lib/resourse"
CHROME_BIN = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

placeholders = {
    "placeholder": {
        "w": 400, "h": 300,
        "svg": '''
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="300" viewBox="0 0 400 300">
  <rect width="400" height="300" rx="16" fill="#F1F5F9" stroke="#CBD5E1" stroke-width="2" stroke-dasharray="8 8"/>
  <circle cx="200" cy="130" r="42" fill="#E2E8F0"/>
  <path d="M185 130 L195 115 L215 140 L225 130 L235 145" stroke="#94A3B8" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <circle cx="190" cy="118" r="4" fill="#94A3B8"/>
  <text x="200" y="200" text-anchor="middle" font-family="-apple-system, sans-serif" font-size="14" font-weight="600" fill="#64748B">Image Placeholder</text>
  <text x="200" y="222" text-anchor="middle" font-family="-apple-system, sans-serif" font-size="12" fill="#94A3B8">400 x 300</text>
</svg>'''
    },
    "avatar_placeholder": {
        "w": 256, "h": 256,
        "svg": '''
<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256">
  <circle cx="128" cy="128" r="128" fill="#F1F5F9"/>
  <circle cx="128" cy="128" r="126" fill="none" stroke="#CBD5E1" stroke-width="2"/>
  <circle cx="128" cy="100" r="44" fill="#94A3B8"/>
  <path d="M52 216 C60 170 90 156 128 156 C166 156 196 170 204 216 Z" fill="#94A3B8"/>
</svg>'''
    },
    "card_placeholder": {
        "w": 400, "h": 240,
        "svg": '''
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240" viewBox="0 0 400 240">
  <defs>
    <linearGradient id="cardGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#1E293B"/>
      <stop offset="100%" stop-color="#0F172A"/>
    </linearGradient>
  </defs>
  <rect width="400" height="240" rx="20" fill="url(#cardGrad)"/>
  <rect x="30" y="70" width="50" height="38" rx="6" fill="#F59E0B" opacity="0.85"/>
  <text x="30" y="160" font-family="monospace" font-size="18" fill="#F8FAFC" letter-spacing="3">••••  ••••  ••••  4242</text>
  <text x="30" y="205" font-family="-apple-system, sans-serif" font-size="13" font-weight="600" fill="#94A3B8">CARDHOLDER</text>
  <text x="320" y="205" font-family="-apple-system, sans-serif" font-size="13" fill="#94A3B8">12/28</text>
</svg>'''
    },
    "empty_placeholder": {
        "w": 400, "h": 320,
        "svg": '''
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="320" viewBox="0 0 400 320">
  <rect width="400" height="320" fill="#FAFAFA"/>
  <circle cx="200" cy="130" r="56" fill="#F1F5F9" stroke="#E2E8F0" stroke-width="2"/>
  <path d="M180 120 L220 120 M180 135 L210 135 M180 150 L200 150" stroke="#94A3B8" stroke-width="3" stroke-linecap="round"/>
  <text x="200" y="225" text-anchor="middle" font-family="-apple-system, sans-serif" font-size="16" font-weight="600" fill="#334155">No Data Found</text>
  <text x="200" y="250" text-anchor="middle" font-family="-apple-system, sans-serif" font-size="13" fill="#94A3B8">Add an item to get started</text>
</svg>'''
    },
    "logo_placeholder": {
        "w": 256, "h": 256,
        "svg": '''
<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256">
  <defs>
    <linearGradient id="logoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#4F46E5"/>
      <stop offset="100%" stop-color="#06B6D4"/>
    </linearGradient>
  </defs>
  <rect width="256" height="256" rx="54" fill="url(#logoGrad)"/>
  <path d="M80 176 L116 110 L146 148 L176 96" stroke="#FFFFFF" stroke-width="12" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <circle cx="176" cy="96" r="8" fill="#FFFFFF"/>
</svg>'''
    }
}

for name, item in placeholders.items():
    svg_file = os.path.join(OUTPUT_DIR, f"{name}.svg")
    png_file = os.path.join(OUTPUT_DIR, f"{name}.png")
    
    with open(svg_file, "w", encoding="utf-8") as f:
        f.write(item["svg"])
        
    temp_html = os.path.join(OUTPUT_DIR, f"_temp_{name}.html")
    with open(temp_html, "w", encoding="utf-8") as f:
        f.write(f'''<!DOCTYPE html><html><body style="margin:0;padding:0;background:transparent;">{item["svg"]}</body></html>''')
        
    cmd = [
        CHROME_BIN,
        "--headless=new",
        "--disable-gpu",
        "--force-device-scale-factor=2",
        f"--window-size={item['w']},{item['h']}",
        f"--screenshot={png_file}",
        f"file://{temp_html}"
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if os.path.exists(temp_html):
        os.remove(temp_html)
        
print("Generated 5 placeholder assets (both SVG and PNG) in lib/resourse!")
