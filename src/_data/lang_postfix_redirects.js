// Generates the list of old lang-postfix URL stubs that need permanent meta-refresh redirects.
// Old structure: /events/2026-uruguay/{lang}/{page}/
// New structure: /{lang}/events/2026-uruguay/{page}/
//
// These stubs are a backstop for when the Cloudflare 301 redirect rule is removed.
// Talk-level entries are derived from events.json so new talks are covered automatically.

const path = require("path");
const fs   = require("fs");

module.exports = function () {
  const langs  = ["en", "es", "ne"];
  const events = JSON.parse(
    fs.readFileSync(
      path.join(__dirname, "..", "..", "docs", "events", "events.json"),
      "utf-8"
    )
  );

  const subpages = ["", "glossary/", "search/"];
  const entries  = [];

  for (const lang of langs) {
    // Listing, glossary, search
    for (const page of subpages) {
      entries.push({ lang, page });
    }
    // One entry per talk
    for (const ev of events) {
      entries.push({ lang, page: ev.folder + "/" });
    }
  }

  return entries;
};
