# YogicApproach Events — Uruguay 2026

Trilingual transcript archive for yoga talks delivered in Uruguay during February 2026 by Satchidananda. Published via GitHub Pages with a custom domain.

**Live site:** https://yogicapproach.com/events/2026-uruguay/en/

## Contents

The landing page presents an AI-generated synthesis of all five talks, exploring the koshas (five yogic bodies) as a framework for self-awareness and daily practice. The synthesis uses footnote-style citations linking back to the original transcripts.

**Five talks:**
- Feb 9 — Escuela de Yoga Satyam — *The Five Koshas: A Practical Framework for Wholeness*
- Feb 10 — Clínica Vitola, Yoga Carrasco — *Living Fully In Yourself*
- Feb 11 — MACA Museum — *The Levels of the Human Being According to Yoga and Their Dialogue with AI*
- Feb 18 — SitaRam Darshan, La Paloma — *Tantric Tools: Tantroktam Devi Suktam for Self-Reflection*
- Feb 23 — Piriápolis — *The Koshas: A Map of the Inner World*

All content is available in **English**, **Español**, and **नेपाली**.

## How It Works

- Built with [Eleventy](https://www.11ty.dev/) v3; source in `src/`, output to `_site/`
- Full-text search powered by [Pagefind](https://pagefind.app/) — indexed at build time
- Deployed automatically via GitHub Actions on push to `main`
- Language toggle switches between EN / ES / NE via URL path (`/en/`, `/es/`, `/ne/`)
- Talk selector and resources section driven by `docs/events/events.json` and `resources.json` per event

## Structure

```
src/
├── _data/
│   └── site.json               ← Global site config (baseUrl, langs, ogImage)
├── _includes/layouts/
│   ├── base.njk                ← HTML shell (head, nav, footer)
│   ├── talk.njk                ← Individual talk page
│   └── listing.njk             ← Events listing page
├── {en,es,ne}/
│   ├── index.njk               ← Synthesis landing page
│   ├── glossary/index.njk      ← Glossary
│   ├── events/index.njk        ← Events listing
│   └── search.njk              ← Pagefind search page
└── talks.njk                   ← Generates 15 talk pages (5 talks × 3 langs)

docs/
└── events/
    ├── events.json             ← Talk metadata (titles, dates, folders — all 3 langs)
    ├── shared.css              ← Site-wide stylesheet
    ├── shared.js               ← Runtime JS (language toggle, talk selector, resources)
    └── {event-folder}/
        ├── transcript-en.md
        ├── transcript-es.md
        ├── transcript-ne.md
        └── resources/          ← Audio, PDFs, cover art
```

## Adding a New Event

1. Create `docs/events/YYYYMMDD-topic-venue/` with `transcript-en.md`, `transcript-es.md`, `transcript-ne.md`
2. Add a `resources/` subfolder with any audio or PDF files and a `resources.json`
3. Add the event entry to `docs/events/events.json` (include `title`, `title_es`, `title_ne`, `folder`, etc.)
4. Update `docs/synthesis-{en,es,ne}.md` to include the new talk
5. Run `npm run build` to rebuild `_site/` and verify locally with `npm run serve`
6. Push to `main` — GitHub Actions builds and deploys automatically

## Development

```bash
npm install
npm run build      # Eleventy + Pagefind → _site/
npm run serve      # Dev server at http://localhost:8080
npm run test       # Run test suite
```
