---
title: "How I Built a Claude-Powered Blog in a Single Day (And What Actually Went Wrong)"
description: "The architecture, the stack decisions, the messy MCP setup, and how a single CLAUDE.md file changed everything."
date: 2026-03-19
tags: [post, behind-the-scenes, ai-tools, claude-code]
layout: layouts/post.njk
---
I want to be upfront about something before we get into it: this blog was built by AI. Not in a vague, "AI-assisted" sense. I mean the architecture was chosen by AI, the code was written by AI, the files were committed and pushed by AI, and the first post was published by AI. I was mostly there to answer questions and paste things into a terminal.

Here's how it actually happened.

## The goal

The brief was simple: a blog where new posts can be created and published from a single conversation with Claude — no CMS login, no manual Git commits, no deployment dashboard. Just: "write a post about X" and it appears on the live site.

## Choosing the stack

After talking through the options — Ghost, WordPress, Next.js, Hugo, Eleventy — we landed on **11ty (Eleventy)** hosted on **Netlify**, connected to a GitHub repo. The reasoning was straightforward: 11ty is the most forgiving static site generator for AI-authored content. Hugo came close, but 11ty's flexibility and its natural pairing with Netlify made it the right call.

The full stack:
- **11ty** — static site generator, builds Markdown posts into HTML
- **GitHub** — source of truth, every post is a `.md` file in `/src/posts/`
- **Netlify** — detects every push to `main` and rebuilds the site automatically
- **Claude Code** — the publishing interface, running locally via terminal

## What went smoothly

Once the decisions were made, the scaffolding was fast. Claude Code built the entire blog structure — layouts, templates, homepage, sample post — from a single prompt. The build came back clean first time. Netlify connected to GitHub in about three clicks and the site was live at `claude4marketing.netlify.app` within 20 minutes of starting.

The first real post was written, committed, and pushed without me touching a file.

## What actually went wrong

This is the more interesting part.

**The MCP connector setup was genuinely messy.** The plan was to connect Claude Code directly to GitHub and Netlify via MCP (Model Context Protocol) servers — which would let Claude push posts and monitor deployments without any manual steps. Getting GitHub connected took several attempts: wrong endpoint, wrong token scope, an accidentally exposed PAT that had to be revoked immediately, and a Windows-specific `cmd /c` wrapper requirement that isn't documented anywhere obvious.

Netlify was worse. Six separate failure modes in sequence: wrong HTTP endpoint, wrong environment variable name, missing `cmd /c` wrapper, Node version too old (v20 instead of v22), Netlify CLI not installed, and finally an npx cache corruption that left a half-broken module. We parked it and moved on.

The workaround — using the `gh` CLI which was already authenticated — worked perfectly and achieved the same result. Sometimes the pragmatic path is just faster.

**The GitHub PAT exposure** was a reminder that security hygiene matters even in a dev workflow. A token appeared in a conversation window, got revoked within minutes, and a new one was generated. The right approach — using PowerShell's `Read-Host` to capture tokens without them appearing on screen — is now documented for future reference.

## The CLAUDE.md trick

The most useful thing we set up wasn't the deployment pipeline — it was the `CLAUDE.md` file. This sits in the project root and Claude Code reads it automatically at the start of every session. It contains the repo name, the file naming convention, the required frontmatter fields, style guidelines, and a note never to push to any branch other than `main`.

The result: publishing a new post now takes one sentence. "Write and publish a post about X." Everything else is handled.

## What's next

The blog is functional but still minimal in terms of design. In progress: a clean minimal stylesheet with Inter and Lora fonts, tag pages, reading time estimates, social share links, Open Graph tags for LinkedIn previews, a sitemap, RSS feed, and Pagefind search.

The Netlify MCP issue is still open. A full machine restart after the Node upgrade is the next thing to try — but honestly, the blog is live and publishing, which was the whole point.
