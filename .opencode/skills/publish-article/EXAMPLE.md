# Example: Publishing Workflow

## Before You Start

1. Have your Markdown draft ready
2. Ensure it has a clear H1 title (# Title)
3. Review the first paragraph (it becomes the excerpt)

## Step-by-Step

### 1. Write Your Article

Create a Markdown file like:

```markdown
# My Article Title

This is the first paragraph that will become the excerpt for social sharing and the article index.

## Section One

Content here...

## Section Two

More content...
```

### 2. Publish Using the Skill

```
Use skill "publish-article" with:
- markdown_file: "/path/to/my-article.md"
- slug: "my-article-slug" (optional)
```

### 3. Review the Output

The skill will:
- Create `writing/my-article-slug.html`
- Update `writing/index.html` with your article
- Update sidebar in all existing articles
- Show you the reading time and word count

### 4. Test Locally

Open `writing/my-article-slug.html` in your browser:
```bash
# Using Python's simple server
python3 -m http.server 8000
# Then visit: http://localhost:8000/writing/my-article-slug.html
```

### 5. Commit and Deploy

```bash
git add writing/
git commit -m "Add article: My Article Title"
git push origin main
```

Wait ~30 seconds for GitHub Pages to deploy, then visit:
`https://brolio.dev/writing/my-article-slug.html`

## Markdown to HTML Conversion Reference

| You Write | You Get |
|-----------|---------|
| `# Title` | `<h1>Title</h1>` |
| `## Section` | `<h2>Section</h2>` |
| `**bold**` | `<strong>bold</strong>` |
| `*italic*` | `<em>italic</em>` |
| `` `code` `` | `<code>code</code>` |
| ````js\ncode\n```` | `<pre><code class="language-js">code</code></pre>` |
| `- item` | `<li>item</li>` |
| `> quote` | `<blockquote>quote</blockquote>` |
| `[text](url)` | `<a href="url">text</a>` |

## Tips

1. **Lead with your best paragraph** — It becomes the excerpt
2. **Use descriptive slugs** — Good for SEO and sharing
3. **Add images to `/writing/images/`** — Reference them with relative paths
4. **Preview OG tags** — Use Facebook's Sharing Debugger after publishing

## Troubleshooting

### "File not found"
- Check the path is correct
- Use absolute path if unsure

### "No title found"
- Ensure you have an H1: `# Your Title`
- Or add frontmatter: `---
title: "Your Title"
---`

### Article not showing on index
- Check `writing/index.html` was updated
- Hard refresh browser (Ctrl+Shift+R)

### OG image not showing on Twitter
- Wait 5-10 minutes after deploy for caching
- Use Twitter Card Validator to debug
- Ensure image is accessible at `https://brolio.dev/writing/og-image.png`
