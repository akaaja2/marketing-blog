$ErrorActionPreference = "Stop"

$outputPath = "C:\Users\alexj\Projects\Claude\marketing-blog\output\pdf\claude4marketing-app-summary.pdf"

function Add-Paragraph {
  param(
    [object]$Selection,
    [string]$Text,
    [int]$Size = 10,
    [bool]$Bold = $false,
    [int]$SpaceAfter = 4
  )

  $Selection.Font.Name = "Arial"
  $Selection.Font.Size = $Size
  $Selection.Font.Bold = [int]$Bold
  $Selection.ParagraphFormat.SpaceAfter = $SpaceAfter
  $Selection.ParagraphFormat.SpaceBefore = 0
  $Selection.ParagraphFormat.LineSpacingRule = 0
  $Selection.ParagraphFormat.LeftIndent = 0
  $Selection.ParagraphFormat.FirstLineIndent = 0
  $Selection.TypeText($Text)
  $Selection.TypeParagraph()
}

function Add-Bullets {
  param(
    [object]$Selection,
    [string[]]$Items,
    [int]$Size = 9
  )

  $range = $Selection.Range
  foreach ($item in $Items) {
    $Selection.Font.Name = "Arial"
    $Selection.Font.Size = $Size
    $Selection.Font.Bold = 0
    $Selection.ParagraphFormat.SpaceAfter = 2
    $Selection.ParagraphFormat.SpaceBefore = 0
    $Selection.ParagraphFormat.LeftIndent = 18
    $Selection.ParagraphFormat.FirstLineIndent = -10
    $Selection.TypeText($item)
    $Selection.TypeParagraph()
  }

  $bulletRange = $range.Document.Range($range.Start, $Selection.Range.Start)
  $bulletRange.ListFormat.ApplyBulletDefault()
  $Selection.ParagraphFormat.LeftIndent = 0
  $Selection.ParagraphFormat.FirstLineIndent = 0
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false

try {
  $doc = $word.Documents.Add()
  $doc.PageSetup.TopMargin = 30
  $doc.PageSetup.BottomMargin = 30
  $doc.PageSetup.LeftMargin = 34
  $doc.PageSetup.RightMargin = 34

  $sel = $word.Selection

  Add-Paragraph -Selection $sel -Text "Claude4Marketing" -Size 22 -Bold $true -SpaceAfter 2
  Add-Paragraph -Selection $sel -Text "One-page repo summary" -Size 11 -Bold $false -SpaceAfter 6

  Add-Paragraph -Selection $sel -Text "What it is" -Size 11 -Bold $true -SpaceAfter 1
  Add-Paragraph -Selection $sel -Text "Claude4Marketing is a marketing-focused blog built with Eleventy and managed largely through Claude Code. Repo evidence shows a static publishing workflow built from Markdown, Nunjucks templates, Pagefind search indexing, and Netlify deployment." -Size 9 -SpaceAfter 4

  Add-Paragraph -Selection $sel -Text "Who it's for" -Size 11 -Bold $true -SpaceAfter 1
  Add-Paragraph -Selection $sel -Text "Primary persona: marketers and builders experimenting with AI-assisted publishing, content workflows, and Claude-based marketing tools." -Size 9 -SpaceAfter 4

  Add-Paragraph -Selection $sel -Text "What it does" -Size 11 -Bold $true -SpaceAfter 1
  Add-Bullets -Selection $sel -Items @(
    "Publishes Markdown posts from src/posts/.",
    "Renders a homepage with post cards, dates, tags, and reading-time estimates.",
    "Builds post pages with related posts, share links, and syntax highlighting.",
    "Generates tag pages, RSS feed, sitemap, robots.txt, and a custom 404 page.",
    "Provides client-side search through Pagefind on /search/.",
    "Supports downloadable Markdown files via /downloads/.",
    "Adds browser-side post reactions backed by Supabase reads and RPC calls."
  ) -Size 9

  Add-Paragraph -Selection $sel -Text "How it works" -Size 11 -Bold $true -SpaceAfter 1
  Add-Bullets -Selection $sel -Items @(
    "Content: Markdown posts plus site metadata in src/posts/ and src/_data/metadata.json.",
    "Build: .eleventy.js adds RSS, date and reading-time filters, related-post logic, a tag collection, and passthrough copies.",
    "Templates: Nunjucks layouts and route templates under src/_includes/ and src/*.njk render the site.",
    "Search flow: npm run build runs Eleventy first, then Pagefind indexes _site/ for browser search.",
    "Runtime flow: browser loads static HTML/CSS/JS; post pages also call Supabase directly for reaction counts.",
    "Deploy: netlify.toml runs npm run build and publishes _site/.",
    "Not found in repo: automated tests, a separate backend service, or an admin/CMS app."
  ) -Size 9

  Add-Paragraph -Selection $sel -Text "How to run" -Size 11 -Bold $true -SpaceAfter 1
  Add-Bullets -Selection $sel -Items @(
    "Run npm install to install dependencies.",
    "Run npm start to start the local Eleventy dev server.",
    "Run npm run build to create production output and Pagefind assets.",
    "Serve or deploy the generated site from _site/."
  ) -Size 9

  $pages = $doc.ComputeStatistics(2)
  Write-Output "PAGE_COUNT=$pages"
  $doc.ExportAsFixedFormat($outputPath, 17)
  $doc.Close($false)
}
finally {
  $word.Quit()
}
