# Adaptive Feature — Qian Lin & collaborators

An independent bilingual research website centered on the Adaptive Feature program: abstract feature-map regression families; fixed, local and global dynamics; application to concrete neural networks; and feedback that refines the family’s assumptions. The guiding objective is to connect neural-network dynamics with generalization. The homepage presents a concise research goal, two-level research framework and three plain-text page entrances. Separate Research, Prototype and Papers pages hold the analytical views, network feedback, interactive sequence model and complete selected paper records. Each page has Chinese and English versions. This project is separate from the existing personal academic homepage.

Repository: [qianlinpage/adaptivefeature](https://github.com/qianlinpage/adaptivefeature).

GitHub Pages: [English](https://qianlinpage.github.io/adaptivefeature/) · [中文](https://qianlinpage.github.io/adaptivefeature/index.zh.html).

## Preview

Open `index.zh.html` for Chinese or `index.html` for English in a browser. All eight pages work directly from disk, including the numerical illustration. The language switch keeps the current section. Alternatively, serve the directory with any static HTTP server.

## Edit

- `data/content.json`: shared paper records and bilingual copy.
- `scripts/render.rb`: HTML template and layout.
- `assets/site.css`: responsive visual design.
- `assets/model.js`: numerical model, with no DOM dependency.
- `assets/site.js`: chart rendering and controls.
- `assets/program.js`: accessible fixed/local/global tabs. All three descriptions remain readable without JavaScript.
- `SOURCES.md`: source provenance, publication checks, and model scope.

After updating the content or template, regenerate all eight pages:

```sh
ruby scripts/render.rb
ruby scripts/check.rb
node tests/model.test.cjs
node tests/program.test.cjs
```

Ruby is needed only to regenerate or check the files. Node.js is needed only for numerical tests. Visitors and GitHub Pages need neither.

## GitHub Pages deployment

1. Upload this directory’s contents to `main` in `qianlinpage/adaptivefeature`. Keep all eight HTML files, `assets/`, and `.nojekyll` at the repository root.
2. In **Settings → Pages → Build and deployment**, choose **Deploy from a branch**, `main`, and **/(root)**, then save.
3. GitHub’s Pages deployment publishes the site at `https://qianlinpage.github.io/adaptivefeature/`.

Page and asset links are relative, so the same static files can also be hosted in another repository or opened locally.

## Interactive illustration

The six-coordinate example compares fixed-scale gradient flow with a diagonal factor model, using the same synthetic observations and explicit initialization. It uses deterministic noise, fourth-order Runge–Kutta integration, and MSE against the known target. It is a teaching illustration, not a reproduction of the research experiments. `tests/model.test.cjs` validates the scalar reduction against independently integrated factor equations.

Visual assets include original SVG/CSS and locally stored AI-generated conceptual illustrations. The site uses no cookies, tracking, remote fonts, or third-party runtime libraries. Contact information is displayed in obfuscated form.

## Page structure

- `index.html` / `index.zh.html`: concise research goal, two-level research framework, a link to the full framework diagram, and three page entrances.
- `research.html` / `research.zh.html`: fixed, local and global analysis; feedback from networks; established tools and open questions. Links such as `research.zh.html#view-local` select the requested analytical view.
- `prototype.html` / `prototype.zh.html`: diagonal sequence-model teaching illustration, numerical controls, chart data, assumptions and limitations.
- `papers.html` / `papers.zh.html`: all selected papers with unchanged author order, status, publication details and source links.

The multi-page revision is deployed through GitHub Pages. Desktop/mobile visual QA and browser interaction checks remain pending because browser access is unavailable and native Computer Use permission was not granted. Structural and programmatic checks can be run with the commands above.

## Visual style

The site uses a warm ivory background, deep green headings, serif display typography, one pale strategy panel and three full-row links. Desktop and mobile rules are included for all eight pages; browser visual QA remains pending.

## Research framework diagram

The upper blocks use local SVGs to depict fixed feature regression, local state perturbations and a global feature-evolution trajectory. A layered neural-network SVG forms the lower block. Two researcher cartoons sit alongside the down/up application and feedback arrows, connecting the model family and concrete networks. Blocks link to the respective research sections. The arrangement and labels are bilingual, and the diagrams represent concepts rather than experimental results.

- Diagram assets: `assets/figures/view-static-v3.svg`, `view-local-v3.svg`, `view-global-v3.svg`, `neural-network-v3.svg`.
- Arrow characters: `assets/figures/research-arrow-characters-v3.png` (built-in image generation, preserved transparency).
- Prompt: `assets/figures/research-arrow-characters-v3.prompt.txt`.

Previous cartoon images remain preserved; the active pages use only the v3 assets. Browser visual QA is still pending due to the unavailable browser connection.

The model-family block explicitly defines `f_{Φ,β}(x) = ⟨Φ(x), β⟩_H`, with `Φ ∈ F` and `β ∈ H`. A native HTML/SVG flow depicts input, feature representation and scalar readout; bilingual definitions distinguish the candidate map family, feature vector and coefficients. This is a definition, not a theoretical performance claim.
