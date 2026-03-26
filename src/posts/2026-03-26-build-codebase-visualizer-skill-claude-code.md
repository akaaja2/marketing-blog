---
title: "How to Build a Codebase Visualizer Skill in Claude Code"
description: "One file. One command. An interactive map of your entire project — in your browser."
date: 2026-03-26
tags: [post, claude-code, skills, tutorial]
layout: layouts/post.njk
---

<div class="carousel" style="margin: 2rem 0;">
  <div class="carousel-inner" style="position:relative; overflow:hidden; border-radius:12px; background:#0f172a;">
    <div class="carousel-slides" style="display:flex; transition:transform 0.4s ease;">
      <img src="/images/slide-01.png" alt="Slide 1 — Codebase Visualizer Skill" style="width:100%; flex-shrink:0;">
      <img src="/images/slide-02.png" alt="Slide 2 — Codebase Visualizer Skill" style="width:100%; flex-shrink:0;">
      <img src="/images/slide-03.png" alt="Slide 3 — Codebase Visualizer Skill" style="width:100%; flex-shrink:0;">
      <img src="/images/slide-04.png" alt="Slide 4 — Codebase Visualizer Skill" style="width:100%; flex-shrink:0;">
      <img src="/images/slide-05.png" alt="Slide 5 — Codebase Visualizer Skill" style="width:100%; flex-shrink:0;">
      <img src="/images/slide-06.png" alt="Slide 6 — Codebase Visualizer Skill" style="width:100%; flex-shrink:0;">
      <img src="/images/slide-07.png" alt="Slide 7 — Codebase Visualizer Skill" style="width:100%; flex-shrink:0;">
    </div>
    <button onclick="carouselPrev()" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);background:rgba(0,0,0,0.5);color:#fff;border:none;border-radius:50%;width:36px;height:36px;font-size:1.1rem;cursor:pointer;line-height:1;">‹</button>
    <button onclick="carouselNext()" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:rgba(0,0,0,0.5);color:#fff;border:none;border-radius:50%;width:36px;height:36px;font-size:1.1rem;cursor:pointer;line-height:1;">›</button>
  </div>
  <div class="carousel-dots" style="text-align:center;margin-top:10px;">
    <span class="dot active" onclick="carouselGo(0)" style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#2563eb;margin:0 3px;cursor:pointer;opacity:1;"></span>
    <span class="dot" onclick="carouselGo(1)" style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#cbd5e1;margin:0 3px;cursor:pointer;opacity:0.5;"></span>
    <span class="dot" onclick="carouselGo(2)" style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#cbd5e1;margin:0 3px;cursor:pointer;opacity:0.5;"></span>
    <span class="dot" onclick="carouselGo(3)" style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#cbd5e1;margin:0 3px;cursor:pointer;opacity:0.5;"></span>
    <span class="dot" onclick="carouselGo(4)" style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#cbd5e1;margin:0 3px;cursor:pointer;opacity:0.5;"></span>
    <span class="dot" onclick="carouselGo(5)" style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#cbd5e1;margin:0 3px;cursor:pointer;opacity:0.5;"></span>
    <span class="dot" onclick="carouselGo(6)" style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#cbd5e1;margin:0 3px;cursor:pointer;opacity:0.5;"></span>
  </div>
</div>
<script>
(function() {
  var idx = 0;
  var total = 7;
  function update() {
    var slides = document.querySelector('.carousel-slides');
    if (slides) slides.style.transform = 'translateX(-' + (idx * 100) + '%)';
    document.querySelectorAll('.dot').forEach(function(d, i) {
      d.style.background = i === idx ? '#2563eb' : '#cbd5e1';
      d.style.opacity = i === idx ? '1' : '0.5';
    });
  }
  window.carouselNext = function() { idx = (idx + 1) % total; update(); };
  window.carouselPrev = function() { idx = (idx - 1 + total) % total; update(); };
  window.carouselGo = function(i) { idx = i; update(); };
})();
</script>

## The Problem Every Developer Knows

You've just been handed a new codebase. Or you've returned to your own project after six weeks away. Either way, you spend the first 20 minutes doing the same archaeology: `ls`, `find`, `cat`, mentally sketching a tree that keeps falling apart.

Claude Code's Skills feature solves this — and the codebase visualizer is the perfect first skill to build. It's practical, the output is impressive, and building it teaches you everything you need to know about how Skills work.

---

## What You're Building

A Claude Code skill called `/codebase-visualizer` that, when invoked, runs a Python script and opens an interactive HTML file in your browser: a collapsible directory tree with file sizes at a glance, colour-coded by file type. Think of it as `tree` on steroids, with a UI your stakeholders can actually navigate.

---

## Skills vs Slash Commands — A Quick Clarification

If you've been using Claude Code for a while, you might know about `.claude/commands/` files. Skills are the evolved version of the same idea. They live in `.claude/skills/` (project scope) or `~/.claude/skills/` (personal scope, available everywhere), and they support things plain commands don't:

- **Bundled scripts** — ship Python, Bash, or any executable alongside your instructions
- **Auto-invocation** — Claude can trigger a skill automatically when context matches, without you typing the slash command
- **Supporting files** — templates, example outputs, reference docs, all in the same directory

The short version: `.claude/commands/` still works, but Skills are the future. New things belong in `.claude/skills/`.

---

## Step 1 — Create the Skill Directory

Personal skills are available across all your projects — a good fit for a general-purpose tool like this.

```bash
mkdir -p ~/.claude/skills/codebase-visualizer
```

---

## Step 2 — Write the SKILL.md

Every skill needs a `SKILL.md` file with two parts: YAML frontmatter that controls when and how Claude uses it, and markdown instructions Claude follows when the skill runs.

Create `~/.claude/skills/codebase-visualizer/SKILL.md`:

```markdown
---
name: codebase-visualizer
description: Generate an interactive collapsible tree visualization of your codebase.
Use when exploring a new repo, understanding project structure, or identifying large files.
---

# Codebase Visualizer

Generate an interactive HTML file that shows the full project structure as a
collapsible tree with file sizes and type-based colour coding.

## Steps

1. Run the bundled script: `python ~/.claude/skills/codebase-visualizer/visualize.py`
2. The script generates `codebase-map.html` in the current directory
3. Open the file in the default browser with: `open codebase-map.html` (macOS)
   or `xdg-open codebase-map.html` (Linux) or `start codebase-map.html` (Windows)
4. Tell the user the file has been generated and is now open in their browser
```

The `name` field becomes the slash command — so this creates `/codebase-visualizer`. The `description` is what Claude reads to decide whether to invoke this skill automatically when you describe a task.

---

## Step 3 — Write the Bundled Script

Create `~/.claude/skills/codebase-visualizer/visualize.py`:

```python
import os
import json
from pathlib import Path

IGNORE = {'.git', 'node_modules', '__pycache__', '.venv', 'dist', 'build', '.next'}
COLOURS = {
    '.py': '#3b82f6', '.js': '#f59e0b', '.ts': '#06b6d4',
    '.md': '#10b981', '.json': '#8b5cf6', '.html': '#ef4444',
    '.css': '#ec4899', '.sh': '#84cc16',
}

def build_tree(path, depth=0):
    items = []
    try:
        entries = sorted(Path(path).iterdir(), key=lambda e: (e.is_file(), e.name))
    except PermissionError:
        return items
    for entry in entries:
        if entry.name.startswith('.') and entry.name not in {'.claude', '.env.example'}:
            continue
        if entry.name in IGNORE:
            continue
        if entry.is_dir():
            children = build_tree(entry, depth + 1)
            items.append({'name': entry.name, 'type': 'dir', 'children': children})
        else:
            size = entry.stat().st_size
            ext = entry.suffix.lower()
            items.append({
                'name': entry.name, 'type': 'file',
                'size': size, 'ext': ext,
                'colour': COLOURS.get(ext, '#6b7280')
            })
    return items

def human_size(b):
    for unit in ['B','KB','MB','GB']:
        if b < 1024: return f"{b:.1f} {unit}"
        b /= 1024

tree = build_tree('.')
tree_json = json.dumps(tree, indent=2)

html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Codebase Map</title>
<style>
  body {{ font-family: 'Courier New', monospace; background: #0f172a; color: #e2e8f0;
         margin: 0; padding: 24px; }}
  h1 {{ color: #38bdf8; font-size: 1.2rem; margin-bottom: 16px; }}
  .tree {{ list-style: none; padding-left: 20px; }}
  .tree > li {{ margin: 2px 0; }}
  .toggle {{ cursor: pointer; user-select: none; }}
  .toggle::before {{ content: '▶ '; font-size: 0.7em; color: #64748b; }}
  .open > .toggle::before {{ content: '▼ '; }}
  .dir-name {{ color: #fbbf24; font-weight: bold; }}
  .file-name {{ color: #e2e8f0; }}
  .size {{ color: #475569; font-size: 0.8em; margin-left: 8px; }}
  .hidden {{ display: none; }}
</style>
</head>
<body>
<h1>📁 {Path('.').resolve().name}</h1>
<ul class="tree" id="root"></ul>
<script>
const data = {tree_json};

function humanSize(b) {{
  const units = ['B','KB','MB','GB'];
  for (let u of units) {{ if (b < 1024) return b.toFixed(1) + ' ' + u; b /= 1024; }}
}}

function render(nodes, ul) {{
  for (const n of nodes) {{
    const li = document.createElement('li');
    if (n.type === 'dir') {{
      li.classList.add('toggle');
      li.innerHTML = `<span class="dir-name">📂 ${{n.name}}</span>`;
      const sub = document.createElement('ul');
      sub.classList.add('tree', 'hidden');
      render(n.children, sub);
      li.appendChild(sub);
      li.addEventListener('click', e => {{
        e.stopPropagation();
        li.classList.toggle('open');
        sub.classList.toggle('hidden');
      }});
    }} else {{
      li.innerHTML = `<span class="file-name" style="color:${{n.colour}}">
        ${{n.name}}</span><span class="size">${{humanSize(n.size)}}</span>`;
    }}
    ul.appendChild(li);
  }}
}}

render(data, document.getElementById('root'));
</script>
</body>
</html>"""

with open('codebase-map.html', 'w') as f:
    f.write(html)

print("✓ codebase-map.html generated")
```

---

## Step 4 — Test It

Open Claude Code in any project and type:

```
/codebase-visualizer
```

Claude runs the script, saves `codebase-map.html`, and opens it. You'll see your entire project tree — collapsible, colour-coded, with file sizes — in your browser.

You can also just ask naturally: *"Visualize this codebase"* or *"Show me the project structure"* — and Claude will invoke the skill automatically, because the description in your frontmatter matches.

---

## Why This Pattern Matters

The codebase visualizer is a simple example of a much more powerful idea: **Skills let you give Claude Code capabilities that go beyond a single prompt.**

The same pattern applies to anything you do repeatedly:
- A `/survey-analysis` skill that takes a CSV, runs crosstabs, and produces charts
- A `/competitor-scan` skill that researches a company and outputs a structured Markdown report
- A `/generate-report` skill that assembles analysis outputs into a formatted `.docx`

Once a skill exists in `~/.claude/skills/`, it travels with you across every project. You define the capability once and stop repeating yourself forever.

---

## The File You Just Built

```
~/.claude/skills/
└── codebase-visualizer/
    ├── SKILL.md        ← instructions + frontmatter
    └── visualize.py    ← bundled script Claude runs
```

Two files. One slash command. One less thing you'll ever do manually again.

---

*This post is part of a 20-hour Claude Code study plan covering skills, MCP servers, survey analysis, competitor intelligence, and automated report generation. If you're building workflows for market research or data analysis, the same skill-building pattern applies across every repeatable task in your stack.*
