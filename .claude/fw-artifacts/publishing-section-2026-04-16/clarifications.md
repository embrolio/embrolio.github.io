# Clarifications Log

**Workflow**: publishing-section-2026-04-16  
**Date**: 2026-04-16T16:50:00Z

---

## Question 1: Article layout preference
**Context**: The brainstorm suggested sidebar or bottom index for article navigation. Need to decide exact layout for responsive design.
**Question**: Single column with bottom index, or two-column with sidebar?
**Answer**: Two-column layout with sidebar on desktop, single-column adaptation for narrow/mobile screens
**Decision**: 
- Desktop (>900px): Fixed sidebar on right with article list, main content on left
- Mobile (<900px): Single column, sidebar becomes collapsible or bottom section
- Sidebar stays visible on scroll for easy navigation between articles

---

## Question 2: CSS organization strategy
**Context**: Need to decide how styles are distributed across article files.
**Question**: Shared stylesheet vs inline styles per article?
**Answer**: Shared stylesheet
**Decision**: 
- Create `/writing/styles.css` with all article-specific styles
- Each article links to this stylesheet + homepage fonts
- Maintain separation: article styles isolated from homepage styles
- Easier to update design across all articles by editing one file
- One additional HTTP request per article (acceptable)

---

## Decision Summary

| Topic | Decision | Rationale |
|-------|----------|-----------|
| Layout | Two-column responsive | Sidebar for navigation on desktop, clean single column on mobile |
| CSS Strategy | Shared stylesheet (`/writing/styles.css`) | Maintainability over self-containment |
| Font | Source Serif 4 | Already decided in brainstorm |
| URL Structure | `/writing/{slug}.html` | Already decided in brainstorm |
| OG Cards | Full Open Graph | Already decided in brainstorm |
