# Pending Task — yogicapproach/events

Written: 2026-03-23 — always updated on main only
Last commit on main: 1cfc099

---

## Active Work

### Settings.json — commit or keep gitignored?

**Context:** This session restructured `.claude/settings.json` (project permissions) and `~/.claude/settings.json` (global). Three worktree agent tests all passed cleanly. The `.gitignore` currently excludes the entire `.claude/` directory.

**Pending decision + action:**
- [ ] Decide: commit `settings.json` publicly, or keep the whole `.claude/` dir gitignored
  - Option A: Change `.gitignore` from `.claude/` to `.claude/settings.local.json` + `.claude/worktrees/` — exposes project permissions publicly (fine, no secrets in it)
  - Option B: Keep `.claude/` entirely gitignored — settings only live locally
- [ ] Once decided: commit the settings changes (currently uncommitted)

**Key facts:**
- `settings.json` contains only permission rules — no secrets
- `settings.local.json` is empty `{}` and must stay gitignored (machine-specific)
- Repo is public, so Option A means anyone can see the permission config

---

## Next Major Tasks (in rough priority order)

| # | Title | Notes |
|---|-------|-------|
| **#73** | Cloudflare DNS/CDN migration | **NOW PREREQUISITE for #63** — must do first |
| **#63** | URL architecture: lang at root `/en/events/...` | Blocked: pathPrefix constraint means Cloudflare URL rewriting needed first; plan posted to issue |
| **#70** | CI via GitHub Actions | Run test suite on every push to main |
| **#75** | PageSpeed Insights audit | API-scriptable; run against all 8+ pages |
| **#68** | Translation QA — NE/ES AI peer review | Content quality |
| **#69** | Dark mode | prefers-color-scheme + manual toggle |
| **#66** | A/B theme flag (deferred) | Needs UX redesign first (#64) |

---

## Other Open Issues

| # | Title |
|---|-------|
| #3 | Audio diarization research |
| #4 | Floating toolbar + Web Share API |
| #5 | Site audit (Eleventy-era) |
| #7 | Regression test checklist |
| #9 | npm → Bun |
| #10 | Auto-approve read-only Claude Code ops |
| #15 | Voice AI Q&A (Cloudflare Workers) |
| #21 | Search bar in page header |
| #52 | Choose proper site-wide OG image |
| #54 | Design review (parent) |
| #55 | Deep-dive: mobile UX, accessibility, web standards, A/B |
| #64 | A/B theme flag redesign (live toggle) |
| #66 | A/B theme flag PR (deferred) |
| #68 | Translation QA — NE/ES AI peer review + native speaker |
| #69 | Dark mode support |
| #70 | CI via GitHub Actions |
| #73 | Cloudflare DNS/CDN migration for yogicapproach.com |
| #74 | Domain registration migration to Cloudflare Registrar (see yogicapproach-dev #1) |
| #75 | PageSpeed Insights audit |

**Private repo:** `yogicapproach/yogicapproach-dev` — sensitive planning (domain portfolio, cost analysis)

---

## Resume Instructions

1. `cd c:\Users\kaanchan\Projects\Yoga\yogicapproach\events`
2. Answer the settings.json/.gitignore question above → commit settings
3. Then proceed to #73 (Cloudflare) — prerequisite for #63
4. PENDING-TASK.md is always on main — never edit it on a feature branch
