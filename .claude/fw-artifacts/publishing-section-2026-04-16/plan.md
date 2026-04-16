# Implementation Plan (REVISED)

**Issue**: Add publishing/writing section to brolio.dev  
**Architecture**: Option B — Canonical Index + Shared Writing Runtime (REVISED)  
**Generated**: 2026-04-16T17:00:00Z

**Changes from original plan:**
- ✅ Revised project constraints (documented in AGENTS.md)
- ✅ Fixed breakpoint: 1040px (was 901px)
- ✅ Removed particles from articles (clean reading experience)
- ✅ Simplified sidebar: static markup (no fetch/parse)
- ✅ Added OG image strategy (shared default image)
- ✅ Updated twitter:card to summary_large_image

## Overview

Create a `/writing/` section for the portfolio site with static article pages, a shared runtime for UX enhancements (reading progress, reading time, mobile nav), and a canonical article index. Articles are standalone HTML files with OG tags including images for social sharing.

**Key principle:** Clean reading experience — no particle distraction on long-form content.

## Files to Create

| File | Purpose | Lines (est.) |
|------|---------|--------------|
| `writing/template.html` | Article template with OG tags, static sidebar | ~130 |
| `writing/index.html` | Article listing/archive page | ~100 |
| `writing/styles.css` | Shared writing styles | ~320 |
| `writing/writing.js` | Shared runtime (progress, reading time, mobile nav) | ~180 |
| `writing/og-image.jpg` | Default OG image (1200×630px) | binary |

## Files to Modify

| File | Changes | Lines (est.) |
|------|---------|--------------|
| `index.html` | Add "Articles" footer link + minimal CSS | ~20 |
| `AGENTS.md` | Document constraint revision | ~20 |

## Implementation Steps

### Step 1: Create Writing Directory Structure
- [ ] Create `/writing/` directory
- [ ] Verify GitHub Pages will serve the directory

### Step 2: Build Shared Stylesheet (`writing/styles.css`)

**Visual Foundation:**
- [ ] Mirror homepage `:root` custom properties (`--bg`, `--surface`, `--text-primary`, `--accent`, etc.)
- [ ] Add Source Serif 4 font family declaration
- [ ] Define writing-specific tokens:
  - `--writing-max-width: 680px`
  - `--writing-sidebar-width: 280px`
  - `--writing-gap: 80px`
  - `--writing-prose-spacing: 1.8em`
  - `--progress-height: 3px`

**Fixed Layer Stack (NO PARTICLES):**
- [ ] Noise texture background (CSS or SVG, subtle)
- [ ] Vignette overlay (edges darker)
- [ ] Content layer on top

**Two-Column Layout:**
- [ ] `.writing-layout` as container
  - `display: grid`
  - `grid-template-columns: 1fr 280px`
  - `gap: 80px`
  - `max-width: 1040px` (680 + 80 + 280)
  - `margin: 0 auto`
- [ ] `.writing-main` for article content
- [ ] `.writing-sidebar` for navigation
  - `position: sticky`
  - `top: 40px`
  - `align-self: start`

**Responsive Breakpoints (REVISED):**
- [ ] `1040px+`: Two-column grid, sidebar visible
- [ ] `640px–1039px`: Single column, sidebar becomes top section
- [ ] `<=640px`: Reduced heading scale (`font-size: 28px` H1)
- [ ] `<=480px`: Minimal padding (`padding: 20px`)

**Typography:**
- [ ] Body text: Source Serif 4, 18px, line-height 1.7
- [ ] Headings: Source Serif 4, semibold (600)
- [ ] Meta/UI: System sans-serif or Inter, 14px
- [ ] Max line length: 680px (optimal reading measure)

**Component Styles:**
- [ ] `.reading-progress` — fixed top bar, 3px height
- [ ] `.writing-article-header` — title + meta block
- [ ] `.writing-article-content` — body text styles
  - Paragraph spacing: 1.8em
  - Link styling: accent color, underline on hover
  - Code blocks: Fira Code, dark background
- [ ] `.writing-meta` — date + reading time
- [ ] `.writing-sidebar__list` — article index
- [ ] `.writing-sidebar__item` — article link + date
- [ ] `.writing-sidebar__item--current` — active state styling

**Print Styles:**
- [ ] Hide progress bar, sidebar, decorative elements
- [ ] Ensure good contrast for printing

### Step 3: Build Article Template (`writing/template.html`)

**HTML5 Boilerplate:**
- [ ] `<meta charset="UTF-8">`
- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1.0">`
- [ ] `<title>{Article Title} | brolio.dev</title>`

**OG Tags (Rich Cards):**
- [ ] `og:title` — Article title
- [ ] `og:description` — Excerpt (~150 chars)
- [ ] `og:type=article`
- [ ] `og:url` — Full URL
- [ ] `og:site_name=brolio.dev`
- [ ] `og:image` — `https://brolio.dev/writing/og-image.jpg`
- [ ] `twitter:card=summary_large_image`
- [ ] `twitter:title`, `twitter:description`, `twitter:image`

**Font Loading:**
- [ ] Preconnect to Google Fonts
- [ ] Load Source Serif 4 (400, 600)
- [ ] Load Fira Code (for code blocks)
- [ ] Link to `styles.css`

**Body Structure:**
```html
<body>
  <div class="reading-progress"></div>
  
  <div class="noise-bg"></div> <!-- optional -->
  <div class="vignette"></div>
  
  <div class="writing-layout">
    <main class="writing-main">
      <article data-reading-time>
        <header class="writing-article-header">
          <h1>{Article Title}</h1>
          <div class="writing-meta">
            <time datetime="{ISO date}">{Readable date}</time>
            <span class="reading-time">{X} min read</span>
          </div>
        </header>
        
        <div class="writing-article-content">
          <!-- Article body -->
        </div>
      </article>
      
      <nav class="writing-back">
        <a href="/">← Back to brolio.dev</a>
        <a href="/writing/">← All Articles</a>
      </nav>
    </main>
    
    <aside class="writing-sidebar">
      <nav class="writing-sidebar__nav">
        <h3>All Articles</h3>
        <ul class="writing-sidebar__list">
          <!-- STATIC SIDEBAR SNIPPET -->
          <!-- Copy from writing/index.html when publishing -->
          <li class="writing-sidebar__item writing-sidebar__item--current">
            <a href="/writing/this-article.html">This Article Title</a>
            <time>Apr 16, 2026</time>
          </li>
          <!-- ... other articles ... -->
        </ul>
      </nav>
    </aside>
  </div>
  
  <script src="writing.js" defer></script>
</body>
```

### Step 4: Build Canonical Index Page (`writing/index.html`)

**Structure:**
- [ ] Same HTML5 boilerplate as template
- [ ] OG tags for index page (different title: "Articles | brolio.dev")

**Content:**
- [ ] Intro section:
  ```html
  <header class="writing-section-header">
    <h1>Articles</h1>
    <p>Thoughts on development, design, and building things.</p>
  </header>
  ```
- [ ] Article list:
  ```html
  <section class="writing-archive">
    <ul class="writing-archive__list">
      <li class="writing-archive__item">
        <article>
          <h2><a href="/writing/article-slug.html">Article Title</a></h2>
          <div class="writing-archive__meta">
            <time datetime="2026-04-16">Apr 16, 2026</time>
            <span class="reading-time">3 min read</span>
          </div>
          <p class="writing-archive__excerpt">Brief excerpt or description...</p>
        </article>
      </li>
      <!-- ... more articles ... -->
    </ul>
  </section>
  ```
- [ ] Sidebar (self-reference or recent articles)
- [ ] Back to home link

### Step 5: Build Shared Runtime (`writing/writing.js`)

**Reading Time Calculation:**
```javascript
function calculateReadingTime() {
  const article = document.querySelector('[data-reading-time]');
  if (!article) return;
  
  const text = article.textContent || '';
  const words = text.trim().split(/\s+/).length;
  const minutes = Math.ceil(words / 200); // 200 WPM
  
  const display = document.querySelector('.reading-time');
  if (display) {
    display.textContent = `${minutes} min read`;
  }
}
```

**Reading Progress Bar:**
```javascript
function initProgressBar() {
  const progress = document.querySelector('.reading-progress');
  const article = document.querySelector('.writing-article-content');
  
  if (!progress || !article) return;
  
  function updateProgress() {
    const rect = article.getBoundingClientRect();
    const viewportHeight = window.innerHeight;
    const articleHeight = article.offsetHeight;
    
    const scrolled = -rect.top;
    const total = articleHeight - viewportHeight;
    const percent = Math.max(0, Math.min(100, (scrolled / total) * 100));
    
    progress.style.width = `${percent}%`;
  }
  
  window.addEventListener('scroll', updateProgress, { passive: true });
  updateProgress();
}
```

**Mobile Sidebar Toggle:**
```javascript
function initMobileNav() {
  const sidebar = document.querySelector('.writing-sidebar');
  if (!sidebar || window.innerWidth > 1040) return;
  
  // Add toggle button for mobile
  const toggle = document.createElement('button');
  toggle.className = 'writing-sidebar__toggle';
  toggle.textContent = 'All Articles';
  toggle.setAttribute('aria-expanded', 'false');
  
  toggle.addEventListener('click', () => {
    const isOpen = sidebar.classList.toggle('writing-sidebar--open');
    toggle.setAttribute('aria-expanded', isOpen);
  });
  
  sidebar.insertBefore(toggle, sidebar.firstChild);
}
```

**Initialize:**
```javascript
document.addEventListener('DOMContentLoaded', () => {
  calculateReadingTime();
  initProgressBar();
  initMobileNav();
});
```

### Step 6: Create OG Image

**Specifications:**
- [ ] Dimensions: 1200×630px (optimal for social sharing)
- [ ] Format: JPG (smaller) or PNG (if transparency needed)
- [ ] Content:
  - Dark background matching site (`#0a0a0f` or `#12121a`)
  - "brolio.dev" text
  - Abstract geometric element (optional)
  - Cyan/aqua accent (`#64ffda`) for visual link to site
- [ ] Save as `writing/og-image.jpg`

**Alternative:** Use a simple SVG-based OG image that can be embedded:
```html
<meta property="og:image" content="https://brolio.dev/writing/og-image.svg">
```

### Step 7: Add Homepage Link (`index.html`)

**Location:** Below the `.status` block

```html
<div class="site-footer">
  <div class="footer-links">
    <a href="/writing/" class="footer-link">Articles</a>
  </div>
</div>
```

**CSS:**
```css
.footer-links {
  margin-top: 2rem;
  text-align: center;
}

.footer-link {
  color: var(--text-dim);
  text-decoration: none;
  font-size: 0.9rem;
  transition: color 0.2s ease;
}

.footer-link:hover {
  color: var(--accent);
}
```

### Step 8: Testing & Validation

**Visual:**
- [ ] Typography renders correctly (Source Serif 4 loads)
- [ ] Two-column layout at 1040px+
- [ ] Single-column layout at <1040px
- [ ] Mobile layout at <640px
- [ ] Reading progress bar fills on scroll
- [ ] Reading time displays correctly

**Social/OG:**
- [ ] Facebook Sharing Debugger validates OG tags
- [ ] Twitter Card Validator shows large image preview
- [ ] Image loads correctly (1200×630px)

**Functionality:**
- [ ] Mobile sidebar toggle works
- [ ] Back links work
- [ ] Custom cursor (if applicable) works on new pages
- [ ] Print styles hide decorative elements

**Cross-browser:**
- [ ] Chrome/Edge
- [ ] Firefox
- [ ] Safari
- [ ] Mobile Safari

## Testing Approach

- **Manual QA**: Visual inspection, interaction testing
- **OG Validation**: Facebook Sharing Debugger, Twitter Card Validator
- **Performance**: Lighthouse audit (should score well with no particles)
- **Accessibility**: Keyboard navigation, color contrast
- **Responsive**: Chrome DevTools device simulation

## Files to Read Before Implementation

1. `index.html` — Study:
   - `:root` token definitions (reuse exactly)
   - Color palette (`--bg`, `--surface`, `--text-primary`, `--accent`)
   - Noise/vignette implementation (adapt for articles)

2. `.claude/fw-artifacts/brainstorm-publishing-section-2026-04-16.md` — Reference:
   - Original decisions
   - Feature requirements

3. `.claude/fw-artifacts/publishing-section-2026-04-16/architecture.md` — Reference:
   - Revised architecture decisions
   - Sidebar approach
   - Breakpoint rationale

## Publishing Workflow (Per Article)

1. Copy `template.html` to `writing/{slug}.html`
2. Fill in:
   - `<title>`
   - OG tags (`og:title`, `og:description`, etc.)
   - Article title in `<h1>`
   - Publication date in `<time>`
   - Article body in `.writing-article-content`
3. Update sidebar snippet:
   - Copy from `writing/index.html`
   - Mark current article with `writing-sidebar__item--current`
4. Add article to `writing/index.html` list
5. Commit and push

**Time per article:** ~3-5 minutes (mostly content formatting)

## Rollback Strategy

If issues arise:
1. Delete `/writing/` directory
2. Remove homepage link and CSS
3. Revert AGENTS.md constraint revision
4. Push — GitHub Pages updates automatically

## Acceptance Criteria

- [ ] `/writing/index.html` displays article list
- [ ] `/writing/template.html` can be copied to create articles
- [ ] Article pages show reading progress bar
- [ ] Article pages show accurate reading time
- [ ] OG tags work with rich image preview (tested)
- [ ] Homepage has visible "Articles" link
- [ ] Two-column layout at 1040px+, single-column below
- [ ] Clean reading experience (no particles)
- [ ] Source Serif 4 renders correctly
- [ ] Mobile navigation works
- [ ] Publishing workflow takes <5 min per article
