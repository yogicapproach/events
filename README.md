# yogicapproach/events

Eleventy-based static site for yoga talk transcripts — Uruguay 2026. This is the
first and most mature dev repo in the `yogicapproach` multi-repo website. It
establishes the conventions all sibling repos should follow.

---

## Multi-repo website architecture

`yogicapproach.com` is served from a single public repo (`yogicapproach/yogicapproach.github.io`).
Each content section lives in its own private dev repo and pushes its built output
into a non-overlapping subtree of the public repo.

```
yogicapproach.github.io/          ← public serving repo (GitHub Pages)
  en/                             ← shared lang directories
  es/
  ne/
    events/2026-uruguay/...       ← pushed by yogicapproach/events
    retreats/2026-nepal/...       ← pushed by yogicapproach/retreats (future)
  assets/2026-uruguay/            ← static assets per project slug
  assets/2026-nepal/              ← (future)
  events/2026-uruguay/            ← language-detect redirect stubs
  CNAME                           ← owned by root repo — never touch
  index.html                      ← owned by root repo — never touch
  robots.txt                      ← owned by root repo — never touch
  sitemap.xml                     ← root sitemap index — owned by root repo
  llms.txt                        ← root llms index — owned by root repo
```

**Each dev repo owns:**
- `{lang}/events/{slug}/` — page content
- `assets/{slug}/` — CSS, JS, favicons, pagefind index, binary resources
- `events/{slug}/` — language-detect redirect stubs
- `events/sitemap.xml` — leaf sitemap (root repo's sitemap index points here)
- `events/llms.txt` — leaf llms file (root repo's llms.txt points here)

**Never write:**
- `CNAME` — deleting this breaks the custom domain instantly
- `index.html`, `robots.txt`, `/sitemap.xml` (root), `/llms.txt` (root)

---

## URL structure

All page URLs follow the pattern `/{lang}/{section}/{slug}/`.

| Page | URL |
|------|-----|
| Language-detect redirect | `/events/2026-uruguay/` → `/{lang}/events/2026-uruguay/` |
| Talk listing | `/{lang}/events/2026-uruguay/` |
| Talk page | `/{lang}/events/2026-uruguay/{folder}/` |
| Glossary | `/{lang}/events/2026-uruguay/glossary/` |
| Search | `/{lang}/events/2026-uruguay/search/` |
| Sitemap | `/events/sitemap.xml` |
| LLMs | `/events/llms.txt` |

Supported languages: `en` (English — original), `es` (Español — AI-translated),
`ne` (नेपाली — AI-translated). Spanish is the default fallback (Uruguay audience).

---

## Local development

```bash
npm install          # one-time
npm run serve        # dev server at http://localhost:8080 with live reload
npm run build        # full build including pagefind search index → _site/
npm run clean        # wipe _site/
```

`npm run serve` rebuilds on every file save. It does not re-run pagefind — search
won't work in dev mode. Run `npm run build` to verify search before deploying.

---

## Source structure

```
src/
  _data/
    events.js           # Reads docs/events/events.json — single source of truth
    talks_matrix.js     # Cross-product of langs × events for pagination
    site.json           # Site-wide config: baseUrl, langs, ogImage
  _includes/layouts/
    base.njk            # HTML shell: head meta, assets, topbar hook, footer
    listing.njk         # Extends base — talk listing page
  en/ es/ ne/
    index.njk           # /{lang}/events/2026-uruguay/ — talk listing
    glossary.njk        # /{lang}/events/2026-uruguay/glossary/
    search.njk          # /{lang}/events/2026-uruguay/search/
  talks.njk             # Pagination — generates 15 talk pages (5 talks × 3 langs)
  index.njk             # /events/2026-uruguay/ — language-detect redirect
  talk-redirects.njk    # /events/2026-uruguay/{folder}/ — per-talk redirects
  glossary-redirect.njk # /events/2026-uruguay/glossary/ redirect
  search.njk            # /events/2026-uruguay/search/ redirect
  sitemap.njk           # /events/sitemap.xml
  llms.njk              # /events/llms.txt
  assets/
    eleventy-extra.css  # Supplemental CSS for Eleventy-specific markup
static/
  404.html              # Smart 404 — pattern-matched redirect with lang detection
docs/
  events/
    events.json         # Master event data (single source of truth)
    {folder}/
      transcript-en.md  # Talk transcript (English — original)
      transcript-es.md  # Talk transcript (Spanish — AI-translated)
      transcript-ne.md  # Talk transcript (Nepali — AI-translated)
      resources.json    # Audio/PDF metadata for the resources panel
      resources/        # Binary files: audio, PDFs, images
  events/shared.css     # Runtime CSS (shared with legacy docs/ site)
  events/shared.js      # Runtime JS: topbar, loadResources(), GoatCounter
```

---

## Build output structure

```
_site/
  en/ es/ ne/
    events/2026-uruguay/
      index.html        # Talk listing
      {folder}/
        index.html      # Talk page
        resources.json  # Patched resource paths (absolute URLs)
      glossary/index.html
      search/index.html
  events/
    2026-uruguay/       # Language-detect redirect stubs
      index.html
      {folder}/index.html
      glossary/index.html
    sitemap.xml
    llms.txt
  assets/2026-uruguay/
    events/shared.css
    events/shared.js
    eleventy-extra.css
    favicon.ico / favicon.png / favicon.svg / apple-touch-icon.png
    {folder}/resources/  # Binary audio/PDF/image files
    pagefind/            # Search index (built by pagefind after eleventy)
  404.html
```

---

## Adding a new talk

1. Create `docs/events/{folder}/` — folder name pattern: `YYYYMMDD-slug`
2. Add `transcript-en.md`, `transcript-es.md`, `transcript-ne.md`
3. Add `resources.json` and `resources/` (audio, PDFs)
4. Add the event entry to `docs/events/events.json`
5. Run `npm run build` — all 3 talk pages generate automatically

---

## Assets

Static assets for this project live at `/assets/2026-uruguay/` in the public repo.
This keeps the root clean as more dev repos contribute sibling directories
(`/assets/2026-nepal/`, etc.).

The `pathPrefix` in `.eleventy.js` is `/` — all `| url` filter references in
templates are already root-relative absolute paths. No rewriting needed.

---

## Deployment

A GitHub Actions workflow (`workflow_dispatch`) builds `_site/` and pushes it
additively into `yogicapproach/yogicapproach.github.io`. See
`.github/workflows/deploy.yml` (Phase 2 of #63).

The sync is **additive only** — files from other repos are never deleted.
The workflow must never run `git rm -rf` or equivalent before copying.

The PAT secret for cross-repo push is stored as `DEPLOY_PAT` in this repo's
GitHub Actions secrets (`contents: write` on `yogicapproach.github.io`).

---

## Key Eleventy config decisions

- `pathPrefix: "/"` — output paths are root-relative; no subfolder prefix
- `siteRoot: ""` — legacy variable kept empty; templates use explicit paths
- `renderMarkdownFile` shortcode — rewrites `?lang=` links in markdown to
  directory-based URLs at build time; no runtime JS needed
- `eleventy.after` hook — writes patched `resources.json` to each
  `/{lang}/events/2026-uruguay/{folder}/` so `loadResources()` in shared.js
  resolves audio files correctly despite the lang-prefixed page URL

---

## Conventions for sibling repos

If you are setting up a new dev repo (retreats, talks, etc.) in this organization:

1. **URL pattern:** `/{lang}/{section}/{slug}/` — lang always first segment
2. **Assets:** `assets/{your-slug}/` — never write to `assets/2026-uruguay/`
3. **Sitemap:** `/{section}/sitemap.xml` — notify root repo owner to add it to
   the sitemap index at the root
4. **llms.txt:** `/{section}/llms.txt` — same; notify for root index update
5. **Never write** `CNAME`, `index.html`, `robots.txt`, `/sitemap.xml`, `/llms.txt`
6. **Additive sync only** — your deploy workflow must not wipe the public repo
7. **PAT secret** — store as `DEPLOY_PAT` in your repo's Actions secrets;
   the token needs `contents: write` on `yogicapproach.github.io`
