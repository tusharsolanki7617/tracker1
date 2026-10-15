import os
import sys

sys.path.append(os.path.dirname(__file__))
from tree_data import PAGES

def get_node_colors(text):
    """
    Returns (bg_color, border_color, text_color) based on widget type.
    Clean, refined pastel palette for CIE-2 documentation.
    """
    t = text.lower()
    if any(t.startswith(w) for w in ["scaffold", "safearea"]):
        return "#EEF2FF", "#6366F1", "#312E81"  # Indigo (Structure)
    elif any(t.startswith(w) for w in ["column", "row", "center", "singlechildscrollview", "body"]):
        return "#F8FAFC", "#94A3B8", "#1E293B"  # Slate (Layout)
    elif any(t.startswith(w) for w in ["appbar", "bottomnavigationbar", "drawer"]):
        return "#FAF5FF", "#A855F7", "#581C87"  # Purple (Navigation)
    elif any(t.startswith(w) for w in ["listview", "gridview"]):
        return "#ECFEFF", "#06B6D4", "#0E7490"  # Cyan (Lists / Grids)
    elif any(t.startswith(w) for w in ["textfield", "dropdownbutton", "datepicker", "switch", "radiolisttile"]):
        return "#FFFBEB", "#F59E0B", "#92400E"  # Amber (Inputs / Form)
    elif any(t.startswith(w) for w in ["elevatedbutton", "textbutton", "floatingactionbutton", "button", "outlinedbutton"]):
        return "#FFF1F2", "#F43F5E", "#9F1239"  # Rose (Buttons / Actions)
    elif any(t.startswith(w) for w in ["container", "card", "listtile", "goalcard", "transactiontile", "itemtile", "statcard", "categorybar", "categoryprogress"]):
        return "#F0FDF4", "#22C55E", "#166534"  # Emerald (Containers / Cards)
    elif any(t.startswith(w) for w in ["text", "icon", "circleavatar", "user avatar", "linearprogressindicator", "divider"]):
        return "#EFF6FF", "#3B82F6", "#1E40AF"  # Blue (Content / Display)
    else:
        return "#F8FAFC", "#64748B", "#0F172A"  # Default

def layout_tree(node, start_x=220, start_y=70, row_height=36, indent=75):
    nodes = []
    lines = []
    current_y = start_y

    def get_box_size(text):
        char_count = len(text)
        w = max(68, char_count * 7.5 + 20)
        h = 24
        return w, h

    def traverse(curr, cur_x, is_root_chain=True):
        nonlocal current_y
        text = curr["name"]
        w, h = get_box_size(text)

        my_node = {
            "text": text,
            "x": cur_x,
            "y": current_y,
            "w": w,
            "h": h
        }
        nodes.append(my_node)

        children = curr.get("children", [])
        if not children:
            current_y += row_height
            return my_node

        if len(children) == 1 and is_root_chain:
            # Single child in root chain: vertically stacked without lines
            current_y += row_height
            traverse(children[0], cur_x, is_root_chain=True)
            return my_node
        else:
            # Branching container
            parent_y = my_node["y"]
            parent_h = my_node["h"]
            spine_x = cur_x  # Spine line aligned with left edge of parent

            current_y += row_height

            child_nodes = []
            for child in children:
                c_node = traverse(child, cur_x + indent, is_root_chain=False)
                child_nodes.append(c_node)

            last_child = child_nodes[-1]

            # Vertical spine line from bottom of parent to last child's center
            spine_top_y = parent_y + parent_h
            spine_bottom_y = last_child["y"] + last_child["h"] / 2

            lines.append({
                "x1": spine_x,
                "y1": spine_top_y,
                "x2": spine_x,
                "y2": spine_bottom_y
            })

            # Horizontal branch lines to each direct child
            for cn in child_nodes:
                tick_y = cn["y"] + cn["h"] / 2
                lines.append({
                    "x1": spine_x,
                    "y1": tick_y,
                    "x2": cn["x"],
                    "y2": tick_y
                })

            return my_node

    traverse(node, start_x, is_root_chain=True)
    return nodes, lines

def generate_page_svg(page_data):
    title = page_data["title"]
    tree = page_data["tree"]

    nodes, lines = layout_tree(tree, start_x=220, start_y=70, row_height=36, indent=75)

    svg_w = 794
    svg_h = 1123

    svg_parts = []
    svg_parts.append(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {svg_w} {svg_h}" class="a4-page">')

    # Ruled lines pattern (matching college lined notebook in PDF)
    svg_parts.append('''
    <defs>
      <pattern id="ruledLines" width="100" height="25" patternUnits="userSpaceOnUse">
        <line x1="0" y1="24.5" x2="100" y2="24.5" stroke="#f1f2f4" stroke-width="1"/>
      </pattern>
    </defs>
    <rect width="100%" height="100%" fill="#ffffff"/>
    <rect width="100%" height="100%" fill="url(#ruledLines)"/>
    ''')

    # Title at top
    svg_parts.append(f'<text x="{svg_w / 2}" y="42" text-anchor="middle" font-family="-apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif" font-size="20" font-weight="600" fill="#1e293b">{title}</text>')

    # Connecting Lines
    for l in lines:
        svg_parts.append(f'<line x1="{l["x1"]:.1f}" y1="{l["y1"]:.1f}" x2="{l["x2"]:.1f}" y2="{l["y2"]:.1f}" stroke="#475569" stroke-width="1.3"/>')

    # Nodes (Rect + Text with category colors)
    for n in nodes:
        x, y, w, h, text = n["x"], n["y"], n["w"], n["h"], n["text"]
        bg_col, border_col, txt_col = get_node_colors(text)
        svg_parts.append(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" rx="4" ry="4" fill="{bg_col}" stroke="{border_col}" stroke-width="1.2"/>')
        text_x = x + w / 2
        text_y = y + h / 2 + 4.2
        svg_parts.append(f'<text x="{text_x:.1f}" y="{text_y:.1f}" text-anchor="middle" font-family="-apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif" font-size="11.5" font-weight="500" fill="{txt_col}">{text}</text>')

    # Footer
    svg_parts.append(f'<text x="{svg_w / 2}" y="{svg_h - 22}" text-anchor="middle" font-family="-apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif" font-size="10.5" fill="#9ca3af">Flutter Structure • CIE-2 • Widget Tree</text>')

    svg_parts.append('</svg>')
    return '\n'.join(svg_parts)

def build_full_html():
    html = ['''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Flutter Structure • CIE-2 • Widget Trees (Color Coded)</title>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    body {
      background-color: #f1f5f9;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      padding: 30px 10px;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    .toolbar {
      position: sticky;
      top: 15px;
      z-index: 100;
      background: rgba(255, 255, 255, 0.96);
      backdrop-filter: blur(12px);
      padding: 12px 28px;
      border-radius: 30px;
      box-shadow: 0 4px 25px rgba(0, 0, 0, 0.1);
      display: flex;
      gap: 16px;
      align-items: center;
      margin-bottom: 24px;
      border: 1px solid #e2e8f0;
      flex-wrap: wrap;
      justify-content: center;
    }
    .toolbar h1 {
      font-size: 15px;
      font-weight: 700;
      color: #0f172a;
    }
    .legend {
      display: flex;
      gap: 10px;
      align-items: center;
      flex-wrap: wrap;
    }
    .legend-item {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      font-size: 11px;
      font-weight: 500;
      color: #334155;
    }
    .legend-dot {
      width: 10px;
      height: 10px;
      border-radius: 3px;
    }
    .toolbar button {
      background: #0f172a;
      color: white;
      border: none;
      padding: 8px 18px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 6px;
      transition: background 0.15s;
    }
    .toolbar button:hover {
      background: #334155;
    }
    .page-container {
      margin-bottom: 30px;
      box-shadow: 0 4px 25px rgba(0, 0, 0, 0.08);
      border-radius: 4px;
      overflow: hidden;
      background: white;
      width: 794px;
      height: 1123px;
    }
    .a4-page {
      width: 794px;
      height: 1123px;
      display: block;
    }
    @media print {
      body {
        background: none;
        padding: 0;
      }
      .toolbar {
        display: none !important;
      }
      .page-container {
        margin: 0;
        box-shadow: none;
        border-radius: 0;
        page-break-after: always;
        width: 100%;
        height: 100vh;
      }
      .a4-page {
        width: 100%;
        height: 100%;
      }
    }
  </style>
</head>
<body>
  <div class="toolbar">
    <h1>Flutter Structure • Widget Trees</h1>
    <div class="legend">
      <span class="legend-item"><span class="legend-dot" style="background:#EEF2FF; border:1px solid #6366F1;"></span>Structure</span>
      <span class="legend-item"><span class="legend-dot" style="background:#FAF5FF; border:1px solid #A855F7;"></span>Navigation</span>
      <span class="legend-item"><span class="legend-dot" style="background:#F0FDF4; border:1px solid #22C55E;"></span>Containers</span>
      <span class="legend-item"><span class="legend-dot" style="background:#ECFEFF; border:1px solid #06B6D4;"></span>Lists</span>
      <span class="legend-item"><span class="legend-dot" style="background:#FFFBEB; border:1px solid #F59E0B;"></span>Inputs</span>
      <span class="legend-item"><span class="legend-dot" style="background:#FFF1F2; border:1px solid #F43F5E;"></span>Buttons</span>
      <span class="legend-item"><span class="legend-dot" style="background:#EFF6FF; border:1px solid #3B82F6;"></span>Content</span>
    </div>
    <button onclick="window.print()">Print / Save as PDF</button>
  </div>
''']

    for p in PAGES:
        html.append('  <div class="page-container">')
        html.append(generate_page_svg(p))
        html.append('  </div>\n')

    html.append('''</body>
</html>''')
    return '\n'.join(html)

if __name__ == "__main__":
    out_file = "/Users/tushar/Desktop/tracker1/widget_trees.html"
    with open(out_file, "w", encoding="utf-8") as f:
        f.write(build_full_html())
    print(f"Generated {out_file} successfully with {len(PAGES)} color-coded screens!")
