---
title: "I Built a Chrome Extension to Monitor Claude — And Published It to the Web Store"
description: "How I built a Chrome extension that shows Claude usage limits in the toolbar, debugged it in real time, and published it to the Chrome Web Store — all in one session."
date: 2026-03-21
tags: [post, claude-code, browser-extension, tutorial, tools, chrome]
layout: layouts/post.njk
image: "/images/claude-usage-monitor.png"
imageAlt: "The Claude usage monitor Chrome extension showing session and weekly usage percentages in a dark popup"
---

If you use Claude heavily, you know the rhythm: hit a limit mid-flow, navigate to Settings → Usage, check where you are, navigate back. Repeat every hour or so.

I wanted that information in my toolbar — a persistent badge showing my usage percentage, colour-coded, always visible. Today I built it, debugged it, and published it to the Chrome Web Store. Here's the full story.

## The wrong approach first

My first instinct was a Python script — a slim floating window anchored above the taskbar, polling the claude.ai API every 60 seconds. Claude built the whole thing: a tkinter window, a polling loop, colour-coded percentages.

It returned a 403 on every API call.

The problem was Cloudflare. When a Python script hits the claude.ai API directly — even with the correct session cookie — Cloudflare blocks it. It's checking browser fingerprinting data that doesn't exist outside a real browser context.

Dead end. But a useful one.

## The right approach: a browser extension

Extensions run inside the browser. They inherit your login session automatically, share the same origin as claude.ai, and Cloudflare sees them as normal browser requests — because they are.

No cookies to grab manually. No authentication to manage. No Cloudflare to fight.

The extension has four files:

- **manifest.json** — permissions, metadata, file references. We need `storage` (to cache data locally), `alarms` (for the polling loop), and `host_permissions` for claude.ai.
- **background.js** — the service worker. Runs in the background, fetches the usage API every minute, updates the toolbar badge with the highest usage percentage.
- **popup.html + popup.js** — the UI when you click the icon. Shows session %, weekly %, reset timers, extra credits, and a raw JSON debug view.

## Finding the right API endpoint

The extension calls:

```
https://claude.ai/api/organizations/{orgId}/usage
```

But org IDs differ per user. To make the extension work for anyone, it needs to look up the current user's org ID dynamically. The first endpoint I tried didn't exist. A quick fetch in the Service Worker console found the right one:

```js
fetch("https://claude.ai/api/organizations", { credentials: "include" })
```

This returns an array of orgs. The right one has `claude_pro` in its capabilities array. Cache that UUID and you're done — it works for any Claude Pro or Max user.

## Debugging in real time

Once installed, the popup showed dashes everywhere. The fetch was working but the data wasn't parsing. I'd assumed field names like `session_limit.used_tokens` — the actual API returns:

```json
{
  "five_hour": {
    "utilization": 73,
    "resets_at": "2026-03-21T19:59:59Z"
  },
  "seven_day": {
    "utilization": 94,
    "resets_at": "2026-03-24T16:00:00Z"
  }
}
```

`five_hour` and `seven_day` — not what you'd guess. The raw JSON button in the popup revealed this in one click. Two-minute fix once you know what you're looking at.

Lesson: always build a debug view into tools that talk to APIs you don't control.

## What it looks like

The toolbar badge shows your highest usage percentage — green under 70%, amber from 70–89%, red at 90%+. Click it for the full breakdown:

```
SESSION    0%     WEEKLY   98%
resets —          resets 47h 36m

EXTRA CREDITS
0 / 2000
```

Three buttons: refresh, raw JSON, and a direct link to claude.ai/settings/usage.

## Publishing to the Chrome Web Store

Getting listed is simpler than it sounds:

**One-time setup:** Register as a Chrome developer at the Developer Dashboard — $5 one-time fee, unlimited extensions after that.

**Per submission:**

1. Zip the extension folder
2. Upload via Add new item
3. Fill in the listing: name, description, category, screenshots
4. Justify your permissions (one sentence each — what they do and why)
5. Add a privacy policy URL
6. Set visibility to Unlisted for v1 (shareable via link, not publicly searchable)
7. Submit for review — typically approved within 24 hours

The main gotchas I hit:

- Google asks you to justify "remote code use" even if you don't use any — just explicitly state that all JS is bundled in the package
- Contact email must be verified before you can submit
- The privacy policy needs to be a real URL — I added a `## Privacy Policy` section to the GitHub README, which gives a clean anchor link

## The extension is live

The code is on GitHub at [akaaja2/claude-usage-monitor](https://github.com/akaaja2/claude-usage-monitor). Four files, no build step, no dependencies. Load it in Chrome or Edge via Developer mode → Load unpacked and it works immediately as long as you're logged into claude.ai.

The Chrome Web Store listing is under review — I'll update this post with the link once it's approved.

## What this session shows about building with AI

A few patterns that made this work:

**The failed attempt was the route.** Python → Chrome extension wasn't a detour, it was the path. The 403 error pointed directly at why, which pointed directly at the solution. Treating dead ends as diagnostics rather than failures changes the whole tempo of the work.

**Build debug tools into your tools.** The raw JSON button cost ten lines of code and saved the session. Any time you're building something that talks to an API you don't fully control, give yourself a way to see the raw response.

**Ship as unlisted first.** You get a real store URL to share, skip the scrutiny of full public review, and can go public once you're confident. Low friction, real distribution.

The full source, README, and privacy policy are at [github.com/akaaja2/claude-usage-monitor](https://github.com/akaaja2/claude-usage-monitor).
