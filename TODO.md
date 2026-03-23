# TODO — yogicapproach/events

Structured task list. This file tracks issues and priorities.
See `PROGRESS.md` for completed work and `PENDING-TASK.md` for in-progress session plan.

---

## Active

| # | Title | Notes |
|---|-------|-------|
| — | settings.json/.gitignore decision | Commit `settings.json` publicly or keep `.claude/` gitignored? See PENDING-TASK.md |

---

## Open Issues (priority order)

| # | Title | Notes |
|---|-------|-------|
| **#73** | Cloudflare DNS/CDN migration | **Prerequisite for #63** — do first |
| **#63** | URL architecture: lang at root `/en/events/...` | Blocked on #73; pathPrefix constraint requires Cloudflare URL rewriting; plan in issue |
| **#70** | CI via GitHub Actions | Run tests on every push to main |
| **#75** | PageSpeed Insights audit | API-scriptable; all 8+ pages |
| **#68** | Translation QA — NE/ES AI peer review | Content quality |
| **#69** | Dark mode | prefers-color-scheme + toggle |
| **#66** | A/B theme flag (deferred) | Needs redesign (#64) first |
| **#74** | Domain registrar migration to Cloudflare | Research in yogicapproach-dev #1 |
| #3 | Audio diarization research | Backlog |
| #4 | Floating toolbar + Web Share API | Backlog |
| #5 | Site audit (Eleventy-era) | Backlog |
| #9 | npm → Bun | Backlog |
| #10 | Auto-approve read-only Claude Code ops | Settings task |
| #15 | Voice AI Q&A (Cloudflare Workers AI + RAG) | Backlog |
| #21 | Search bar in page header | Backlog |
| #52 | Site-wide OG image | Pending decision |
| #54 | Design review (parent) | **Closeable** — all child PRs merged |
| #55 | Deep-dive: mobile, accessibility, A/B | **Closeable** — all child PRs merged |
| #64 | A/B theme flag redesign | Backlog |

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
