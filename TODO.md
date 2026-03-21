# TODO — yogicapproach/events

Structured task list. This file tracks issues and priorities.
See `PROGRESS.md` for completed work and `PENDING-TASK.md` for in-progress session plan.

---

## Open Issues

| # | Title | Notes |
|---|-------|-------|
| #3 | Research: audio diarization and isolation of bilingual talks | Backlog |
| #4 | Add floating toolbar on text selection with Web Share API for mobile | Backlog |
| #5 | Site audit: comprehensive HTML/JS/CSS review | Eleventy-era audit needed |
| #6 | Research: static site framework evaluation (Eleventy) | Research done; Eleventy shipped — may be closeable |
| #7 | Regression test checklist for audit-fixes branch | Keep open |
| #9 | Migrate from npm to Bun | Backlog |
| #10 | Auto-approve read-only Claude Code operations in VS Code | Settings task |
| #12 | SEO: add sitemap.xml, robots.txt, and hreflang tags | Not started |
| #13 | LLM/agentic discoverability: llms.txt, JSON-LD, crawler permissions | Not started |
| #15 | Add voice-enabled AI Q&A over talk corpus (Cloudflare Workers AI + RAG) | Depends on #14 (done) |
| #21 | Search: integrate search bar into page header (per-lang, browser-lang aware) | Search page exists; header integration pending |

---

## Backlog (not yet issues)

- Glossary: add link-out pages for lineage figures (Swami Niranjanananda, Swami Satyananda, etc.)
- Glossary: continue expanding as new talks are processed
- Automated transcription pipeline: audio → Whisper → raw/ → transcript generation
- New talk intake: process any talks from Uruguay series not yet transcribed
- GoatCounter: add to Das Mahavidya repo (see memory)

---

## Workflow Reminders

- New talk → create `raw/FOLDER/source-meta.md` + event folder in `src/` → use `prompts/transcript-en.md` → user confirms → `prompts/transcript-es.md` → `prompts/transcript-ne.md` → update `events.json`, glossary, synthesis
- Every task gets a GH issue before work begins
- After NE transcript: check `title_ne` and `title_short_ne` in events.json are in Devanagari
- Build: `npm run build` → Eleventy + Pagefind → `_site/`; deployed via GitHub Actions on push to main
- Rollback point: `git checkout v1.0-stable`
