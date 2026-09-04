#!/usr/bin/env python3
"""Render README.md to rdf.pdf.

The original report was produced with LaTeX and could not be rebuilt from
anything in this repository. This regenerates it from the README so the two
cannot drift apart again.

Needs: python3-markdown and Google Chrome (headless).
"""
import markdown, os, re, shutil, subprocess, sys, tempfile

ROOT = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(ROOT, "README.md")
OUT = os.path.join(ROOT, "rdf.pdf")

CSS = """
@page { size: A4; margin: 22mm 20mm; }
body { font-family: "DejaVu Serif", Georgia, "Times New Roman", serif;
       font-size: 10.5pt; line-height: 1.45; color: #111; }
.title-page { text-align: center; page-break-after: always; padding-top: 22mm; }
.title-page .title { font-size: 22pt; font-weight: bold; line-height: 1.3;
                     margin-bottom: 14mm; }
.title-page .date { font-size: 12pt; margin-bottom: 4mm; }
.title-page .revised { font-size: 10pt; font-style: italic; color: #444;
                       margin-bottom: 16mm; }
.title-page .author { font-size: 12pt; margin-top: 7mm; }
.title-page .email { font-size: 10pt; color: #333; font-family: monospace; }
h2 { font-size: 15pt; margin-top: 11mm; margin-bottom: 3mm;
     border-bottom: 1px solid #bbb; padding-bottom: 1.5mm; }
h3 { font-size: 12pt; margin-top: 7mm; margin-bottom: 2mm; }
h2, h3 { page-break-after: avoid; }
p { margin: 2.5mm 0; text-align: justify; }
ul { margin: 2mm 0; padding-left: 7mm; }
li { margin: 1mm 0; }
pre { background: #f6f6f6; border: 1px solid #ddd; border-radius: 3px;
      padding: 3mm 4mm; font-family: "DejaVu Sans Mono", monospace;
      font-size: 8.5pt; line-height: 1.35; white-space: pre-wrap;
      word-wrap: break-word; page-break-inside: avoid; }
code { font-family: "DejaVu Sans Mono", monospace; font-size: 9pt; }
p code { background: #f2f2f2; padding: 0 1mm; border-radius: 2px; }
strong { font-weight: bold; }
"""


def title_page(block):
    """Build the cover from the heading block above '## Contents'."""
    title = re.search(r"^## (.+)$", block, re.M).group(1)
    date = re.findall(r"^## (.+)$", block, re.M)[1]
    revised = re.search(r"^\*(.+)\*$", block, re.M)
    people = re.findall(r"^### (.+)$", block, re.M)
    html = ['<div class="title-page">']
    html.append(f'<div class="title">{title}</div>')
    html.append(f'<div class="date">{date}</div>')
    if revised:
        html.append(f'<div class="revised">{revised.group(1)}</div>')
    for name, email in zip(people[::2], people[1::2]):
        html.append(f'<div class="author">{name}<br>'
                    f'<span class="email">{email}</span></div>')
    html.append("</div>")
    return "\n".join(html)


def main():
    if not shutil.which("google-chrome"):
        sys.exit("google-chrome not found; cannot render the PDF")
    text = open(SRC, encoding="utf-8").read()
    head, _, rest = text.partition("## Contents")
    body = markdown.markdown("## Contents" + rest, extensions=["fenced_code"])
    page = (f"<!doctype html><html><head><meta charset='utf-8'>"
            f"<title>DSL for querying RDF turtle format documents</title>"
            f"<style>{CSS}</style></head><body>"
            f"{title_page(head)}{body}</body></html>")
    with tempfile.TemporaryDirectory() as tmp:
        src = os.path.join(tmp, "report.html")
        open(src, "w", encoding="utf-8").write(page)
        subprocess.run(["google-chrome", "--headless=new", "--disable-gpu",
                        "--no-sandbox", "--no-pdf-header-footer",
                        f"--user-data-dir={tmp}/profile",
                        f"--print-to-pdf={OUT}", f"file://{src}"],
                       check=True, capture_output=True)
    print(f"wrote {OUT} ({os.path.getsize(OUT) // 1024} KB)")


if __name__ == "__main__":
    main()
