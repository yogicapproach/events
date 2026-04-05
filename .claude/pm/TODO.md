# TODO — yogicapproach/events

Structured task list. This file tracks issues and priorities.
See `PROGRESS.md` for completed work and `PENDING-TASK.md` for in-progress session plan.

---

## Active

| # | Title | Notes |
|---|-------|-------|
| [#63](https://github.com/yogicapproach/events/issues/63) | URL architecture: lang at root | Approach agreed — see PENDING-TASK.md |

---

## Open Issues (priority order)

| # | Title | Priority | Notes |
|---|-------|----------|-------|
| [#63](https://github.com/yogicapproach/events/issues/63) | URL architecture: lang at root `/en/events/...` | High | Push static files to root repo; manual deploy via GH Environments |
| [#75](https://github.com/yogicapproach/events/issues/75) | PageSpeed Insights audit | Medium | API-scriptable; all 8+ pages |
| [#68](https://github.com/yogicapproach/events/issues/68) | Translation QA — NE/ES AI peer review | Medium | Content quality; needs scope decision |
| [#70](https://github.com/yogicapproach/events/issues/70) | CI via GitHub Actions | Medium | Run tests on every push to main |
| [#52](https://github.com/yogicapproach/events/issues/52) | Site-wide OG image | Low | Blocked — needs photo asset from Uruguay talks |
| [#64](https://github.com/yogicapproach/events/issues/64) | A/B theme flag redesign | Low | UX decision needed before #66 |
| [#66](https://github.com/yogicapproach/events/issues/66) | A/B theme flag PR | Low | Deferred until #64 |
| [#9](https://github.com/yogicapproach/events/issues/9) | npm → Bun | Low | Research + migration |
| [#21](https://github.com/yogicapproach/events/issues/21) | Search bar in page header | Low | Backlog |
| [#15](https://github.com/yogicapproach/events/issues/15) | Voice AI Q&A (Cloudflare Workers AI + RAG) | Low | Backlog |
| [#4](https://github.com/yogicapproach/events/issues/4) | Floating toolbar + Web Share API | Low | Backlog |
| [#3](https://github.com/yogicapproach/events/issues/3) | Audio diarization research | Low | Backlog |
| [#54](https://github.com/yogicapproach/events/issues/54) | Design review (parent) | Low | Backlog |
| [#55](https://github.com/yogicapproach/events/issues/55) | Deep-dive: mobile, accessibility, A/B | Low | Backlog |

---

## Backlog (no issue yet)

- [ ] Glossary: add link-out pages for lineage figures (Swami Niranjanananda, Swami Satyananda, etc.)
- [ ] Glossary: continue expanding as new talks are processed
- [ ] Automated transcription pipeline: audio → Whisper → raw/ → transcript generation
- [ ] New talk intake: process any talks from Uruguay series not yet transcribed
- [ ] GoatCounter: add to Das Mahavidya repo (see memory)
- [ ] shared.js dead code scan (broader — noted during #62 work)

---

## Workflow Reminders

- New talk → create `raw/FOLDER/source-meta.md` + event folder in `src/` → use `prompts/transcript-en.md` → user confirms → `prompts/transcript-es.md` → `prompts/transcript-ne.md` → update `events.json`, glossary, synthesis
- Every task gets a GH issue before work begins
- After NE transcript: check `title_ne` and `title_short_ne` in events.json are in Devanagari
- Build: `npm run build` → Eleventy + Pagefind → `_site/`; manual deploy via GitHub Actions workflow_dispatch → pushes to `yogicapproach.github.io`
- Rollback point: `git checkout v1.0-stable`
- Squash merges: always use `--subject` flag to control commit message on main
