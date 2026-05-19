# ShopSmart™ — UX Brainrot Playground

This repository contains a single-file static UX playground: a deliberately "cringe"/meme-heavy mock e-commerce site used for experimentation and UX prototyping. It is intentionally chaotic and not meant for production.

Features
- Single static HTML app with CSS + vanilla JavaScript.
- Meme-heavy UI: meme flood, Meme Auth, spinning wheel, fake checkout flows, tsunami events, and prank sounds.
- Audio helpers and immediate playback fallback for aggressive UI sounds.
- Indian-themed trending banner, WhatsApp share helper, and sample India-centric products.
- Self-contained: no backend required; orders and state are in-memory.

Included files
- `index.html` — main site (copy of `shopsmart-ux-crimes.html`).
- `shopsmart-ux-crimes.html` — original file (kept for reference).
- `README.md` — this file.



```bash
git init
git add .
git commit -m "Add ShopSmart UX playground and README"
# Ensure branch name 'main' (adjust if your default is 'master')
git branch -M main
# Add remote (replace with SSH if you prefer)
git remote add origin https://github.com/devanshuK45/SHOPSMART.git
git push -u origin main
```

A) Deploy via Netlify website (quickest)
1. Push your code to GitHub (see commands above).
2. Go to https://app.netlify.com and log in.
3. Click "Add new site" → "Import from Git".
4. Choose GitHub, authorize Netlify if needed, and select `devanshuK45/SHOPSMART`.
5. For "Build settings":
   - Build command: (leave blank)
   - Publish directory: `/` (root) — Netlify will serve `index.html`.
6. Click "Deploy site" and wait — your site will be live at a Netlify subdomain.

B) Deploy via Netlify CLI (more control)
1. Install Netlify CLI:

```bash
npm install -g netlify-cli
```

2. Login and initialize/deploy:

```bash
netlify login
# In the project folder
cd "c:/Users/devan/OneDrive/Desktop/LOL"
# Create a new site or link to an existing one
netlify init
# For a quick production deploy
netlify deploy --prod --dir=.
```

- When prompted by `netlify init`, choose "Create & configure a new site" or link to an existing site.
- Use `--dir=.` so Netlify will use the repository root and serve `index.html`.

Notes & troubleshooting
- Netlify serves `index.html` by default. I copied your `shopsmart-ux-crimes.html` to `index.html` so the deploy works out-of-the-box.
- Browser audio autoplay policies often block playback without a user gesture. The site includes a sound-activation banner — instruct users to click it.
- If you want a custom domain, configure it in Netlify dashboard and set DNS records at your registrar.

Want me to:
- Create a `.gitignore` and add a simple `netlify.toml` for settings?
- Open a PR on your GitHub repo (I can prepare PR instructions)?
- Add a tiny CI or GitHub Actions file to auto-deploy on push?

If you want me to push directly, I can provide a small script you run that will set the remote and push for you. I can't push from this environment due to credential restrictions.