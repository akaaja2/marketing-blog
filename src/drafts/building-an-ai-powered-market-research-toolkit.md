# Building an AI-Powered Market Research Toolkit with Claude: From Study Plans to Production Pipeline

*A behind-the-scenes look at how two 20-hour learning programmes, a suite of reusable skills, and a fully automated research pipeline came together.*

---

## Overview

This post documents the full arc of a project to build a professional-grade, AI-powered market research toolkit — from first principles to production-ready automation. It covers two parallel learning tracks, the skills and slash commands created along the way, and a demo pipeline that takes a research brief from raw input to a client-ready Word document in a single workflow.

The work is built on three interlocking layers:

1. **Deep technical knowledge** — understanding MCP (Model Context Protocol) at the protocol level
2. **Applied tooling** — using Claude Code as an agentic research assistant
3. **Reusable automation** — custom skills and slash commands that encode best-practice workflows

---

## Part 1: The Two Learning Tracks

### Track A — MCP Servers (20 Hours)

**Goal:** Architect, build, test, and deploy custom MCP servers in Python — and understand the protocol deeply enough to teach it to executive audiences.

The plan was structured as ten two-hour sessions, progressing from protocol fundamentals to production deployment:

| Sessions | Focus |
|---|---|
| 1–2 | Protocol architecture (JSON-RPC 2.0, transport layer, the three primitives) |
| 3–4 | First Python server using FastMCP; connecting to Claude Desktop and the MCP Inspector |
| 5–6 | Production tool design (validation, error handling, annotations); Resources and Prompts |
| 7–8 | Real-world SQLite integration; security, OAuth 2.1, and the November 2025 spec |
| 9–10 | Remote deployment via Streamable HTTP + Docker; ecosystem navigation and teaching materials |

**Key insight from this track:** MCP is not just a convenient integration layer — it is a carefully specified protocol (built on JSON-RPC 2.0, borrowing architecture from the Language Server Protocol) with real security implications. The November 2025 spec classified MCP servers as OAuth Resource Servers, introduced server identity verification, and formalised long-running task support. Any organisation adopting MCP at scale needs to understand these changes before they deploy.

**Practical outcome:** A working SQLite-backed MCP server, a security briefing document suitable for non-technical stakeholders, and a 30-minute seminar outline titled *"MCP for Business Leaders: What You Need to Know"*.

---

### Track B — Claude Code for Market Researchers (20 Hours)

**Goal:** Use Claude Code fluently across the four pillars of market research — survey design and analysis, competitor and industry intelligence, data scraping and collection, and report generation — and deliver a half-day training workshop curriculum.

Ten sessions, structured to build from tooling fundamentals to a full production pipeline:

| Sessions | Focus |
|---|---|
| 1–2 | Claude Code configuration; CLAUDE.md; the plan-review-execute-review workflow |
| 3–4 | Custom slash commands for repeatable tasks; survey design and analysis |
| 5–6 | Web scraping (fetch → BeautifulSoup → Playwright); competitor intelligence workflows |
| 7–8 | Automated report generation (.docx output); MCP server integrations |
| 9–10 | Consolidating the toolkit; designing the training programme |

**Key insight from this track:** The single most important Claude Code pattern for research work is *directing*, not just prompting. Using Plan Mode (Shift+Tab twice) before any multi-step task — so Claude outlines its approach before writing code — is the difference between a reliable research assistant and an unsupervised one that races ahead with bad assumptions.

**Practical outcome:** A configured `market-research-toolkit/` project directory, three core slash commands, a survey analysis pipeline, a competitor intelligence workflow, an automated `.docx` report generator, and a half-day workshop outline ready to deliver.

---

## Part 2: The Skills Built

Two production-grade skills were developed as reusable, self-documenting workflow files. They encode the same standards you would give a senior analyst briefing on their first day.

### Skill 1 — Competitor Analysis

**File:** `SKILL.md`

This skill triggers on any competitive intelligence request — from "who are the main players in X" to uploaded competitor pricing pages. It enforces a five-step workflow:

1. **Plan first** — switch to Plan Mode, identify companies in scope, list data points to collect, confirm sources, and wait for user sign-off before executing
2. **Research each competitor** — core profile (value proposition, target market, business model), commercial data (pricing, key features), strategic signals (funding, scale, recent moves), and positioning intelligence (homepage messaging, review-pattern weaknesses)
3. **Comparison table** — structured Markdown matrix with competitors as columns, attributes as rows, and explicit `[UNVERIFIED]` flags for any unconfirmed data
4. **SWOT summaries** — four-quadrant analysis per company, with a quality rule that every bullet must be *distinctive* to that company, not generic sector boilerplate
5. **Landscape briefing** — a 300–400 word narrative covering market structure, basis of competition, white space, and dynamics to watch

Output files are saved to `outputs/competitor-analysis/` as three separate Markdown files (and optionally an XLSX with a source log).

**Quality standard:** Accuracy over completeness. A table with several `[UNVERIFIED]` cells is better than one filled with plausible-sounding fabrications.

---

### Skill 2 — Generate Report

**File:** `generate-report-SKILL.md`

This skill triggers whenever analysis outputs need to become a formatted client document. It takes any combination of CSVs, Markdown summaries, and chart PNGs and produces a properly structured `.docx` file with a title page, auto-generated table of contents, embedded charts, page numbers, and a style-mapped body.

The five-step workflow:

1. **Plan first** — confirm what analysis outputs exist, who the report is for, which sections are needed, and which charts to generate
2. **Report template** — creates a `report_template.md` with seven standard sections: Executive Summary (written last, placed first), Methodology, Key Findings, Detailed Results, Recommendations, and Data Appendix
3. **Chart generation** — Python scripts using `matplotlib`/`seaborn` with enforced standards: 10×6 inches, titled axes, data source footnotes, 150 dpi PNG output, and a lookup table mapping use cases to the correct chart type
4. **Template population** — fills each section with analysis results in plain, client-ready English; specific numbers over vague summaries
5. **docx conversion** — `python-docx` script producing a title page, ToC, embedded charts with captions, and A4 page layout

**Quality standard:** Lead with insight, not method. Key Findings should state *what it means*, not just *what the numbers say*.

---

## Part 3: The Demo Pipeline

The following is a complete end-to-end workflow — from a research brief to a client-ready Word document — using all the components built across both tracks.

### Pipeline Overview

```
Research Brief
      │
      ▼
┌─────────────────────┐
│  /competitor-scan   │  Slash command → structured Markdown per company
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  Playwright MCP     │  Browser scraping → pricing data, screenshots
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  SQLite MCP Server  │  Cross-reference scraped data with research database
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  Competitor Analysis│  Skill → comparison table, SWOTs, landscape briefing
│  Skill              │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  Generate Report    │  Skill → charts + populated template + .docx output
│  Skill              │
└─────────┬───────────┘
          │
          ▼
  outputs/reports/
  [client-report].docx
```

### Step-by-Step Walkthrough

**Step 1 — Brief Claude and switch to Plan Mode**

```
/competitor-scan UK health-tech: Accurx, Babylon Health, Kry, Livi
```

Before executing, Claude outlines its research approach — which data points it will collect per company, which sources it will use, and what outputs it will produce. You review and confirm.

**Step 2 — Web scraping with Playwright**

Claude uses the Playwright MCP server to visit each company's pricing and product pages, capturing structured data and screenshots. For JavaScript-rendered pages that block simple HTTP requests, Playwright handles full browser rendering.

**Step 3 — Database cross-reference**

The custom SQLite MCP server queries a `competitor_data` table for any previously stored intelligence on these companies — funding rounds logged from prior research, notes from sales conversations, historical pricing snapshots. Claude merges this with the fresh scraped data.

**Step 4 — Competitor Analysis skill**

Claude runs the full five-step competitor analysis workflow — comparison table, SWOT summaries per company, landscape briefing — saving each file to `outputs/competitor-analysis/`.

**Step 5 — Report generation**

```
/generate-report outputs/competitor-analysis/ --audience "Board of Directors" --title "UK Health-Tech Competitive Landscape Q2 2026"
```

Claude generates the required charts (horizontal bar comparisons, a funding stage matrix, a positioning map), populates the seven-section template, writes the Executive Summary last, and converts everything to a formatted `.docx`.

**Total elapsed time (observed):** Approximately 12–18 minutes for a four-company analysis, depending on site complexity. Human intervention required at two points: confirming the Plan Mode outline (Step 1) and reviewing the Executive Summary draft before final export.

---

## Part 4: What This Enables

Taken together, the two learning tracks and the production pipeline change what a single researcher can realistically deliver:

**Before:** A four-company competitor analysis might take a day — manual browsing, copy-pasting into a spreadsheet, formatting a Word document by hand.

**After:** The same analysis takes under 30 minutes of directed work, with the researcher's time spent on strategic interpretation rather than data collection and formatting.

The toolkit also creates a teachable, repeatable system. Because the workflows are encoded in SKILL.md files and slash commands — not just in one person's head — they can be handed to a junior researcher, taught in a half-day workshop, or adapted for a new industry vertical in an afternoon.

---

## Part 5: Security and Governance Considerations

Both tracks surfaced important caveats that any organisation adopting this kind of pipeline should address.

**On MCP servers:** The November 2025 spec introduced OAuth 2.1 authorisation and server identity verification, but many third-party MCP servers in the wild pre-date these standards. Tool poisoning (a malicious server returning instructions that hijack another server's behaviour) and cross-server shadowing are documented attack vectors. Any production deployment should run MCP servers in isolated environments and audit tool descriptions before connecting them to agents with write access.

**On web scraping:** The Playwright-based scraping in this pipeline is subject to each target site's terms of service. For commercial market research, verify that scraping is permitted and consider whether a licensed data provider is more appropriate for regulated industries.

**On AI-generated research:** The `[UNVERIFIED]` flag pattern in the competitor analysis skill is not optional decoration — it is a quality gate. Any claim that cannot be traced to a verifiable source must be flagged. Senior stakeholders reading outputs should know what has been confirmed and what has been inferred.

---

## Conclusion

This project started as two separate learning plans and became a coherent, production-ready system. The MCP track provided the protocol knowledge to build reliable server integrations. The Claude Code track provided the workflow discipline to use that infrastructure productively. The SKILL.md files are the connective tissue — encoding quality standards and structured procedures so that automation produces consistent, client-ready outputs rather than plausible-looking noise.

The half-day workshop curriculum built in the final session of Track B is the acid test: if you can teach this system to a market researcher with no coding background and have them producing useful outputs within three hours, the abstractions are at the right level.

That workshop is ready to deliver.

---

*Study plans, skill files, and slash commands referenced in this post are available in the project directory. The demo pipeline assumes Claude Code with Playwright MCP and a local SQLite MCP server configured. See the Prerequisites Checklist in the Claude Code study plan for environment setup.*
