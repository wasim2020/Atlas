# Conflict Atlas · أطلس النزاعات

A bilingual (Arabic / English), auto-updating interactive map of the world's active armed conflicts.

- `index.html` — the site (static, no build step).
- `data/conflicts.json` — all conflict data and news updates. Refreshed automatically by scheduled Claude tasks, which commit new versions to this repo.
- `data/world.json` — world map geometry (Natural Earth 1:50m via world-atlas).

The page re-reads `data/conflicts.json` every 5 minutes, so open pages pick up new commits without a reload.

Hosting: GitHub Pages (Settings → Pages → Deploy from branch → `main` / root).

## Visitor ratings & comments

Stored in a free Supabase project. Run `supabase/feedback.sql` once in the Supabase SQL Editor, then put the project URL and anon key in `config.js`. Comments are hidden until you tick `approved` in the Supabase Table Editor. Until `config.js` is filled in, the section shows "coming soon".
