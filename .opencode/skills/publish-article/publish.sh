#!/bin/bash
#
# publish-article: Convert Markdown to HTML article and publish
# Usage: ./publish.sh <markdown-file> [slug]
#

set -e

MARKDOWN_FILE="$1"
CUSTOM_SLUG="$2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if file exists
if [ ! -f "$MARKDOWN_FILE" ]; then
    echo -e "${RED}Error: File not found: $MARKDOWN_FILE${NC}"
    exit 1
fi

# Get the repo root
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo '.')"
WRITING_DIR="$REPO_ROOT/writing"

# Ensure writing directory exists
if [ ! -d "$WRITING_DIR" ]; then
    echo -e "${RED}Error: writing/ directory not found at $WRITING_DIR${NC}"
    exit 1
fi

# Read markdown content
CONTENT=$(cat "$MARKDOWN_FILE")

# Extract title (first # line or frontmatter)
TITLE=$(echo "$CONTENT" | grep -m 1 '^# ' | sed 's/^# //' || echo "")
if [ -z "$TITLE" ]; then
    TITLE=$(echo "$CONTENT" | grep -A1 '^---$' | grep '^title:' | sed 's/title: *//; s/^["'"'"']*//; s/["'"'"']*$//' || echo "")
fi

if [ -z "$TITLE" ]; then
    echo -e "${RED}Error: No title found. Add an H1 (# Title) or frontmatter title.${NC}"
    exit 1
fi

# Generate slug
if [ -n "$CUSTOM_SLUG" ]; then
    SLUG="$CUSTOM_SLUG"
else
    # Try filename first
    SLUG=$(basename "$MARKDOWN_FILE" .md)
    # If title is better (not just filename), use kebab-case of title
    if [ "$SLUG" = "$(basename "$MARKDOWN_FILE")" ] || [ -f "$WRITING_DIR/$SLUG.html" ]; then
        SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//;s/-$//' | cut -c1-50)
    fi
fi

# Check if slug is valid
if [ -z "$SLUG" ]; then
    echo -e "${RED}Error: Could not generate valid slug${NC}"
    exit 1
fi

# Check if article already exists
if [ -f "$WRITING_DIR/$SLUG.html" ]; then
    echo -e "${YELLOW}Warning: Article already exists: $WRITING_DIR/$SLUG.html${NC}"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Extract date (frontmatter or file modification time)
DATE_ISO=$(echo "$CONTENT" | grep -A3 '^---$' | grep '^date:' | sed 's/date: *//' || echo "")
if [ -z "$DATE_ISO" ]; then
    DATE_ISO=$(date -r "$MARKDOWN_FILE" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)
fi
DATE_READABLE=$(date -d "$DATE_ISO" +"%b %d, %Y" 2>/dev/null || echo "$DATE_ISO")

# Calculate reading time
WORD_COUNT=$(echo "$CONTENT" | wc -w)
READING_TIME=$(( (WORD_COUNT + 199) / 200 )) # Round up
if [ $READING_TIME -lt 1 ]; then
    READING_TIME=1
fi

# Extract description (frontmatter, first paragraph, or generated)
DESCRIPTION=$(echo "$CONTENT" | grep -A1 '^---$' | grep '^description:' | sed 's/description: *//; s/^["'"'"']*//; s/["'"'"']*$//' || echo "")
if [ -z "$DESCRIPTION" ]; then
    # Get first paragraph (non-empty line that's not a header)
    DESCRIPTION=$(echo "$CONTENT" | grep -v '^#' | grep -v '^---' | grep -v '^$' | head -1 | sed 's/\[\([^]]*\)\]([^)]*)/\1/g' | sed 's/[*_]//g')
    # Truncate to 150 chars
    if [ ${#DESCRIPTION} -gt 150 ]; then
        DESCRIPTION="${DESCRIPTION:0:147}..."
    fi
fi

echo "Publishing: $TITLE"
echo "Slug: $SLUG"
echo "Date: $DATE_READABLE"
echo "Reading time: $READING_TIME min"
echo "Word count: $WORD_COUNT"
echo ""

# TODO: Convert Markdown to HTML and apply template
# This would require a more sophisticated markdown parser
# For now, output the extracted info
echo -e "${GREEN}Article metadata extracted successfully${NC}"
echo "Next: Convert markdown content to HTML and apply template"

exit 0
