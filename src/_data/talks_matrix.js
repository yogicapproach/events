// Generates the cross-product of langs × events for Eleventy pagination.
// Each entry becomes one talk page: /[lang]/events/[folder]/
//
// Transcript HTML is NOT generated here — it is read at template render time
// via the renderMarkdownFile shortcode in talks.njk.

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

  const matrix = [];
  for (const lang of langs) {
    for (const event of events) {
      // Resolve path to the transcript markdown file
      const transcriptPath = path.join(
        __dirname, "..", "..", "docs", "events", event.folder,
        `transcript-${lang}.md`
      );
      const f = event.folder;
      const isoDate = `${f.slice(0,4)}-${f.slice(4,6)}-${f.slice(6,8)}`;
      matrix.push({ lang, event, transcriptPath, isoDate });
    }
  }
  return matrix;
};
