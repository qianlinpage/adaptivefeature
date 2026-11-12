# Adaptive Feature — Qian Lin & collaborators

An independent bilingual research website introducing adaptive feature learning, its statistical motivation, a small interactive sequence model, and four connected papers. This project is separate from the existing personal academic homepage.

Repository: [qianlinpage/adaptivefeature](https://github.com/qianlinpage/adaptivefeature).

GitHub Pages: [English](https://qianlinpage.github.io/adaptivefeature/) · [中文](https://qianlinpage.github.io/adaptivefeature/index.zh.html).

## Preview

Open `index.zh.html` for Chinese or `index.html` for English in a browser. Both pages work directly from disk, including the numerical illustration. Alternatively, serve the directory with any static HTTP server.

## Edit

- `data/content.json`: shared paper records and bilingual copy.
- `scripts/render.rb`: HTML template and layout.
- `assets/site.css`: responsive visual design.
- `assets/model.js`: numerical model, with no DOM dependency.
- `assets/site.js`: chart rendering and controls.
- `SOURCES.md`: source provenance, publication checks, and model scope.

After updating the content or template, regenerate both pages:

```sh
ruby scripts/render.rb
ruby scripts/check.rb
node tests/model.test.cjs
```

Ruby is needed only to regenerate or check the files. Node.js is needed only for numerical tests. Visitors and GitHub Pages need neither.

## GitHub Pages deployment

1. Upload this directory’s contents to `main` in `qianlinpage/adaptivefeature`. Keep both HTML files, `assets/`, and `.nojekyll` at the repository root.
2. In **Settings → Pages → Build and deployment**, choose **Deploy from a branch**, `main`, and **/(root)**, then save.
3. GitHub’s Pages deployment publishes the site at `https://qianlinpage.github.io/adaptivefeature/`.

Page and asset links are relative, so the same static files can also be hosted in another repository or opened locally.

## Interactive illustration

The six-coordinate example compares fixed-scale gradient flow with a diagonal factor model, using the same synthetic observations and explicit initialization. It uses deterministic noise, fourth-order Runge–Kutta integration, and MSE against the known target. It is a teaching illustration, not a reproduction of the research experiments. `tests/model.test.cjs` validates the scalar reduction against independently integrated factor equations.

All visual assets are original SVG/CSS. The site uses no cookies, tracking, remote fonts, or third-party runtime libraries. Contact information is displayed in obfuscated form.
