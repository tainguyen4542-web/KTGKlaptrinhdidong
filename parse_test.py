import zipfile
import xml.etree.ElementTree as ET
import os
import json

docx_path = r"d:\doan\ktra\frontend\Reading v05.docx"
ns = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}

with zipfile.ZipFile(docx_path, 'r') as z:
    xml_data = z.read("word/document.xml")

root = ET.fromstring(xml_data)
body = root.find("w:body", ns)

def get_text(node):
    return "".join(node.itertext()).strip()

print(f"Body has {len(body)} direct children")

lines = []
for child in body:
    tag = child.tag.split("}")[-1]
    if tag == "p":
        t = get_text(child)
        if t:
            lines.append(t)
    elif tag == "tbl":
        # Check rows and cols
        rows = child.findall("w:tr", ns)
        if not rows:
            continue
        num_cols = max(len(r.findall("w:tc", ns)) for r in rows)
        if num_cols == 2:
            # Check if this is a 2-column layout (read col 0 then col 1)
            # Let's inspect col 0 and col 1 texts
            col0_texts = []
            col1_texts = []
            for r in rows:
                cells = r.findall("w:tc", ns)
                if len(cells) > 0:
                    t0 = get_text(cells[0])
                    if t0: col0_texts.append(t0)
                if len(cells) > 1:
                    t1 = get_text(cells[1])
                    if t1: col1_texts.append(t1)
            lines.extend(col0_texts)
            lines.extend(col1_texts)
        else:
            for r in rows:
                for c in r.findall("w:tc", ns):
                    t = get_text(c)
                    if t:
                        lines.append(t)

with open(r"d:\doan\ktra\parsed_flow.txt", "w", encoding="utf-8") as f:
    for l in lines:
        f.write(l + "\n")

print(f"Wrote {len(lines)} lines to parsed_flow.txt")
