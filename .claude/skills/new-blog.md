# Skill: new-blog
**Trigger:** When user asks to create, scaffold, or set up a new blog, or says "build me a blog like this one."

---

## Overview
This skill scaffolds a production-ready 11ty (Eleventy 3.x) static blog — same architecture as this project — then creates a GitHub repo and guides the user through Netlify deployment. The whole setup takes about 10 minutes of user time.

---

## Step 1 — Gather requirements

Ask the user these questions before writing any files (use AskUserQuestion if available, otherwise ask in chat):

1. **Blog name** — What is the display name of the blog? (e.g. "TechByAlex")
2. **Site slug** — What should the Netlify subdomain be? (e.g. `techbyalex` → `techbyalex.netlify.app`)
3. **One-line description** — Describe the blog in one sentence for meta tags.
4. **Writing tone** — Choose one:
   - First-person, conversational ("I tried this and here's what happened")
   - Third-person, authoritative ("Marketers who use AI tools report…")
   - Neutral/informational (explain, don't editorialize)
5. **GitHub repo name** — What should the GitHub repository be called? (e.g. `techbyalex-blog`)
6. **GitHub username** — Their GitHub username (needed for push command).
7. **Topic/niche** — What topics will this blog cover? (used to seed the starter post)

Record all answers. Use them throughout the rest of the skill.

---

## Step 2 — Scaffold the project

Create all files below in a new directory named after the repo slug (e.g. `techbyalex-blog/`). Replace `{{BLOG_NAME}}`, `{{SITE_URL}}`, `{{DESCRIPTION}}` etc. with the user's answers throughout.

### 2.1 — Directory structure to create
```
{{REPO_NAME}}/
  src/
    posts/
    images/
    css/
      style.css
    _includes/
      layouts/
        base.njk
        post.njk
    _data/
      metadata.json
    index.njk
    about.njk
    search.njk
    404.njk
  .claude/
    skills/
      image-style.md
  .eleventy.js
  .gitignore
  netlify.toml
  package.json
  CLAUDE.md
```

### 2.2 — `package.json`
```json
{
  "name": "{{REPO_NAME}}",
  "version": "1.0.0",
  "scripts": {
    "start": "eleventy --serve",
    "build": "eleventy && npx pagefind --site _site"
  },
  "dependencies": {
    "@11ty/eleventy": "^3.1.5",
    "@11ty/eleventy-img": "^6.0.4",
    "@11ty/eleventy-plugin-rss": "^2.0.4"
  },
  "devDependencies": {
    "pagefind": "^1.4.0"
  }
}
```

### 2.3 — `.gitignore`
```
node_modules/
_site/
.DS_Store
```

### 2.4 — `netlify.toml`
```toml
[build]
  command = "npm run build"
  publish = "_site"
```

### 2.5 — `src/_data/metadata.json`
```json
{
  "title": "{{BLOG_NAME}}",
  "url": "https://{{NETLIFY_SLUG}}.netlify.app",
  "description": "{{DESCRIPTION}}"
}
```

### 2.6 — `.eleventy.js`
```js
const fs = require("fs");
const path = require("path");
const pluginRss = require("@11ty/eleventy-plugin-rss");
const Image = require("@11ty/eleventy-img");

async function imageShortcode(src, alt, cls = "post-hero") {
  const isExternal = src.startsWith("http://") || src.startsWith("https://");
  if (isExternal) {
    return `<img src="${src}" alt="${alt}" class="${cls}" loading="lazy">`;
  }
  const localSrc = path.join("src", src);
  if (!fs.existsSync(localSrc)) {
    return `<img src="${src}" alt="${alt}" class="${cls}" loading="lazy">`;
  }
  const metadata = await Image(localSrc, {
    widths: [400, 800, 1200],
    formats: ["webp", "jpeg"],
    outputDir: "./_site/images/",
    urlPath: "/images/",
    filenameFormat: (id, src, width, format) => {
      const name = path.basename(src, path.extname(src));
      return `${name}-${width}.${format}`;
    },
  });
  return Image.generateHTML(metadata, {
    alt, class: cls,
    sizes: "(max-width: 600px) 400px, (max-width: 1000px) 800px, 1200px",
    loading: "lazy", decoding: "async",
  });
}

module.exports = function (eleventyConfig) {
  eleventyConfig.addPlugin(pluginRss);
  eleventyConfig.addAsyncShortcode("optimizedImage", imageShortcode);

  eleventyConfig.addFilter("date", (dateVal, format) => {
    const d = new Date(dateVal);
    if (format === "%B %d, %Y") {
      return d.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" });
    }
    if (format === "%Y-%m-%d") return d.toISOString().slice(0, 10);
    return d.toLocaleDateString("en-US");
  });

  eleventyConfig.addFilter("readingTime", (content) => {
    return Math.ceil(content.split(/\s+/).length / 200) + " min read";
  });

  eleventyConfig.addFilter("relatedPosts", (allPosts, currentTags, currentUrl) => {
    if (!currentTags || !allPosts) return [];
    return allPosts
      .filter(p => p.url !== currentUrl && p.data.tags?.some(t => currentTags.includes(t)))
      .slice(0, 3);
  });

  eleventyConfig.addFilter("assetExists", (assetUrl) => {
    if (typeof assetUrl !== "string" || !assetUrl.startsWith("/")) return false;
    return fs.existsSync(path.join(process.cwd(), "src", ...assetUrl.slice(1).split("/")));
  });

  eleventyConfig.addCollection("tagList", (collectionApi) => {
    const tags = new Set();
    collectionApi.getAll().forEach(item =>
      (item.data.tags || []).forEach(t => { if (t !== "post") tags.add(t); })
    );
    return [...tags];
  });

  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/favicon.svg");
  eleventyConfig.addPassthroughCopy("src/images");

  return {
    dir: { input: "src", output: "_site", includes: "_includes" },
  };
};
```

### 2.7 — `src/_includes/layouts/base.njk`
```njk
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% if title %}{{ title }} — {% endif %}{{BLOG_NAME}}</title>
  <meta property="og:site_name" content="{{ metadata.title }}">
  <meta property="og:title" content="{{ title or metadata.title }}">
  <meta property="og:description" content="{{ description or metadata.description }}">
  <meta property="og:url" content="{{ metadata.url }}{{ page.url }}">
  {% if date %}<meta property="og:type" content="article">
  {% else %}<meta property="og:type" content="website">{% endif %}
  {% if image and (image | assetExists) %}
  <meta property="og:image" content="{{ metadata.url }}{{ image }}">
  {% endif %}
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="{{ title or metadata.title }}">
  <meta name="twitter:description" content="{{ description or metadata.description }}">
  <meta name="description" content="{{ description or metadata.description }}">
  <link rel="alternate" type="application/atom+xml" title="{{ metadata.title }}" href="/feed.xml">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lora:wght@700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/prismjs@1/themes/prism-tomorrow.min.css">
  <link rel="icon" type="image/svg+xml" href="/favicon.svg">
</head>
<body>
  <header class="site-header">
    <div class="container">
      <a href="/" class="site-name">{{BLOG_NAME}}</a>
      <nav>
        <a href="/">Blog</a>
        <a href="/about/">About</a>
        <a href="/search/">Search</a>
        <button class="theme-toggle" id="theme-toggle" aria-label="Toggle dark mode">☀</button>
      </nav>
    </div>
  </header>
  <main class="container">{{ content | safe }}</main>
  <footer class="site-footer">
    <div class="container">© {{CURRENT_YEAR}} {{BLOG_NAME}}</div>
  </footer>
  <button id="back-to-top" aria-label="Back to top">↑</button>
  <script>
    const backToTop = document.getElementById('back-to-top');
    window.addEventListener('scroll', () => backToTop.classList.toggle('visible', scrollY > 400));
    backToTop.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
    const toggle = document.getElementById('theme-toggle');
    const html = document.documentElement;
    const saved = localStorage.getItem('theme');
    if (saved) { html.setAttribute('data-theme', saved); toggle.textContent = saved === 'dark' ? '☀' : '☾'; }
    toggle.addEventListener('click', () => {
      const effectiveDark = html.getAttribute('data-theme') === 'dark' || (!html.getAttribute('data-theme') && matchMedia('(prefers-color-scheme: dark)').matches);
      const next = effectiveDark ? 'light' : 'dark';
      html.setAttribute('data-theme', next);
      localStorage.setItem('theme', next);
      toggle.textContent = next === 'dark' ? '☀' : '☾';
    });
  </script>
</body>
</html>
```

### 2.8 — `src/_includes/layouts/post.njk`
```njk
---
layout: layouts/base.njk
---
{% if image %}{% optimizedImage image, (imageAlt or title) %}{% endif %}
<div id="progress-bar" style="position:fixed;top:0;left:0;height:3px;width:0%;background:#2563eb;z-index:100;transition:width 0.1s linear;"></div>
<article>
  <header class="post-header">
    <h1>{{ title }}</h1>
    <div class="post-meta">{{ date | date("%B %d, %Y") }} &middot; {{ content | readingTime }}</div>
    {% if tags %}
    <div class="tags">
      {% for tag in tags %}{% if tag != "post" %}<a href="/tags/{{ tag }}/" class="tag">{{ tag }}</a>{% endif %}{% endfor %}
    </div>
    {% endif %}
  </header>
  <div class="post-content">{{ content | safe }}</div>
  {% set related = collections.post | relatedPosts(tags, page.url) %}
  {% if related.length %}
  <div class="related-posts">
    <h3>Related posts</h3>
    <ul class="post-list" style="margin-top:16px;">
      {% for post in related %}
      <li class="post-card" style="padding:20px 0;">
        <h4 style="font-size:18px;margin:0 0 6px;"><a href="{{ post.url }}" style="color:var(--text);">{{ post.data.title }}</a></h4>
        <div class="post-meta">{{ post.date | date("%B %d, %Y") }} &middot; {{ post.content | readingTime }}</div>
        {% if post.data.description %}<p class="post-description">{{ post.data.description }}</p>{% endif %}
      </li>
      {% endfor %}
    </ul>
  </div>
  {% endif %}
  <div class="share-section">
    <p>Share this post</p>
    <div class="share-links">
      <a href="https://twitter.com/intent/tweet?url={{SITE_URL}}{{ page.url }}&text={{ title | urlencode }}" target="_blank" rel="noopener">Twitter / X</a>
      <a href="https://www.linkedin.com/sharing/share-offsite/?url={{SITE_URL}}{{ page.url }}" target="_blank" rel="noopener">LinkedIn</a>
      <a href="#" onclick="navigator.clipboard.writeText(location.href);this.textContent='Copied!';setTimeout(()=>this.textContent='Copy link',2000);return false;">Copy link</a>
    </div>
  </div>
</article>
<script>
  window.addEventListener('scroll', () => {
    const el = document.getElementById('progress-bar');
    const doc = document.documentElement;
    el.style.width = (doc.scrollTop / (doc.scrollHeight - doc.clientHeight) * 100) + '%';
  });
  Prism.highlightAll();
</script>
<script src="https://cdn.jsdelivr.net/npm/prismjs@1/prism.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs@1/plugins/autoloader/prism-autoloader.min.js"></script>
<script>Prism.plugins.autoloader.languages_path = 'https://cdn.jsdelivr.net/npm/prismjs@1/components/';</script>
```

### 2.9 — `src/index.njk`
```njk
---
layout: layouts/base.njk
title: Blog
---
<ul class="post-list">
{%- for post in collections.post | reverse -%}
  <li class="post-card">
    {% if post.data.image %}<img src="{{ post.data.image }}" alt="{{ post.data.imageAlt or post.data.title }}" class="card-image">{% endif %}
    <h2><a href="{{ post.url }}">{{ post.data.title }}</a></h2>
    <div class="post-meta">{{ post.date | date("%B %d, %Y") }} &middot; {{ post.content | readingTime }}</div>
    {% if post.data.description %}<p class="post-description">{{ post.data.description }}</p>{% endif %}
    {% if post.data.tags %}
    <div class="tags">
      {% for tag in post.data.tags %}{% if tag != "post" %}<a href="/tags/{{ tag }}/" class="tag">{{ tag }}</a>{% endif %}{% endfor %}
    </div>
    {% endif %}
  </li>
{%- endfor -%}
</ul>
```

### 2.10 — `src/about.njk`
```njk
---
layout: layouts/base.njk
title: About
---
<article style="margin-top:48px;">
  <h1>About {{BLOG_NAME}}</h1>
  <p>{{DESCRIPTION}}</p>
  <p><em>This site was built with <a href="https://www.11ty.dev/">Eleventy</a> and deployed on <a href="https://netlify.com">Netlify</a>.</em></p>
</article>
```

### 2.11 — `src/search.njk`
```njk
---
layout: layouts/base.njk
title: Search
---
<div style="margin-top:48px;">
  <h1>Search</h1>
  <div id="search"></div>
  <link href="/pagefind/pagefind-ui.css" rel="stylesheet">
  <script src="/pagefind/pagefind-ui.js"></script>
  <script>new PagefindUI({ element: "#search", showSubResults: true });</script>
</div>
```

### 2.12 — `src/404.njk`
```njk
---
layout: layouts/base.njk
title: Page Not Found
permalink: /404.html
---
<div style="text-align:center;margin-top:80px;">
  <h1>404 — Page not found</h1>
  <p>That page doesn't exist.</p>
  <a href="/">← Back to home</a>
</div>
```

### 2.13 — Tag pages — create `src/tags.njk`
```njk
---
layout: layouts/base.njk
pagination:
  data: collections.tagList
  size: 1
  alias: tag
permalink: /tags/{{ tag }}/
---
<h1 style="margin-top:48px;">Posts tagged "{{ tag }}"</h1>
<ul class="post-list">
  {%- for post in collections[tag] | reverse -%}
  <li class="post-card">
    <h2><a href="{{ post.url }}">{{ post.data.title }}</a></h2>
    <div class="post-meta">{{ post.date | date("%B %d, %Y") }} &middot; {{ post.content | readingTime }}</div>
    {% if post.data.description %}<p class="post-description">{{ post.data.description }}</p>{% endif %}
  </li>
  {%- endfor -%}
</ul>
```

### 2.14 — RSS feed — create `src/feed.njk`
```njk
---
permalink: /feed.xml
eleventyExcludeFromCollections: true
---
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>{{ metadata.title }}</title>
  <link href="{{ metadata.url }}/feed.xml" rel="self"/>
  <link href="{{ metadata.url }}/"/>
  <updated>{{ collections.post | getNewestCollectionItemDate | dateToRfc3339 }}</updated>
  <id>{{ metadata.url }}/</id>
  {%- for post in collections.post | reverse -%}
  <entry>
    <title>{{ post.data.title }}</title>
    <link href="{{ metadata.url }}{{ post.url }}"/>
    <id>{{ metadata.url }}{{ post.url }}</id>
    <updated>{{ post.date | dateToRfc3339 }}</updated>
    <content type="html"><![CDATA[{{ post.content | safe }}]]></content>
  </entry>
  {%- endfor -%}
</feed>
```

### 2.15 — `src/css/style.css`
Copy the full CSS from the reference blog (`src/css/style.css` in this project), then:
- Replace all instances of `Claude4Marketing` with `{{BLOG_NAME}}`
- Keep all variables, layout, dark mode, and component styles unchanged
- The accent colour `#2563eb` can be updated if the user specified a different brand colour

### 2.16 — `src/favicon.svg`
```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
  <rect width="32" height="32" rx="6" fill="#2563eb"/>
  <text x="16" y="23" font-family="Georgia,serif" font-size="20" font-weight="700"
        fill="white" text-anchor="middle">{{BLOG_INITIAL}}</text>
</svg>
```
Replace `{{BLOG_INITIAL}}` with the first letter of the blog name.

### 2.17 — `.claude/skills/image-style.md`
```markdown
---
# Blog Image Style — {{BLOG_NAME}}

## Core style
Flat vector cartoon illustration, clean motion-graphic style, wide 16:9 format.
Friendly, optimistic mood. Similar to Notion or Linear's illustration language.

## Colour palette
- Background: white (#ffffff)
- Arrows and highlights: blue (#2563eb)
- Energy/action: warm yellow
- Success/positive: soft green
- Outlines: bold black

## Rules
- Bold black outlines always
- No gradients, no shadows, no text labels in image
- White background always
- Left-to-right flow for process illustrations
- 2-3 panels connected by thick curved blue arrows

## DALL-E 3 prompt template
"A flat vector cartoon illustration in a clean motion-graphic style, wide 16:9 format.
[PANELS AND CONTENT] Colour palette: white background, accent blue (#2563eb) for arrows
and highlights, warm yellow for energy/action elements, soft green for positive/success
elements. Bold black outlines. No gradients, no shadows. Friendly and optimistic mood.
No text labels anywhere in the image. Flat design illustration style similar to Notion
or Linear's illustration language."

## Filename convention
src/images/[post-slug].png
```

### 2.18 — `CLAUDE.md`
```markdown
# {{BLOG_NAME}} — Claude Code Instructions

## About this project
- 11ty (Eleventy) static blog
- GitHub repo: {{GITHUB_USERNAME}}/{{REPO_NAME}}
- Live site: https://{{NETLIFY_SLUG}}.netlify.app/
- Posts live in: src/posts/
- Deploy: pushing to main triggers Netlify auto-deploy

## Publishing a new post

### File naming
src/posts/YYYY-MM-DD-slug.md

### Required frontmatter
---
title: "Post Title Here"
description: "One sentence summary"
date: YYYY-MM-DD
tags: [post]
layout: layouts/post.njk
---

### Publishing steps
1. Write the post as a .md file with correct frontmatter
2. Commit with message: "Add post: [title]"
3. Push to origin/main using gh CLI
4. Confirm push succeeded

## Writing style
- Tone: {{WRITING_TONE}}
- Target length: 1,000+ words for SEO-targeted posts; 600+ minimum for all posts
- Use subheadings for any post over 400 words
- Write for humans, not search engines
- For competitive keywords, aim for 1,200–2,500 words and include at least two of:
  step-by-step walkthroughs, screenshots with captions, FAQs, comparison tables, "what I'd do differently" sections

## SEO note
Posts averaging ~574 words underperform on competitive keywords like "Claude Code workflow"
or "AI marketing tools" where top-ranking content runs 1,200–2,500 words. Depth signals
expertise — add walkthroughs, FAQs, or comparison tables to hit 1,000+ words naturally.

## Do not
- Modify any files in _site/
- Change .eleventy.js without being asked
- Push to any branch other than main

## Eleventy 3.x compatibility notes
- Date filter uses toLocaleDateString with en-US locale for %B %d, %Y
- Use post.content not post.templateContent in collection loops
- All passthrough assets must be declared in .eleventy.js

## Build
- npm run build → eleventy + pagefind
- npm start → local dev server at localhost:8080
- Push to main → Netlify auto-deploys in ~20s
```

---

## Step 3 — Write a starter post

Generate a first post using:
- File: `src/posts/{{TODAY_DATE}}-hello-world.md`
- Title: something fitting the blog's topic/niche
- Tone: the one the user specified in Step 1
- Length: 600–900 words (starter posts don't need to target competitive keywords, but should model the depth habit)
- Include frontmatter with `tags: [post]`
- No hero image required (can add later)
- Structure: intro → 2–3 substantive sections with subheadings → conclusion or takeaway

The post should introduce the blog, explain what it will cover, and be genuinely useful — not a generic "welcome to my blog" placeholder. Demonstrate depth even in post #1.

---

## Step 4 — Initialize Git and create GitHub repo

Run these commands from inside the project directory:

```bash
cd {{REPO_NAME}}
git init
git add .
git commit -m "Initial commit: scaffold {{BLOG_NAME}}"
gh repo create {{GITHUB_USERNAME}}/{{REPO_NAME}} --public --source=. --remote=origin --push
```

If `gh` is not authenticated, tell the user to run `gh auth login` first.

---

## Step 5 — Install dependencies and verify local build

```bash
npm install
npm run build
```

If the build succeeds, tell the user the blog is ready locally. If it fails, diagnose and fix before continuing.

---

## Step 6 — External setup guide (user must do these steps)

Present this as a clear user guide. These steps happen outside Claude Code and cannot be automated.

---

### EXTERNAL SETUP GUIDE

#### A. Create a Netlify account (if you don't have one)
1. Go to **netlify.com** and sign up (free tier is fine)
2. Connect your GitHub account when prompted

#### B. Deploy the site on Netlify
1. From the Netlify dashboard, click **"Add new site"** → **"Import an existing project"**
2. Choose **GitHub** as the Git provider
3. Find and select your repo: `{{GITHUB_USERNAME}}/{{REPO_NAME}}`
4. Netlify will auto-detect the build settings from `netlify.toml`:
   - Build command: `npm run build`
   - Publish directory: `_site`
5. Click **"Deploy site"**

#### C. Set your custom subdomain (optional but recommended)
1. After the first deploy, go to **Site configuration → Domain management**
2. Click **"Options"** next to the auto-generated name → **"Edit site name"**
3. Set it to `{{NETLIFY_SLUG}}` → this gives you `{{NETLIFY_SLUG}}.netlify.app`

#### D. Update metadata.json with the final URL
Once you have your Netlify URL confirmed, update `src/_data/metadata.json`:
```json
{
  "title": "{{BLOG_NAME}}",
  "url": "https://{{NETLIFY_SLUG}}.netlify.app",
  "description": "{{DESCRIPTION}}"
}
```
Commit and push — Netlify will redeploy automatically.

#### E. Verify the live site
- Visit `https://{{NETLIFY_SLUG}}.netlify.app`
- Check that the homepage shows your starter post
- Check that `/search/` and `/about/` work
- Check that the RSS feed is at `/feed.xml`

#### F. Future publishing workflow
Every time you want to publish a post:
1. Write the `.md` file in `src/posts/`
2. Run `git add . && git commit -m "Add post: [title]" && git push`
3. Netlify auto-deploys in ~20 seconds
4. Or ask Claude to do steps 1–3 for you

---

## Step 7 — Final checklist

After all files are written and the repo is pushed, confirm:
- [ ] `npm run build` succeeds locally
- [ ] GitHub repo exists and has the initial commit
- [ ] `netlify.toml` is present with correct build command
- [ ] `CLAUDE.md` is present and customized
- [ ] Starter post is published
- [ ] User has the external setup guide in front of them

Then summarize what was created and what the user needs to do next (Step 6).

---

## Eleventy 3.x gotchas — do not introduce these bugs

- **Date filter**: use `toLocaleDateString("en-US", ...)` — not `MMMM dd, yyyy` format
- **Reading time**: use `post.content` not `post.templateContent` in collection loops
- **Passthrough copy**: every asset type needs an explicit `addPassthroughCopy` call
- **RSS plugin**: import `@11ty/eleventy-plugin-rss` and call `eleventyConfig.addPlugin(pluginRss)`
