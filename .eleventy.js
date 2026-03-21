const markdownIt = require("markdown-it");
const path = require("path");
const fs = require("fs");

module.exports = function (eleventyConfig) {
  // ── Markdown renderer ────────────────────────────────────────────────────
  const md = markdownIt({
    html: true,       // allow raw HTML in markdown (needed for <a> tags in transcripts)
    linkify: true,
    typographer: false
  });
  eleventyConfig.setLibrary("md", md);

  // ── Passthrough copies ───────────────────────────────────────────────────
  // Copy shared assets from docs/ so _site/ has them at the expected paths.
  // The base layout references /2026-uruguay/events/shared.css etc. — Eleventy
  // serves _site/ from /, so these must live at _site/events/shared.css.
  //
  // Note: eleventyConfig.addPassthroughCopy({ src: dest }) maps src file/dir
  // to a destination path inside _site/.

  // All paths must be nested under 2026-uruguay/ in _site because GitHub Pages
  // serves this repo at https://yogic-approach.github.io/2026-uruguay/ and
  // all absolute asset references in HTML use /2026-uruguay/... paths.

  // shared.css → _site/2026-uruguay/events/shared.css
  eleventyConfig.addPassthroughCopy({
    "docs/events/shared.css": "2026-uruguay/events/shared.css"
  });
  // shared.js → _site/2026-uruguay/events/shared.js
  eleventyConfig.addPassthroughCopy({
    "docs/events/shared.js": "2026-uruguay/events/shared.js"
  });
  // favicons → _site/2026-uruguay/
  eleventyConfig.addPassthroughCopy({
    "docs/favicon.svg":          "2026-uruguay/favicon.svg",
    "docs/favicon.ico":          "2026-uruguay/favicon.ico",
    "docs/favicon.png":          "2026-uruguay/favicon.png",
    "docs/apple-touch-icon.png": "2026-uruguay/apple-touch-icon.png"
  });

  // Eleventy-specific supplemental CSS (lang-btn styles, etc.)
  eleventyConfig.addPassthroughCopy({
    "src/assets/eleventy-extra.css": "2026-uruguay/assets/eleventy-extra.css"
  });

  // Smart 404 page — must live at _site/404.html (repo root of the published
  // artifact) so GitHub Pages serves it for any unmatched path across the site.
  // pathPrefix would put Eleventy-generated pages under 2026-uruguay/, so we
  // use a passthrough copy from static/ to place this file at the artifact root.
  eleventyConfig.addPassthroughCopy({
    "static/404.html": "404.html"
  });

  // Per-event binary resources (audio, images, PDFs) → _site/2026-uruguay/events/[folder]/resources/
  // Using glob string form: Eleventy preserves the source path structure rooted at the project.
  // We handle this in eleventy.after below alongside resources.json copies.

  // resources.json — generate a patched version for each lang/event path at
  // build time. The patch rewrites relative file/cover paths to absolute URLs
  // so that shared.js loadResources() (which prepends 'resources/') still works
  // correctly even though the page URL is now /[lang]/events/[folder]/ rather
  // than /events/[folder]/.
  //
  // Strategy: we use eleventyConfig.on('eleventy.before') to write the patched
  // JSON files into _site/ before the build copies assets.
  const EVENTS_JSON_PATH = path.join(__dirname, "docs", "events", "events.json");
  const eventsForCopy = JSON.parse(fs.readFileSync(EVENTS_JSON_PATH, "utf-8"));
  const LANGS = ["en", "es", "ne"];

  // Write resources.json files for each lang × event after the build.
  //
  // The challenge: shared.js loadResources() fetches 'resources.json' (relative
  // URL) from the page URL /[lang]/events/[folder]/, but the binary resources
  // live at /2026-uruguay/events/[folder]/resources/.
  //
  // Fix: shared.js loadResources() now accepts an optional resourcesBasePath
  // parameter. talks.njk calls it as:
  //   loadResources(lang, "/2026-uruguay/events/{{ talkFolder }}/resources/")
  // which resolves file paths correctly regardless of page URL.
  //
  // resources.json is copied unchanged to each lang path (no rewriting needed).

  eleventyConfig.on("eleventy.after", async function ({ dir }) {
    for (const ev of eventsForCopy) {
      const srcPath = path.join(__dirname, "docs", "events", ev.folder, "resources.json");
      if (!fs.existsSync(srcPath)) continue;

      // Write resources.json to each lang path under 2026-uruguay/
      for (const lang of LANGS) {
        const destDir = path.join(dir.output, "2026-uruguay", lang, ev.folder);
        fs.mkdirSync(destDir, { recursive: true });
        fs.copyFileSync(srcPath, path.join(destDir, "resources.json"));
      }

      // Copy binary resources dir to 2026-uruguay/events/[folder]/resources/
      const srcResDir = path.join(__dirname, "docs", "events", ev.folder, "resources");
      if (fs.existsSync(srcResDir)) {
        const destResDir = path.join(dir.output, "2026-uruguay", ev.folder, "resources");
        fs.mkdirSync(destResDir, { recursive: true });
        for (const file of fs.readdirSync(srcResDir)) {
          fs.copyFileSync(path.join(srcResDir, file), path.join(destResDir, file));
        }
      }
    }
  });

  // ── Global data ──────────────────────────────────────────────────────────
  // src/_data/events.js and src/_data/site.json are loaded automatically.

  // ── Shortcodes ───────────────────────────────────────────────────────────

  // Render a markdown file to HTML at build time (used for transcripts,
  // synthesis, and glossary pages).
  // When lang is provided, rewrites legacy ?lang=XX links to directory-based paths.
  eleventyConfig.addShortcode("renderMarkdownFile", function (filePath, lang) {
    try {
      const content = fs.readFileSync(filePath, "utf-8");
      let html = md.render(content);
      if (lang) {
        html = html
          .replace(/href="events\/([\w-]+)\/\?lang=[a-z]+"/g,  `href="/2026-uruguay/${lang}/$1/"`)
          .replace(/href='events\/([\w-]+)\/\?lang=[a-z]+'/g,  `href="/2026-uruguay/${lang}/$1/"`)
          .replace(/href="(?:\.\.\/\.\.\/)?glossary\.html(?:\?lang=[a-z]+)?"/g, `href="/2026-uruguay/${lang}/glossary/"`)
          .replace(/href='(?:\.\.\/\.\.\/)?glossary\.html(?:\?lang=[a-z]+)?'/g, `href="/2026-uruguay/${lang}/glossary/"`);
      }
      return html;
    } catch (e) {
      return `<p class="error-message">Content not found: ${filePath}</p>`;
    }
  });

  // Bilingual event label — mirrors eventLabel() in shared.js
  eleventyConfig.addShortcode("eventLabel", function (event, lang) {
    const date  = lang === "ne" ? event.date_ne  : (lang === "es" ? event.date_es  : event.date);
    const title = lang === "ne" ? event.title_short_ne : (lang === "es" ? event.title_short_es : event.title_short);
    return `${date} \u2014 ${event.location} \u2014 ${title}`;
  });

  // ── Filters ──────────────────────────────────────────────────────────────

  // Return events list excluding the current talk folder
  eleventyConfig.addFilter("excludeFolder", function (events, folder) {
    return events.filter(e => e.folder !== folder);
  });

  // Resolve absolute path to a transcript markdown file
  eleventyConfig.addFilter("transcriptPath", function (folder, lang) {
    return path.join(__dirname, "docs", "events", folder, `transcript-${lang}.md`);
  });

  // Resolve absolute path to a synthesis markdown file
  eleventyConfig.addFilter("synthesisPath", function (lang) {
    return path.join(__dirname, "docs", `synthesis-${lang}.md`);
  });

  // Resolve absolute path to a glossary markdown file
  eleventyConfig.addFilter("glossaryPath", function (lang) {
    return path.join(__dirname, "docs", `glossary-${lang}.md`);
  });

  // ── Directory config ─────────────────────────────────────────────────────
  return {
    dir: {
      input:    "src",
      output:   "_site",
      includes: "_includes",
      data:     "_data"
    },
    templateFormats: ["njk", "html", "md"],
    markdownTemplateEngine: "njk",
    htmlTemplateEngine:     "njk"
    // pathPrefix intentionally omitted: all permalinks already hardcode /2026-uruguay/
    // so Eleventy's pathPrefix remapping would conflict with the dev server's file lookup.
  };
};
