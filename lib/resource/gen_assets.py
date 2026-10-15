#!/usr/bin/env python3
"""
Generate all PNG assets for the tracker1 Flutter app resource folder.
Uses only stdlib + struct to write valid minimal PNG files.
"""
import os, struct, zlib, math

BASE = "/Users/tushar/Desktop/tracker1/lib/resource"

# ── PNG writer ──────────────────────────────────────────────────────────────
def _crc(data): return zlib.crc32(data) & 0xFFFFFFFF

def _chunk(tag, data):
    b = tag + data
    return struct.pack('>I', len(data)) + b + struct.pack('>I', _crc(b))

def write_png(path, pixels, w, h):
    """pixels: list of (r,g,b,a) tuples, row-major."""
    raw = b''
    for y in range(h):
        raw += b'\x00'
        for x in range(w):
            r,g,b,a = pixels[y*w + x]
            raw += bytes([r,g,b,a])
    compressed = zlib.compress(raw, 9)
    sig = b'\x89PNG\r\n\x1a\n'
    ihdr = _chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0))
    idat = _chunk(b'IDAT', compressed)
    iend = _chunk(b'IEND', b'')
    with open(path, 'wb') as f:
        f.write(sig + ihdr + idat + iend)
    print(f"  created: {os.path.relpath(path, BASE + '/..')}")

# ── Color helpers ────────────────────────────────────────────────────────────
def hex_to_rgba(h, a=255):
    h = h.lstrip('#')
    r,g,b = int(h[0:2],16), int(h[2:4],16), int(h[4:6],16)
    return (r,g,b,a)

def lerp_color(c1, c2, t):
    return tuple(int(c1[i] + (c2[i]-c1[i])*t) for i in range(4))

# ── Pixel generators ─────────────────────────────────────────────────────────

def solid(w, h, color):
    return [color] * (w*h)

def gradient_h(w, h, c1, c2):
    return [lerp_color(c1, c2, x/(w-1)) for y in range(h) for x in range(w)]

def gradient_v(w, h, c1, c2):
    return [lerp_color(c1, c2, y/(h-1)) for y in range(h) for x in range(w)]

def gradient_d(w, h, c1, c2):
    """Diagonal top-left → bottom-right."""
    return [lerp_color(c1, c2, (x+y)/((w-1)+(h-1))) for y in range(h) for x in range(w)]

def circle_on_bg(w, h, bg, fg, margin=0.15):
    """Draw a filled circle in the center."""
    cx, cy = w/2, h/2
    r = min(w,h) * (0.5 - margin)
    pixels = list(bg) if isinstance(bg, list) else solid(w, h, bg)
    for y in range(h):
        for x in range(w):
            if (x-cx)**2 + (y-cy)**2 <= r**2:
                pixels[y*w+x] = fg
    return pixels

def wallet_icon(w, h, bg_color, fg_color):
    """Simple wallet shape on background."""
    pixels = solid(w, h, bg_color)
    # card body
    px1, px2 = int(w*0.15), int(w*0.85)
    py1, py2 = int(h*0.30), int(h*0.75)
    # flap
    fp1, fp2 = int(h*0.20), int(h*0.35)
    for y in range(h):
        for x in range(w):
            in_body = px1 <= x <= px2 and py1 <= y <= py2
            in_flap = px1 <= x <= px2 and fp1 <= y <= fp2
            # pocket circle
            pcx, pcy, pr = int(w*0.72), int(h*0.52), int(w*0.08)
            in_pocket = (x-pcx)**2 + (y-pcy)**2 <= pr**2
            if in_body or in_flap:
                pixels[y*w+x] = fg_color
            if in_pocket:
                pixels[y*w+x] = bg_color
    return pixels

def chart_bars(w, h, bg, bars_color, accent):
    """Simple bar chart illustration."""
    pixels = solid(w, h, bg)
    heights = [0.4, 0.7, 0.55, 0.9, 0.65, 0.80]
    n = len(heights)
    bw = int(w * 0.10)
    gap = int((w - n*bw) / (n+1))
    base_y = int(h * 0.82)
    for i, ht in enumerate(heights):
        bx = gap + i*(bw+gap)
        by = int(base_y - ht*h*0.55)
        color = accent if i == 3 else bars_color
        for y in range(by, base_y):
            for x in range(bx, bx+bw):
                if 0 <= x < w and 0 <= y < h:
                    pixels[y*w+x] = color
    return pixels

def piggy_bank(w, h, bg):
    """Piggy bank silhouette."""
    pixels = solid(w, h, bg)
    pig = (0xFF, 0x6B, 0x6B, 255)
    coin = (0xFF, 0xD7, 0x00, 255)
    cx, cy, r = int(w*0.48), int(h*0.55), int(min(w,h)*0.32)
    # body
    for y in range(h):
        for x in range(w):
            if (x-cx)**2 + (y-cy)**2 <= r**2:
                pixels[y*w+x] = pig
    # coin slot (top center)
    slot_x, slot_y = int(w*0.48), int(h*0.22)
    for y in range(slot_y, slot_y+int(h*0.04)):
        for x in range(slot_x-int(w*0.06), slot_x+int(w*0.06)):
            if 0<=x<w and 0<=y<h:
                pixels[y*w+x] = coin
    # snout
    sx, sy, sr = int(w*0.78), int(h*0.55), int(min(w,h)*0.10)
    for y in range(h):
        for x in range(w):
            if (x-sx)**2 + (y-sy)**2 <= sr**2:
                pixels[y*w+x] = (0xFF,0x8E,0x8E,255)
    return pixels

def empty_box(w, h, bg):
    """Empty box / inbox illustration."""
    pixels = solid(w, h, bg)
    box = (0xCB, 0xD5, 0xE1, 255)  # slate-300
    lid = (0x94, 0xA3, 0xB8, 255)  # slate-400
    # box body
    bx1, bx2 = int(w*0.20), int(w*0.80)
    by1, by2 = int(h*0.42), int(h*0.78)
    for y in range(by1, by2):
        for x in range(bx1, bx2):
            pixels[y*w+x] = box
    # box lid
    for y in range(int(h*0.30), by1):
        for x in range(int(w*0.15), int(w*0.85)):
            pixels[y*w+x] = lid
    # x mark
    xc, yc = int(w*0.5), int(h*0.55)
    xr = int(w*0.08)
    for i in range(-xr, xr+1):
        for t in range(-2, 3):
            if 0<=xc+i+t<w and 0<=yc+i<h: pixels[(yc+i)*w+(xc+i+t)] = (0xFF,0xFF,0xFF,200)
            if 0<=xc+i+t<w and 0<=yc-i<h: pixels[(yc-i)*w+(xc+i+t)] = (0xFF,0xFF,0xFF,200)
    return pixels

def no_wifi(w, h, bg):
    """No internet illustration (wifi waves)."""
    pixels = solid(w, h, bg)
    cx, cy = int(w*0.5), int(h*0.62)
    dot_c = (0xEF, 0x44, 0x44, 255)
    wave_c = (0xCB, 0xD5, 0xE1, 255)
    # dot
    dr = int(min(w,h)*0.05)
    for y in range(h):
        for x in range(w):
            if (x-cx)**2 + (y-cy)**2 <= dr**2:
                pixels[y*w+x] = dot_c
    # broken arcs (simplified as thick semicircles)
    for arc_r in [int(min(w,h)*0.16), int(min(w,h)*0.28), int(min(w,h)*0.40)]:
        for y in range(0, cy):
            for x in range(w):
                dist = math.sqrt((x-cx)**2 + (y-cy)**2)
                if arc_r-int(w*0.03) <= dist <= arc_r:
                    pixels[y*w+x] = wave_c
    # strike-through line
    for y in range(int(h*0.15), int(h*0.85)):
        for t in range(-int(w*0.015), int(w*0.015)+1):
            x = int(cx + t + (y - h*0.5)*0.35)
            if 0<=x<w: pixels[y*w+x] = dot_c
    return pixels

def profile_avatar(w, h, bg, skin, hair):
    """Simple profile avatar."""
    pixels = solid(w, h, bg)
    cx, cy = w//2, h//2
    # head
    hr = int(min(w,h)*0.28)
    for y in range(h):
        for x in range(w):
            if (x-cx)**2 + (y-(cy-int(h*0.05)))**2 <= hr**2:
                pixels[y*w+x] = skin
    # hair cap (top half circle)
    for y in range(h):
        for x in range(w):
            d = (x-cx)**2 + (y-(cy-int(h*0.05)))**2
            if d <= hr**2 and y < cy - int(h*0.05):
                pixels[y*w+x] = hair
    # body (rounded rect below)
    bx1, bx2 = cx-int(w*0.30), cx+int(w*0.30)
    by1, by2 = cy+int(h*0.20), cy+int(h*0.52)
    for y in range(by1, min(by2,h)):
        for x in range(bx1, bx2):
            if 0<=x<w: pixels[y*w+x] = skin
    return pixels

def success_check(w, h, bg, circle_c, check_c):
    """Success checkmark."""
    pixels = solid(w, h, bg)
    cx, cy = w//2, h//2
    r = int(min(w,h)*0.38)
    for y in range(h):
        for x in range(w):
            if (x-cx)**2 + (y-cy)**2 <= r**2:
                pixels[y*w+x] = circle_c
    # checkmark (two lines)
    def draw_thick_line(x0,y0,x1,y1,color,thick=int(min(w,h)*0.045)):
        steps = max(abs(x1-x0), abs(y1-y0))
        for i in range(steps+1):
            t = i/steps if steps else 0
            px = int(x0 + (x1-x0)*t)
            py = int(y0 + (y1-y0)*t)
            for dy in range(-thick, thick+1):
                for dx in range(-thick, thick+1):
                    nx, ny = px+dx, py+dy
                    if 0<=nx<w and 0<=ny<h:
                        pixels[ny*w+nx] = color
    draw_thick_line(int(cx-r*0.38), int(cy+r*0.02), int(cx-r*0.05), int(cy+r*0.35), check_c)
    draw_thick_line(int(cx-r*0.05), int(cy+r*0.35), int(cx+r*0.42), int(cy-r*0.30), check_c)
    return pixels

def loading_spinner(w, h, bg, c1, c2):
    """Circular loading ring."""
    pixels = solid(w, h, bg)
    cx, cy = w//2, h//2
    outer = int(min(w,h)*0.42)
    inner = int(min(w,h)*0.30)
    for y in range(h):
        for x in range(w):
            d = math.sqrt((x-cx)**2 + (y-cy)**2)
            if inner <= d <= outer:
                angle = math.atan2(y-cy, x-cx)
                t = (angle + math.pi) / (2*math.pi)
                if t < 0.75:
                    pixels[y*w+x] = lerp_color(c1, c2, t/0.75)
    return pixels

# ── Generate all images ──────────────────────────────────────────────────────
print("Generating images...")

SLATE900 = (0x0F, 0x17, 0x2A, 255)
SLATE800 = (0x1E, 0x29, 0x3B, 255)
WHITE    = (0xFF, 0xFF, 0xFF, 255)
INDIG500 = (0x63, 0x66, 0xF1, 255)
EMER500  = (0x10, 0xB9, 0x81, 255)
RED500   = (0xEF, 0x44, 0x44, 255)
BGLIGHT  = (0xF9, 0xFA, 0xFB, 255)
BGLIGHT2 = (0xF1, 0xF5, 0xF9, 255)
TRANS    = (0x00, 0x00, 0x00, 0)

# images/
px = wallet_icon(512, 512, SLATE900, WHITE)
write_png(f"{BASE}/images/logo.png", px, 512, 512)

px = wallet_icon(192, 192, SLATE900, WHITE)
write_png(f"{BASE}/images/logo_small.png", px, 192, 192)

px = gradient_d(800, 300, SLATE900, SLATE800)
write_png(f"{BASE}/images/banner.png", px, 800, 300)

for i, (c1, c2, title_c) in enumerate([
    (SLATE900, (0x1E,0x29,0x3B,255), WHITE),
    ((0x06,0x4E,0x3B,255), (0x10,0xB9,0x81,255), WHITE),
    ((0x31,0x24,0x8A,255), INDIG500, WHITE),
], start=1):
    px = gradient_d(600, 600, c1, c2)
    write_png(f"{BASE}/images/onboarding_{i}.png", px, 600, 600)

px = gradient_d(800, 400, SLATE900, (0x1e,0x29,0x3b,255))
write_png(f"{BASE}/images/background.png", px, 800, 400)

px = chart_bars(600, 400, BGLIGHT, (0xCB,0xD5,0xE1,255), INDIG500)
write_png(f"{BASE}/images/illustration_analytics.png", px, 600, 400)

px = piggy_bank(600, 500, BGLIGHT)
write_png(f"{BASE}/images/illustration_savings.png", px, 600, 500)

# icons/
def make_icon(w, h, bg, fg, shape='circle'):
    if shape == 'circle':
        return circle_on_bg(w, h, bg, fg, margin=0.22)
    return solid(w, h, fg)

icon_defs = [
    ("ic_dashboard",    SLATE900, WHITE),
    ("ic_add",          EMER500,  WHITE),
    ("ic_budget",       INDIG500, WHITE),
    ("ic_reports",      (0x0E,0xA5,0xE9,255), WHITE),
    ("ic_goals",        (0xF5,0x9E,0x0B,255), WHITE),
    ("ic_bills",        (0x3B,0x82,0xF6,255), WHITE),
    ("ic_notes",        (0x8B,0x5C,0xF6,255), WHITE),
    ("ic_subscriptions",(0xEC,0x48,0x99,255), WHITE),
    ("ic_loans",        (0xEF,0x44,0x44,255), WHITE),
    ("ic_tax",          (0x06,0x4E,0x3B,255), WHITE),
    ("ic_export",       SLATE900, WHITE),
    ("ic_profile",      SLATE800, WHITE),
    ("ic_settings",     (0x64,0x74,0x8B,255), WHITE),
    ("ic_search",       SLATE800, WHITE),
    ("ic_analytics",    INDIG500, WHITE),
    ("ic_net_worth",    EMER500,  WHITE),
    ("ic_food",         (0xF9,0x73,0x16,255), WHITE),
    ("ic_transport",    (0x8B,0x5C,0xF6,255), WHITE),
    ("ic_shopping",     (0x14,0xB8,0xA6,255), WHITE),
    ("ic_entertainment",(0xEC,0x48,0x99,255), WHITE),
    ("ic_health",       (0x10,0xB9,0x81,255), WHITE),
    ("ic_education",    INDIG500, WHITE),
    ("ic_salary",       EMER500,  WHITE),
    ("ic_investments",  (0x02,0x84,0xC7,255), WHITE),
    ("ic_other",        (0x64,0x74,0x8B,255), WHITE),
]
for name, bg, fg in icon_defs:
    px = make_icon(96, 96, bg, fg)
    write_png(f"{BASE}/icons/{name}.png", px, 96, 96)

# placeholders/
px = empty_box(400, 300, BGLIGHT)
write_png(f"{BASE}/placeholders/empty_state.png", px, 400, 300)

px = no_wifi(400, 300, BGLIGHT)
write_png(f"{BASE}/placeholders/no_internet.png", px, 400, 300)

px = solid(400, 300, BGLIGHT2)
write_png(f"{BASE}/placeholders/placeholder.png", px, 400, 300)

px = solid(400, 200, BGLIGHT2)
write_png(f"{BASE}/placeholders/no_data.png", px, 400, 200)

px = profile_avatar(200, 200, BGLIGHT2, (0xF9,0xD5,0xC0,255), (0x4A,0x3F,0x35,255))
write_png(f"{BASE}/placeholders/avatar_placeholder.png", px, 200, 200)

# animations/
px = loading_spinner(200, 200, (0,0,0,0), INDIG500, (0x81,0x8C,0xF8,255))
write_png(f"{BASE}/animations/loading.png", px, 200, 200)

px = success_check(200, 200, (0,0,0,0), EMER500, WHITE)
write_png(f"{BASE}/animations/success.png", px, 200, 200)

print("Done! All assets generated.")
