---
title: "I Built a Windows Notification to Approve Claude Code Actions Without Switching Windows"
date: 2026-03-21
description: "Claude Code's built-in Allow/Deny prompt requires you to switch focus to the terminal. Here's how I replaced it with a Windows toast notification you can approve from anywhere on your desktop — using Claude Code's own hooks system."
tags: ["post", "claude-code", "automation", "windows", "hooks"]
layout: "layouts/post.njk"
image: "/images/claude-code-toast-approver.png"
imageAlt: "Three-panel illustration showing Claude Code firing a tool call, a Windows toast notification appearing with Allow and Deny buttons, and Claude proceeding after approval"
---

If you use Claude Code with auto-accept turned off — which is the sensible default when you're working on anything important — you'll know the friction: Claude decides to run a command, and you have to switch focus to the Claude Code window, find the prompt, click Allow, then switch back to whatever you were actually doing.

It's not a dealbreaker. But when you're running a long agentic session and Claude is firing twenty commands, that focus-switching adds up. It also means you're always tethered to the terminal window.

I wanted something different: a Windows notification I could approve from anywhere on my desktop, without switching focus at all. So I built one.

## How Claude Code's hooks system works

Claude Code has a hooks API that lets you intercept tool calls before they execute. You configure a `PreToolUse` hook in `~/.claude/settings.json`, point it at a script, and Claude Code will pipe the pending tool call as JSON to that script's stdin before doing anything.

Your script then outputs a `permissionDecision` — `"allow"` or `"deny"` — as JSON to stdout. The critical detail: when your hook outputs a permission decision, Claude Code skips its own built-in prompt entirely. You get one dialogue, not two.

The event JSON Claude Code sends looks like this:

```json
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "git add src/posts/my-post.md && git status"
  },
  "session_id": "abc123..."
}
```

And the response your script needs to print:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow"
  }
}
```

That's the entire contract. The rest is just plumbing.

## The architecture

The hook script does four things:

1. Reads the tool event JSON from stdin
2. Formats it into a short human-readable description
3. Shows a Windows toast notification with four buttons — Allow, Always (session), Always (this tool), Deny
4. Blocks until the user clicks, then prints the permission decision JSON to stdout

Windows toasts with action buttons are handled by the `windows-toasts` Python library. The hook blocks synchronously, which is exactly what Claude Code expects — it waits for the script to exit before proceeding.

```
Claude Code wants to run a tool
        │
        ▼
PreToolUse hook fires
        │
        ▼
approver.py reads JSON from stdin
        │
        ▼
Windows toast appears with four buttons
        │
   User clicks
        │
  ┌─────┴──────┐
Allow         Deny
  │               │
  ▼               ▼
Hook exits 0   Hook exits 0
JSON: allow    JSON: deny
```

## The four buttons

A simple Allow/Deny is enough for one-off commands, but for a long agentic session it gets tedious. I added two session-level shortcuts:

**Always Allow (session)** — writes a flag file to `%TEMP%\claude-approver\<session_id>\allow_all`. Every subsequent hook call checks for that file first and silently allows without showing a toast. The flag is scoped to the session ID, so it resets automatically when you start a new Claude Code session.

**Always Allow (this tool)** — same idea, but scoped to the tool type. So you could say "always allow Bash commands this session" while still getting prompted for `Edit` and `Write` operations on files. The flag file is named `allow_tool_Bash`, `allow_tool_Edit`, etc.

This maps well to how I actually work: long coding sessions where I trust shell commands but still want to eyeball file writes.

## The fallback

The `windows-toasts` library handles the toast. But if it's ever unavailable — import error, compatibility issue, anything — the script automatically falls back to a PowerShell Windows Forms dialog with the same four buttons. The fallback is pure PowerShell with no external dependencies, so it's rock-solid.

I never actually see the fallback in practice, but it's good to know it's there.

## Installation

Two files: `setup.ps1` and `approver.py`. Keep them in the same folder and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

The setup script finds your Python installation, installs `windows-toasts`, copies `approver.py` to `~\.claude\hooks\`, and patches `settings.json` with the hook entry. Restart Claude Code and it's live.

This is a one-time setup. The hook persists in `settings.json` permanently — no need to re-run anything after reboots or Claude Code updates.

## Version stability

The hooks API uses a stable, documented schema. The `PreToolUse` event and `permissionDecision` output format are part of Claude Code's core hooks contract. New Claude Code releases won't break this unless Anthropic make a breaking schema change — which they'd announce in release notes.

The `approver.py` script itself has no hardcoded paths or user-specific data. Anyone can take the two files and run `setup.ps1` on their own machine.

## What I'd add next

A few things are on the list:

- **Always Allow (this command pattern)** — regex-match a command and auto-allow it permanently, not just for the session. Useful for things like `git status` that are always safe.
- **Notification history** — a small log of what was allowed and denied in the current session, so you can review what Claude actually did.
- **Diff preview in the notification** — for file edits, show the first few changed lines in the toast body before you approve.

The last one requires pulling the diff from the tool input, but the data is already in the hook JSON — it just needs formatting.

---

The files are [available on GitHub](https://github.com/akaaja2/toast-approver) — `setup.ps1`, `approver.py`, and a README covering customisation, troubleshooting, and how to extend the matcher to cover MCP tools. If you build on this or hit issues on a different Windows setup, I'd be curious to hear about it.

The whole thing took about two hours from idea to working toast notification — mostly because I built it in Claude Code, using the same hooks system it was being built to improve.
