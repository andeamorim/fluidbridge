# Handoff: publish the FluidBridge site at surround.services/fluidbridge

For the agent that maintains the **surround.services** site (repo `andeamorim/surround-services`, Next.js on Vercel).
Written by the agent of the FluidBridge project (repo `andeamorim/kinetic-inride-bridge`). The owner relays updates.

## What FluidBridge is

FluidBridge for Kinetic inRide is an Android app by the Surround studio: it turns the Kinetic inRide fluid-trainer
sensor into a standard Bluetooth power meter for cycling apps and records indoor rides. It is about to launch on
Google Play (14-day free trial, then a one-time US$ 5.99).

## Goal

Serve the FluidBridge site, **unchanged**, at:

| URL | File |
|---|---|
| `https://www.surround.services/fluidbridge` (and `/fluidbridge/`) | `index.html` (landing) |
| `https://www.surround.services/fluidbridge/manual.html` | user manual |
| `https://www.surround.services/fluidbridge/privacy.html` | **privacy policy: Google Play links to it, it must always load** |
| `https://www.surround.services/fluidbridge/assets/...` | CSS, images, SVG |

The site is plain static HTML + CSS (no JavaScript, no build). Every internal link and asset already uses absolute
paths under `/fluidbridge/` (for example `/fluidbridge/assets/style.css`), and canonical / Open Graph / JSON-LD URLs
already point to `https://www.surround.services/fluidbridge/`. Do not restyle or rewrite it: its look matches the app.

## Source of truth

The public repo **https://github.com/andeamorim/fluidbridge** (branch `main`) always holds the latest published files.
Copy them from there; do not edit them in surround-services (edits would be overwritten on the next update).

Files to copy into `public/fluidbridge/`: `index.html`, `manual.html`, `privacy.html`, `assets/**`.
Skip: `robots.txt`, `sitemap.xml` (see SEO below), `publish.sh`, `HANDOFF-surround-services.md`, `.nojekyll`.

Suggested script in surround-services (so updates are one command):

```bash
# scripts/sync-fluidbridge.sh
set -e
tmp=$(mktemp -d)
git clone --depth 1 https://github.com/andeamorim/fluidbridge.git "$tmp"
rm -rf public/fluidbridge
mkdir -p public/fluidbridge
cp -R "$tmp"/index.html "$tmp"/manual.html "$tmp"/privacy.html "$tmp"/assets public/fluidbridge/
rm -rf "$tmp"
```

## Next.js changes

1. **Rewrites** in `next.config.ts` so the folder URL serves the landing page:
   - `/fluidbridge` → `/fluidbridge/index.html`
   - `/fluidbridge/` → `/fluidbridge/index.html`
   (`manual.html`, `privacy.html` and `assets/...` are plain static files and load as is.)
2. **i18n / middleware** (`proxy.ts` and its matcher): exclude `/fluidbridge` and everything under it, so it is never
   redirected to a locale prefix (`/en/fluidbridge`, `/pt/...`) or otherwise rewritten.
3. Do not add the site's layout, header or footer around these pages: they are complete HTML documents.

## SEO

- Add these URLs to the surround.services sitemap (or its `app/sitemap.ts`):
  `/fluidbridge/`, `/fluidbridge/manual.html`, `/fluidbridge/privacy.html`.
- Make sure the root `robots.txt` does not block `/fluidbridge`.

## Portfolio entry (suggested)

Add FluidBridge to the studio's app list, linking to `/fluidbridge`:

- Name: **FluidBridge for Kinetic inRide**
- One line: "Turns the Kinetic inRide fluid-trainer sensor into a Bluetooth power meter for any cycling app, and records your indoor rides. Android."
- Icon: `/fluidbridge/assets/img/icon-256.png` (green square, dark lightning bolt)
- Status: "Coming soon on Google Play" (the Play link will come later)

## Check after deploying

All must answer 200 with the right page, with styles and images:

```bash
for p in fluidbridge fluidbridge/ fluidbridge/manual.html fluidbridge/privacy.html fluidbridge/assets/style.css fluidbridge/assets/img/trainer.svg; do
  printf "%s " "$p"; curl -s -o /dev/null -w "%{http_code}\n" "https://www.surround.services/$p"; done
```

Also open `/fluidbridge` on a phone: dark page, app icon at the top, phone screenshots load.

## Later updates

When the FluidBridge site changes, the owner will say so. Run the sync script, deploy, and run the check again.
