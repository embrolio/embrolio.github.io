# Brainstorm: Publishing Section for brolio.dev

Date: 2026-04-16
Status: accepted

## Problem Restatement

Add a writing/publishing section to the existing single-page portfolio site while maintaining:
- Zero build tools (vanilla HTML/CSS/JS)
- GitHub Pages hosting
- OG/social preview cards for sharing
- Consistent visual identity (particles, aesthetic)
- Git-based publishing workflow (push to publish)

The site owner will publish ~1 article per week, expects 4-20 articles over 6 months, with lengths of 950-1,400 words.

## Hidden Assumptions Identified

1. **"One page only" vs "navigation"** — These are in tension; the solution is minimal addition (bottom link), not a full nav refactor
2. **OG cards require static files** — Pure client-side routing cannot satisfy social crawler requirements
3. **Markdown seems right but isn't** — For <20 articles, manual HTML is less friction than setting up a build pipeline
4. **The real blocker is shipping, not architecture** — 4 finished articles exist unpublished

## Approaches Considered

### 1. The Template Duplication (SELECTED)

**Core idea:** Manually create `/writing/article-slug.html` for each post. Copy-paste a template with OG tags pre-filled. You are the build step.

**Pros:**
- Perfect OG cards and SEO
- Zero dependencies forever
- Each article can customize particle colors if desired
- Articles render without JavaScript
- No build pipeline to maintain

**Cons:**
- Manual copy-paste ritual (~2 min per post)
- Navigation changes require editing N files
- No automation for "latest post" detection

**Risks:**
- Friction may reduce publishing frequency over time
- Template drift between articles possible

**Effort:** S (initial), M (ongoing at scale)

**Migration path:** When volume exceeds ~20 posts or friction becomes annoying, migrate to Approach 3 (GitHub Actions build) using the same file structure.

### 2. The JSON Manifest (NOT SELECTED)

**Core idea:** `/writing/index.html` fetches `/writing/posts.json` to render article list and latest content dynamically.

**Why rejected:** Requires JavaScript for content discovery (SEO/crawler issue), creates two-file-per-post overhead, and doesn't solve OG card requirements without additional complexity.

### 3. The Build-Less Build (DEFERRED)

**Core idea:** GitHub Actions converts Markdown → HTML on push using Python/Jinja templates.

**Why deferred:** Correct solution for high volume (20+ posts), but premature for current needs. The "zero build tools" constraint is actually "zero *local* build tools" — GitHub Actions is acceptable when volume justifies it.

**Activation trigger:** When friction from Approach 1 becomes annoying or post count exceeds 20.

## Decisions Made

| Aspect | Decision |
|--------|----------|
| **Font** | Source Serif 4 (400 regular, 600 semibold for headings) |
| **Body text font stack** | `'Source Serif 4', Georgia, serif` |
| **URL structure** | `/writing/{slug}.html` (e.g., `/writing/solo-dev-cognitive-bridge.html`) |
| **Homepage link** | Text link "Articles" at bottom of page |
| **Article listing** | Sidebar or bottom index on `/writing/index.html` showing all posts with dates |
| **Reading progress** | Visual indicator (top bar or sidebar) showing scroll position |
| **Reading time** | Displayed on each article (~2-3 min for current pieces) |
| **OG cards** | Full Open Graph tags (title, description, image optional) |
| **Format** | Static HTML files with embedded CSS |
| **Initial approach** | Template duplication (Approach 1) |

## Article Structure Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{Article Title} | brolio.dev</title>
  
  <!-- OG Cards -->
  <meta property="og:title" content="{Article Title}">
  <meta property="og:description" content="{Excerpt ~150 chars}">
  <meta property="og:type" content="article">
  <meta property="og:url" content="https://brolio.dev/writing/{slug}.html">
  <meta property="og:site_name" content="brolio.dev">
  <meta name="twitter:card" content="summary">
  
  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Source+Serif+4:ital,wght@0,400;0,600;1,400&family=Fira+Code&display=swap" rel="stylesheet">
  
  <!-- Styles: inline or linked (decide in design phase) -->
  <style>
    /* Article-specific styles */
  </style>
</head>
<body>
  <!-- Particle canvas background (consistent with homepage) -->
  <canvas id="trails"></canvas>
  
  <!-- Reading progress indicator -->
  <div class="reading-progress"></div>
  
  <main class="article-container">
    <article>
      <header class="article-header">
        <h1>{Article Title}</h1>
        <div class="article-meta">
          <time datetime="{ISO date}">{Readable date}</time>
          <span class="reading-time">{X} min read</span>
        </div>
      </header>
      
      <div class="article-content">
        <!-- Article body here -->
      </div>
    </article>
    
    <aside class="article-sidebar">
      <!-- Index of all articles -->
      <nav class="article-index">
        <h3>All Articles</h3>
        <ul><!-- Populated manually or via JS --></ul>
      </nav>
    </aside>
  </main>
  
  <!-- Back to home -->
  <nav class="site-nav">
    <a href="/">← Back to brolio.dev</a>
  </nav>
  
  <script>
    // Reading progress tracking
    // Particle system (reused from homepage)
  </script>
</body>
</html>
```

## Features to Implement

### Required
- [ ] Source Serif 4 font loading
- [ ] Article template with OG tags
- [ ] `/writing/` directory structure
- [ ] Homepage "Articles" link (bottom placement)
- [ ] Reading progress indicator
- [ ] Article index/navigation
- [ ] Reading time calculation
- [ ] Consistent particle background

### Nice to Have
- [ ] Estimated reading time in index
- [ ] Article-specific accent colors (subtle)
- [ ] Smooth scroll between sections
- [ ] Print-friendly styles
- [ ] Code syntax highlighting (if articles contain code)

## Homepage Integration

Add at bottom of `index.html`, after the social links:

```html
<div class="site-footer">
  <!-- existing status -->
  <div class="footer-links">
    <a href="/writing/index.html" class="footer-link">Articles</a>
  </div>
</div>
```

Style: Subtle, same color as `--text-dim`, no underline until hover. Should feel like a signature, not a call-to-action.

## Next Steps

1. **Design phase:** Define exact CSS structure, layout (single column vs sidebar), reading progress UI
2. **Create template:** Build `/writing/template.html` with all boilerplate
3. **First article:** Convert one existing article to validate template
4. **Homepage link:** Add "Articles" footer link to `index.html`
5. **Iterate:** Publish first 4 articles, gather friction feedback

## Migration Plan (Approach 1 → 3)

When volume justifies automation:
1. Create `_articles/` folder for Markdown source
2. Add GitHub Actions workflow for Markdown → HTML conversion
3. Maintain same output URLs (`/writing/{slug}.html`)
4. No breaking changes for existing links

---

**Decision:** Proceed with Approach 1 (Template Duplication) for immediate shipping. Revisit automation at 20+ posts or when friction becomes painful.
