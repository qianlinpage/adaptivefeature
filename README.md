# Adaptive Feature — Qian Lin & collaborators

An independent bilingual research website centered on the Adaptive Feature program: abstract feature-map regression families; fixed, local and global dynamics; application to concrete neural networks; and feedback that refines the family’s assumptions. The guiding objective is to connect neural-network dynamics with generalization. The homepage separates the research perspective from the strategy that follows from it, with a dedicated illustration for each. Separate Research, Prototype and Papers pages hold the analytical views, network feedback, interactive sequence model and complete selected paper records. Each page has Chinese and English versions. This project is separate from the existing personal academic homepage.

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

The renderer appends a content-derived version to both stylesheet URLs. Re-render after CSS edits so that updated pages request the matching styles instead of reusing an earlier cached layout. The local link checker resolves query-bearing URLs against their file paths. Architecture diagrams use four columns above 760px and two columns at narrower widths.

## GitHub Pages deployment

1. Upload this directory’s contents to `main` in `qianlinpage/adaptivefeature`. Keep all eight HTML files, `assets/`, and `.nojekyll` at the repository root.
2. In **Settings → Pages → Build and deployment**, choose **Deploy from a branch**, `main`, and **/(root)**, then save.
3. GitHub’s Pages deployment publishes the site at `https://qianlinpage.github.io/adaptivefeature/`.

Page and asset links are relative, so the same static files can also be hosted in another repository or opened locally.

The homepage contact row links to the author's personal academic website on GitHub Pages: [English](https://qianlinpage.github.io/TestWeb/index.html) and [中文](https://qianlinpage.github.io/TestWeb/index.zh.html). Labels and destinations are stored in the bilingual content. The checker permits these two external homepage links while retaining the separation of local pages and assets from the personal website.

## Interactive illustration

The six-coordinate example compares fixed-scale gradient flow with a diagonal factor model, using the same synthetic observations and explicit initialization. It uses deterministic noise, fourth-order Runge–Kutta integration, and MSE against the known target. It is a teaching illustration, not a reproduction of the research experiments. `tests/model.test.cjs` validates the scalar reduction against independently integrated factor equations.

Visual assets include original SVG/CSS and locally stored AI-generated conceptual illustrations. The site uses no cookies, tracking, remote fonts, or third-party runtime libraries. Contact information is displayed in obfuscated form.

## Page structure

- `index.html` / `index.zh.html`: concise research goal, a Perspective section (`#perspective`) explaining neural networks as feature-map regression, a Strategy section (`#framework`) showing the complementary analytical views and feedback cycle, and a compact contact row. Shared navigation labels the homepage Overview / 总览. The repeated Explore the program / 进一步了解 section is retained in HTML comments; Research, Prototype and Papers remain accessible from the top navigation.
- `research.html` / `research.zh.html`: fixed, local and global analysis; feedback from networks; established tools and open questions. Links such as `research.zh.html#view-local` select the requested analytical view.
- `prototype.html` / `prototype.zh.html`: diagonal sequence-model teaching illustration, numerical controls, chart data, assumptions and limitations.
- `papers.html` / `papers.zh.html`: all selected papers with unchanged author order, status, publication details and source links.

The multi-page revision is deployed through GitHub Pages. Desktop/mobile visual QA and browser interaction checks remain pending because browser access is unavailable and native Computer Use permission was not granted. Structural and programmatic checks can be run with the commands above.

## Visual style

The site uses a warm ivory background, deep green headings, serif display typography, two numbered homepage sections, one pale strategy panel and a compact contact row. Desktop and mobile rules are included for all eight pages; browser visual QA remains pending.

## Research framework diagram

The Strategy section starts from the feature-map regression family introduced in Perspective. Its upper blocks use local SVGs to depict fixed feature regression, local state perturbations and a global feature-evolution trajectory. The lower block shows four representative architectures: fully connected networks, CNNs, ResNets and Transformers. The illustrations emphasize dense connections, feature-map stacks, residual shortcuts and attention with a feed-forward block. They illustrate the program's broad intended scope; they are not an exhaustive taxonomy or a claim of a universal theorem. Two researcher cartoons sit alongside the down/up application and feedback arrows, connecting the model family and concrete networks. Blocks link to the respective research sections. The arrangement and labels are bilingual, and the diagrams represent concepts rather than experimental results.

- Analytical-view assets: `assets/figures/view-static-v3.svg`, `view-local-v3.svg`, `view-global-v3.svg`.
- Each analytical-view card pairs its diagram with a compact native HTML formula: fixed-feature regression, a first-order local perturbation and the joint feature/readout trajectory. Shared math markup lives in `data/content.json` under `view_formulas`; labels, summaries and accessible math descriptions are bilingual. Narrow screens use compact rows with the formula spanning the card width. No external math-rendering library is required.
- Architecture assets: `assets/figures/network-mlp-v4.svg`, `network-cnn-v4.svg`, `network-resnet-v4.svg`, `network-transformer-v4.svg`. These are original local SVG schematics, arranged in four columns on desktop and two columns on mobile. The previous `neural-network-v3.svg` is preserved.
- Arrow characters: `assets/figures/research-arrow-characters-v3.png` (built-in image generation, preserved transparency).
- Prompt: `assets/figures/research-arrow-characters-v3.prompt.txt`.

Previous cartoon images remain preserved. Browser visual QA is still pending due to the unavailable browser connection.

The separate Perspective section uses a compact cartoon flow from a neural network to a family of feature maps, `𝓕 = {Φ_θ : θ ∈ Θ}`, with three differently warped meshes representing alternative maps. Varying hidden-layer parameters θ yields different full maps, rather than individual components of one map. The regression formula `f_{θ,β}(x) = ⟨Φ_θ(x), β⟩_H` and one sentence distinguish feature parameters θ from readout coefficients β. Neural networks provide an example of the broader abstract framework. The cartoon is a conceptual illustration, not experimental data.

Asset: `assets/figures/network-feature-family-v2.png` (built-in image generation, transparent background). Prompt: `assets/figures/network-feature-family-v2.prompt.txt`.
