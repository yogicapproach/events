# Pending Task — yogicapproach/events

Written: 2026-03-23 — always updated on main only
Last commit on main: 7e42ea1

---

## Active Work

### Merge worktree branch chore/close-issue-54

**Status:** Agent completed. Awaiting user validation before merge.
**What the agent did:**
- Closed GH issue #54 with comment listing all 7 merged child PRs ✓
- Edited `TODO.md` and `PENDING-TASK.md` to remove "closeable" notes from #54 and #55
- Committed to branch `chore/close-issue-54` (commit `0b9c096`) in worktree `.claude/worktrees/close-54`

**Validate:** Check [issue #54](https://github.com/yogicapproach/events/issues/54) is closed, review the diff, then merge:
```
cd c:\Users\kaanchan\Projects\Yoga\yogicapproach\events
git merge chore/close-issue-54
git push
git worktree remove .claude/worktrees/close-54
git branch -d chore/close-issue-54
```

---

### Worktree isolation broken — wrong folder open in VS Code

**Problem:** VS Code was opened at `yogicapproach/` (not a git repo), so the Agent tool's built-in `isolation: "worktree"` fails. Agent had to create worktree manually.
**Fix:** Always open VS Code at `c:\Users\kaanchan\Projects\Yoga\yogicapproach\events` — the actual git repo root.
**Action:** Close this window, reopen at the `events/` folder. No code changes needed.

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
| #54 | Design review (parent) — CLOSED |
| #55 | Deep-dive: mobile UX, accessibility, web standards, A/B — CLOSED |
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

1. **Open VS Code at** `c:\Users\kaanchan\Projects\Yoga\yogicapproach\events` (the git repo root — not the parent folder)
2. Merge the waiting worktree branch (see Active Work above)
3. Then pick next real agent test with actual work (bash, file edits, etc.)
4. Then proceed to #73 (Cloudflare) — prerequisite for #63
5. PENDING-TASK.md is always on main — never edit it on a feature branch
