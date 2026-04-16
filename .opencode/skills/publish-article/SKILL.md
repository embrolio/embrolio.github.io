# Skill: Publish Article

Convert a Markdown draft into a published HTML article on brolio.dev

## Overview

This skill automates the process of converting a Markdown article draft into a production-ready HTML file for the brolio.dev publishing section. It handles:

- Converting Markdown to semantic HTML
- Calculating reading time (200 WPM)
- Extracting/generating meta information (title, description, date)
- Applying the article template with proper OG tags
- Updating the article index (writing/index.html)
- Staging changes for commit

## When to Use

Use this skill when you have a Markdown article draft ready to publish, typically:
- After editing an article in your drafts folder
- When you want to publish a new blog post
- When converting existing Markdown content to the site format

## Usage

```
Use skill "publish-article" with:
- markdown_file: "path/to/your-article.md"
- slug: "your-article-slug" (optional, auto-generated from filename or title)
```

Or invoke via command:
```
/publish-article path/to/article.md
```

## Required Input

**markdown_file** (string, required): Absolute or relative path to the Markdown file to publish.

**slug** (string, optional): URL-friendly slug for the article. If omitted, generated from:
1. The filename (without .md extension)
2. Or the article title (converted to kebab-case)

## Article Markdown Format

Your Markdown file should follow this structure:

```markdown
# Article Title (H1 - used as page title)

Article body content in Markdown format.

## Section Headers (H2)

Content with **bold**, *italic*, and [links](url).

### Subsections (H3)

- List items
- More items

Code blocks:
```
code here
```

> Blockquotes work too.
```

**Optional frontmatter** (if provided, will override auto-detection):
```markdown
---
title: "Custom Title"  # Overrides H1
date: "2026-04-20"      # Overrides file modification date
description: "Custom excerpt for OG tags"  # Overrides auto-excerpt
---
```

## Workflow

### Step 1: Read and Parse Markdown

1. Read the Markdown file from the provided path
2. Check for YAML frontmatter (optional)
3. Extract:
   - Title (from frontmatter or first H1)
   - Date (from frontmatter or file modification time)
   - Content body (everything after title)
   - Description (from frontmatter or first paragraph)

### Step 2: Convert to HTML

Convert Markdown to HTML using these rules:

| Markdown | HTML Output |
|----------|-------------|
| `# Title` | `<h1>Title</h1>` |
| `## Section` | `<h2>Section</h2>` |
| `### Subsection` | `<h3>Subsection</h3>` |
| `**bold**` | `<strong>bold</strong>` |
| `*italic*` | `<em>italic</em>` |
| `` `code` `` | `<code>code</code>` |
| ```` ```code``` ```` | `<pre><code>...</code></pre>` |
| `- item` | `<ul><li>item</li></ul>` |
| `1. item` | `<ol><li>item</li></ol>` |
| `[text](url)` | `<a href="url">text</a>` |
| `> quote` | `<blockquote>quote</blockquote>` |
| `---` | `<hr>` |

**Code blocks**: Wrap in `<pre><code>...</code></pre>` with language class if specified (e.g., ` ```javascript ` → `<code class="language-javascript">`)

### Step 3: Calculate Reading Time

```javascript
function calculateReadingTime(text) {
  const words = text.trim().split(/\s+/).length;
  const minutes = Math.ceil(words / 200); // 200 WPM
  return minutes;
}
```

### Step 4: Generate HTML Article

Read the template file: `writing/template.html`

Replace placeholders in template:

| Placeholder | Value |
|-------------|-------|
| `{title}` | Article title |
| `{slug}` | URL slug |
| `{date_iso}` | ISO date (2026-04-16) |
| `{date_readable}` | Human date (Apr 16, 2026) |
| `{reading_time}` | Calculated minutes |
| `{description}` | Article excerpt for OG tags |
| `{content}` | Converted HTML body |
| `{og_image}` | https://brolio.dev/writing/og-image.png |

**Output file**: `writing/{slug}.html`

### Step 5: Update Article Index

Read `writing/index.html` and add the new article to:

1. **Archive list** (`.writing-archive__list`):
   ```html
   <li class="writing-archive__item">
     <article>
       <h2><a href="/writing/{slug}.html">{title}</a></h2>
       <div class="writing-archive__meta">
         <time datetime="{date_iso}">{date_readable}</time>
         <span class="reading-time">{reading_time} min read</span>
       </div>
       <p class="writing-archive__excerpt">{description}</p>
     </article>
   </li>
   ```
   Add as the **first item** (newest first).

2. **Sidebar list** (`.writing-sidebar__list`):
   ```html
   <li class="writing-sidebar__item">
     <a href="/writing/{slug}.html">{title}</a>
     <time>{date_readable}</time>
   </li>
   ```

### Step 6: Update Sidebar in Other Articles

For each existing article HTML file in `writing/` (except index.html):

1. Read the article file
2. Find `.writing-sidebar__list`
3. Replace its contents with the updated sidebar list (copied from index.html)
4. Mark current article with `writing-sidebar__item--current` class
5. Write back the file

### Step 7: Stage Changes

```bash
git add writing/
```

### Step 8: Output Summary

Display:
- Article title
- Published URL: `https://brolio.dev/writing/{slug}.html`
- Reading time
- Word count
- Files modified

## Template Reference

The article template (`writing/template.html`) structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Meta tags, OG tags, fonts, styles -->
</head>
<body>
  <div class="reading-progress"></div>
  <div class="noise-bg"></div>
  <div class="vignette"></div>
  
  <div class="writing-layout">
    <main class="writing-main">
      <article data-reading-time>
        <header class="writing-article-header">
          <h1>{title}</h1>
          <div class="writing-meta">
            <time datetime="{date_iso}">{date_readable}</time>
            <span class="reading-time">{reading_time} min read</span>
          </div>
        </header>
        
        <div class="writing-article-content">
          {content}
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
          <!-- Sidebar items -->
        </ul>
      </nav>
    </aside>
  </div>
  
  <script src="writing.js" defer></script>
</body>
</html>
```

## Examples

### Example 1: Basic Usage

Input file `/mnt/c/Users/maria/Drafts/my-new-article.md`:
```markdown
# Building Better Tools

I've been thinking about developer productivity...

## The Problem

Current tools are too complex.
```

Command:
```
/publish-article /mnt/c/Users/maria/Drafts/my-new-article.md
```

Result:
- Creates `writing/building-better-tools.html`
- Updates `writing/index.html` with new article
- Adds to sidebar in all articles
- Reading time: 3 min read

### Example 2: With Custom Slug

```
/publish-article /path/to/article.md --slug productivity-manifesto
```

Result: Article published at `/writing/productivity-manifesto.html`

### Example 3: With Frontmatter

Input file:
```markdown
---
title: "Why I Switched to Static Sites"
date: "2026-05-01"
description: "After ten years with CMS hell, I went back to basics."
---

# The CMS Trap

I spent a decade fighting WordPress...
```

Command:
```
/publish-article /path/to/article.md
```

Result:
- Title: "Why I Switched to Static Sites" (from frontmatter, not H1)
- Date: May 1, 2026
- OG description: "After ten years with CMS hell..."

## Conventions

### Slug Format
- Lowercase
- Alphanumeric and hyphens only
- No leading/trailing hyphens
- Max 50 characters

Good: `solo-dev-cognitive-bridge`, `productivity-tips-2026`
Bad: `Solo Dev Post!!!`, `post--with--hyphens`

### Date Format
- ISO: `2026-04-16` (for datetime attribute)
- Readable: `Apr 16, 2026` (for display)

### Description/Excerpt
- Max 150 characters for OG description
- Taken from: frontmatter > first paragraph > auto-generated
- Should be compelling for social sharing

### Article Content
- Use semantic HTML (proper h1, h2, h3 hierarchy)
- Images should be in `/writing/images/` folder
- External links should open in new tab (add `target="_blank" rel="noopener"`)

## Error Handling

### File Not Found
If markdown_file path doesn't exist:
- Display: "Error: File not found at [path]"
- Exit without making changes

### Missing Title
If no H1 found and no frontmatter title:
- Display: "Error: No title found. Add an H1 (# Title) or frontmatter title."
- Exit without making changes

### Invalid Slug
If generated slug is empty or invalid:
- Display: "Error: Could not generate valid slug from title."
- Suggest providing slug manually
- Exit without making changes

## Post-Publishing

After the skill completes:

1. Review the generated HTML file
2. Test locally by opening `writing/{slug}.html` in browser
3. Commit and push:
   ```bash
   git add writing/
   git commit -m "Add article: [title]"
   git push origin main
   ```
4. Wait for GitHub Pages deployment (~30 seconds)
5. Test live URL: `https://brolio.dev/writing/{slug}.html`

## See Also

- Article template: `writing/template.html`
- Article styles: `writing/styles.css`
- Article index: `writing/index.html`
- OG image: `writing/og-image.png`

---

**Note**: This skill modifies files in the `writing/` directory. Always review changes before committing.
