# Source and model notes

Last verified: 13 November 2026. Primary paper records and full texts were used for the research descriptions. This website is an introduction to selected work, not a complete bibliography.

## Paper records

| Work | Status used on site | Primary record |
| --- | --- | --- |
| Improving Adaptivity via Over-Parameterization in Sequence Models — Yicheng Li, Qian Lin | NeurIPS 2024, volume 37, pp. 52438–52480 | [Conference record](https://proceedings.neurips.cc/paper_files/paper/2024/hash/5df5b1f121c915d8bdd00db6aac20827-Abstract-Conference.html), [arXiv:2409.00894](https://arxiv.org/abs/2409.00894) |
| Diagonal Over-parameterization in Reproducing Kernel Hilbert Spaces as an Adaptive Feature Model: Generalization and Adaptivity — Yicheng Li, Qian Lin | Preprint, 2025 | [arXiv:2501.08679](https://arxiv.org/abs/2501.08679) |
| Supporting Evidence for the Adaptive Feature Program across Diverse Models — Yicheng Li, Qian Lin | Preprint, first posted 2025; v3 revised 7 April 2026 | [arXiv:2511.09425](https://arxiv.org/abs/2511.09425), [v3 full text](https://arxiv.org/html/2511.09425v3) |
| Alignment-Sensitive Minimax Rates for Spectral Algorithms with Learned Kernels — Dongming Huang, Zhifan Li, Yicheng Li, Qian Lin | ICML 2026, PMLR 306, pp. 46851–46928 | [PMLR record](https://proceedings.mlr.press/v306/huang26w.html), [arXiv:2509.20294](https://arxiv.org/abs/2509.20294) |

The earlier title “Several Supporting Evidences for the Adaptive Feature Program” refers to the same arXiv:2511.09425 work. It is represented by one current-title entry, not a separate paper.

The reading guide cites the specific [arXiv:2412.18756v2 survey](https://arxiv.org/abs/2412.18756v2), *Towards a Statistical Understanding of Neural Networks: Beyond the Neural Tangent Kernel Theories*. Its author order is Yicheng Li, Haobo Zhang, Jianfa Lai, Qian Lin, Jun S. Liu. This is a version-specific reference; the site does not infer journal metadata from another version.

Preprints remain labeled as preprints when no verified publisher record was found; this is not a claim that publication elsewhere is impossible.

## Research claims

- The [survey](https://arxiv.org/html/2412.18756v2) motivates jointly learning a feature map and output coefficients.
- The [sequence model paper, §3.1](https://arxiv.org/html/2409.00894v2) supplies the diagonal factor dynamics used for the teaching example. Its rate improvements depend on the stated signal, initialization and stopping conditions.
- The [RKHS paper](https://arxiv.org/html/2501.08679v1) extends diagonal feature adaptation to regression in function spaces. In this model the basis remains fixed while its scales are learned.
- The [FEM paper](https://arxiv.org/html/2511.09425v3) develops a feature error measure and supporting results for specified models. It does not establish a universal guarantee for all neural architectures or all empirical training dynamics.
- The [ESD paper](https://proceedings.mlr.press/v306/huang26w.html) connects target alignment and spectral order to statistical complexity and minimax risk.

## Numerical illustration

Six coordinates use initial feature weights `(1, .55, .25, .10, .04, .015)`. The target is `(1.1, .8, .4, 0, 0, 0)` when initially aligned or `(0, 0, .4, .8, 0, 1.1)` when initially misaligned. Observations add the selected noise amplitude times `(-.7, .4, -.8, .9, -.6, .5)`. No random draws or paper experiment results are used.

The fixed estimator is `θ_j(t) = (1 − exp(−λ_j t)) z_j`.

The adaptive factor equations are `a′ = β(z − aβ)` and `β′ = a(z − aβ)`, initialized at `a(0) = √λ`, `β(0) = 0`. The invariant `a² − β² = λ` gives the scalar reduction `θ′ = √(λ² + 4θ²)(z − θ)` for `θ = aβ`. The plotted learned feature weight is `a² = (λ + √(λ² + 4θ²))/2`.

Integration uses RK4 with step at most `.02`; the last step is adjusted to hit the selected time. “Coefficient MSE” means mean squared error over the six coordinates against the synthetic target. It is not a neural-network benchmark or a claim that the adaptive estimate always has lower error.

## Biography

Qian Lin’s title, affiliation and contact details are based on the [Tsinghua faculty profile in Chinese](https://www.stat.tsinghua.edu.cn/info/1023/2413.htm) and [English](https://www.stat.tsinghua.edu.cn/en/info/1023/1049.htm). The site credits collaborators in the paper entries. The email address is intentionally shown in human-readable obfuscated form.
