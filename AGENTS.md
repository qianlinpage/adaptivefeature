# Adaptive Feature website

This is a new, independent GitHub Pages website about Qian Lin and collaborators’ Adaptive Feature research. It is not part of `academic-homepage` or the TestWeb repository. Do not modify or deploy to those projects while working here.

## Content and languages

- Maintain English (`index.html`) and Chinese (`index.zh.html`) together. Apply changes to both languages and check every page, shared navigation, paper record, and link affected by an update.
- Edit shared content in `data/content.json` and layout in `scripts/render.rb`; run `ruby scripts/render.rb` to regenerate both pages. Commit generated HTML alongside its sources.
- Preserve author order, verified publication metadata, links, and the distinction between published papers and preprints. Check publisher or conference records before changing a paper’s status. Cite primary sources in the website and record verification in `SOURCES.md`.
- Merge versions of the same work; document former titles when relevant. The papers here are a selected research trajectory, not an exhaustive publication list.
- Clearly distinguish definitions, conditional theoretical findings, conjectures and teaching illustrations. Do not present the small interactive example as a reproduction of paper experiments or a proof about general neural networks.
- Keep the contact address in human-readable obfuscated form. Do not add raw addresses or `mailto:` links.

## Implementation and validation

- Keep the site buildless for visitors: committed HTML, local CSS and JavaScript, relative paths, and no required external fonts, scripts or analytics.
- The model in `assets/model.js` follows diagonal factor gradient flow. Learned feature weights are `a_j²`, not the full tangent scale `a_j² + β_j²`.
- Run `node tests/model.test.cjs` for numerical changes. Run `ruby scripts/check.rb` after any content, template or asset changes.
- Check both languages at desktop and mobile widths after layout or interaction changes. Verify sliders, alignment controls, reset, keyboard focus, readable chart data, and no horizontal overflow.
- Use a separate repository for publication. Do not replace an existing unrelated repository or change its Pages settings.

## Release

The repository is `qianlinpage/adaptivefeature`. GitHub Pages serves `main` at the repository root with `.nojekyll`. No build workflow, package install, API key or runtime service is required. See `README.md` for local preview and deployment.
