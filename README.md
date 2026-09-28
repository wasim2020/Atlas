# Conflict Atlas · أطلس النزاعات

A bilingual (Arabic / English), auto-updating interactive map of the world's active armed conflicts.

- `index.html` — the site (static, no build step).
- `data/conflicts.json` — all conflict data and news updates. Refreshed automatically by scheduled Claude tasks, which commit new versions to this repo.
- `data/world.json` — world map geometry (Natural Earth 1:50m via world-atlas).

The page re-reads `data/conflicts.json` every 5 minutes, so open pages pick up new commits without a reload.

Hosting: GitHub Pages (Settings → Pages → Deploy from branch → `main` / root).
