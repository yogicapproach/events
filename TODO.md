# TODO — yogicapproach/events

Structured task list. This file tracks issues and priorities.
See `PROGRESS.md` for completed work and `PENDING-TASK.md` for in-progress session plan.

---

## Active — Remaining PR Merge Wave

| # | Branch | Title | Status |
|---|--------|-------|--------|
| #66 | design/ab-theme-flag | ?theme=v2 URL A/B behavior | Next |
| #57 | design/devanagari-font | Devanagari font load for NE pages | Pending |
| #58 | design/touch-targets | Audio player + PDF touch targets | Pending |
| #61 | design/font-size-tokens | Font size tokens + warm background | Pending |
| #67 | test/regression-wave-1 | Regression test suite (merge last) | Pending — merge after all others |

---

## Open Issues

| # | Title | Notes |
|---|-------|-------|
| #3 | Research: audio diarization and isolation of bilingual talks | Backlog |
| #4 | Add floating toolbar on text selection with Web Share API for mobile | Backlog |
| #5 | Site audit: comprehensive HTML/JS/CSS review | Eleventy-era audit needed |
| #6 | Research: static site framework evaluation (Eleventy) | Research done; Eleventy shipped — closeable |
| #9 | Migrate from npm to Bun | Backlog |
| #10 | Auto-approve read-only Claude Code operations in VS Code | Settings task |
| #15 | Add voice-enabled AI Q&A over talk corpus (Cloudflare Workers AI + RAG) | Backlog |
| #21 | Search: integrate search bar into page header (per-lang, browser-lang aware) | Search page exists; header integration pending |
| #52 | Choose proper site-wide OG image | Pending decision |
| #54 | Design review (parent) | Tracks #57–#62; close when all merged |
| #55 | Deep-dive: mobile UX, accessibility, web standards, A/B | Close when #57–#61 merged |
| #63 | URL architecture: move lang to root path `/en/events/...` | After all PRs merged |

---

## Backlog (not yet issues)

- Glossary: add link-out pages for lineage figures (Swami Niranjanananda, Swami Satyananda, etc.)
- Glossary: continue expanding as new talks are processed
- Automated transcription pipeline: audio → Whisper → raw/ → transcript generation
- New talk intake: process any talks from Uruguay series not yet transcribed
- GoatCounter: add to Das Mahavidya repo (see memory)
- shared.js dead code scan (broader — noted during #62 work)

---

## Workflow Reminders

- New talk → create `raw/FOLDER/source-meta.md` + event folder in `src/` → use `prompts/transcript-en.md` → user confirms → `prompts/transcript-es.md` → `prompts/transcript-ne.md` → update `events.json`, glossary, synthesis
- Every task gets a GH issue before work begins
- After NE transcript: check `title_ne` and `title_short_ne` in events.json are in Devanagari
- Build: `npm run build` → Eleventy + Pagefind → `_site/`; deployed via GitHub Actions on push to main
- Rollback point: `git checkout v1.0-stable`
- Squash merges: always use `--subject` flag to control commit message on main
