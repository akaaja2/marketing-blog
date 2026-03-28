---
title: "Claude Usage Monitor: See Your Claude Limits Right in the Toolbar"
description: "A free Chrome extension that shows your Claude.ai session and weekly usage as a live badge — no more digging through settings pages."
date: 2026-03-28
tags: [post, tools, chrome, claude]
layout: layouts/post.njk
image: "https://images.unsplash.com/photo-1614332287897-cdc485fa562d?w=1200&q=80"
imageAlt: "Browser toolbar with colorful indicators showing usage stats"
takeaways:
  - See your Claude session and weekly usage limits as a live badge in Chrome's toolbar
  - Colour-coded indicator turns green, amber, or red based on how close you are to your limit
  - Works automatically with your existing Claude.ai login — no API key needed
---

If you use Claude Pro or Max heavily, you've probably done the same thing I have: opened a new conversation, hit send on a big prompt, and only *then* wondered how close you are to your usage limit. Then you tab over to Settings, squint at the numbers, and tab back. Every time.

I built [Claude Usage Monitor](https://chromewebstore.google.com/detail/claude-usage-monitor/nopnffbnihnabiocahnfmfhjkhehmmlh) to fix that.

## What it does

It's a small Chrome extension that sits in your toolbar and shows you your Claude usage at a glance. No settings to configure, no API key to paste in — it reads the same session data your browser already has from being logged into Claude.ai.

The badge updates live and shows:

- **Session usage** — how much of your current session window you've used, with a reset timer
- **Weekly usage** — your rolling weekly limit, with a countdown to when it resets
- **Extra credits balance** — if you have any add-on credits, they show up here too

## The colour coding

The badge changes colour based on how close you are to your limits:

- **Green** — you're in good shape, plenty of headroom
- **Amber** — getting close, worth being mindful
- **Red** — you're near the limit, Claude may start slowing responses

That last one is the reason I built this. I'd rather know I'm at 90% *before* I paste in a 10,000-word document than find out after I hit send.

## How to install it

Just head to the [Chrome Web Store listing](https://chromewebstore.google.com/detail/claude-usage-monitor/nopnffbnihnabiocahnfmfhjkhehmmlh) and click "Add to Chrome." That's it. As long as you're logged into Claude.ai in the same browser, the extension picks up your session automatically.

It requires a Claude Pro or Max account — the free tier doesn't expose the same usage data.

## Privacy

The extension doesn't collect or transmit any data. It reads your usage stats locally from your Claude.ai session and displays them in the popup. The [source code is on GitHub](https://github.com/akaaja2/claude-usage-monitor) if you want to check for yourself.

---

It's a small thing, but I've found it genuinely changes how I work with Claude day-to-day. Give it a try and let me know what you think.
