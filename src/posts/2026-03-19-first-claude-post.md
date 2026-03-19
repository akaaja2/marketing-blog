---
title: "My First Claude-Published Post"
description: "Testing end-to-end publishing via Claude Code"
date: 2026-03-19
tags: [post]
layout: layouts/post.njk
---

Publishing blog posts directly from a conversation is one of those things that sounds like a neat trick until you realise how much friction it removes. With Claude Code connected to the GitHub API, there is no need to open a text editor, stage a commit, or push from the terminal — the entire workflow from writing to publishing happens in a single exchange.

Under the hood, Claude uses the GitHub MCP (Model Context Protocol) tool to call the GitHub API directly. The file is created in the repository with the correct frontmatter, committed to the main branch, and pushed — all in one step. For a static site built with Eleventy and deployed via a service like Netlify, that single push is enough to trigger a full rebuild and make the post live within seconds.

The practical upside goes beyond convenience. It means you can draft, review, and publish content without ever leaving the conversation — useful for quick announcements, documentation updates, or any situation where the bottleneck is the publishing workflow rather than the writing itself. The post you are reading right now is proof that it works.
