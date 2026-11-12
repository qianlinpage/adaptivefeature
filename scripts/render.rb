#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'
require 'cgi'

root = File.expand_path('..', __dir__)
data = JSON.parse(File.read(File.join(root, 'data/content.json')))
escape = ->(value) { CGI.escapeHTML(value.to_s) }

%w[en zh].each do |lang|
  c = data.fetch(lang)
  zh = lang == 'zh'
  file = zh ? 'index.zh.html' : 'index.html'
  nav = %w[idea playground research about].zip(c['nav']).map { |id, text| "<a href=\"##{id}\">#{escape.call(text)}</a>" }.join
  concepts = c['concepts'].each_with_index.map do |(title, body), index|
    "<article class=\"concept\"><span class=\"concept-number\">0#{index + 1}</span><h3>#{escape.call(title)}</h3><p>#{escape.call(body)}</p></article>"
  end.join("\n")
  papers = data['papers'].map do |paper|
    arxiv = paper['arxiv'] ? "<a href=\"#{paper['arxiv']}\">arXiv ↗</a>" : ''
    <<~HTML
      <article class="paper" id="paper-#{paper['id']}">
        <div class="paper-year">#{escape.call(paper['year'])}</div>
        <div class="paper-body">
          <div class="paper-topline"><span>#{escape.call(paper['tag'][lang])}</span><span class="status #{paper['status']['en'].start_with?('Preprint') ? 'preprint' : ''}">#{escape.call(paper['status'][lang])}</span></div>
          <h3><a href="#{paper['url']}">#{escape.call(paper['title'])}</a></h3>
          <p class="authors">#{escape.call(paper['authors'])}</p>
          <p>#{escape.call(paper['summary'][lang])}</p>
          <div class="paper-bottom"><span>#{escape.call(paper['venue'])}</span><div><a href="#{paper['url']}">#{c['read']} ↗</a> #{arxiv}</div></div>
        </div>
      </article>
    HTML
  end.join("\n")

  html = <<~HTML
    <!DOCTYPE html>
    <html lang="#{zh ? 'zh-CN' : 'en'}">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>#{escape.call(c['title'])}</title>
      <meta name="description" content="#{escape.call(c['description'])}">
      <meta name="theme-color" content="#143e38">
      <meta property="og:title" content="#{escape.call(c['title'])}">
      <meta property="og:description" content="#{escape.call(c['description'])}">
      <meta property="og:type" content="website">
      <link rel="icon" href="assets/favicon.svg" type="image/svg+xml">
      <link rel="stylesheet" href="assets/site.css">
      <link rel="alternate" hreflang="en" href="index.html">
      <link rel="alternate" hreflang="zh-CN" href="index.zh.html">
      <script src="assets/model.js" defer></script>
      <script src="assets/site.js" defer></script>
    </head>
    <body id="top">
      <a class="skip-link" href="#main">#{c['skip']}</a>
      <header class="site-header">
        <div class="header-inner wrap">
          <a class="brand" href="#{file}" aria-label="Adaptive Feature"><img src="assets/favicon.svg" width="34" height="34" alt=""><span>Adaptive<span class="brand-light">Feature</span></span></a>
          <nav aria-label="#{zh ? '主导航' : 'Main navigation'}">#{nav}</nav>
          <div class="languages" aria-label="Language / 语言"><a href="index.zh.html" lang="zh-CN" hreflang="zh-CN"#{zh ? ' aria-current="page"' : ''}>中文</a><a href="index.html" lang="en" hreflang="en"#{zh ? '' : ' aria-current="page"'}>EN</a></div>
        </div>
      </header>
      <main id="main">
        <section class="hero wrap" aria-labelledby="hero-title">
          <div class="hero-copy">
            <p class="eyebrow"><span class="tiny-dot"></span>#{c['eyebrow']}</p>
            <h1 id="hero-title">#{c['hero_title']}</h1>
            <p class="hero-intro">#{c['hero_intro']}</p>
            <p class="byline">#{c['byline']}</p>
            <div class="hero-actions"><a class="button primary" href="#idea">#{c['cta']} <span>↗</span></a><a class="text-link" href="#research">#{c['cta_secondary']} <span>↓</span></a></div>
          </div>
          <figure class="hero-visual">
            <div class="visual-label"><span>#{c['figure_label']}</span><span>Φ → Φ<sub>t</sub></span></div>
            <svg viewBox="0 0 520 320" aria-hidden="true" focusable="false">
              <defs><pattern id="grid" width="26" height="26" patternUnits="userSpaceOnUse"><circle cx="1" cy="1" r="1" fill="#143e38" opacity=".10"/></pattern><marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" fill="#548b7a"/></marker></defs>
              <rect x="0" y="0" width="520" height="320" fill="url(#grid)"/>
              <g fill="none" stroke="#abc4b6" stroke-width="1.5"><path d="M54 90C104 90 95 124 144 124M54 142C106 142 98 124 144 124M54 194C110 194 95 124 144 124M54 246C112 246 95 124 144 124"/><path d="M54 90C99 90 110 208 144 208M54 142C103 142 103 208 144 208M54 194C100 194 101 208 144 208M54 246C100 246 102 208 144 208"/></g>
              <g fill="#d48157" stroke="#f6f4e9" stroke-width="4"><circle cx="54" cy="90" r="9"/><circle cx="54" cy="142" r="9"/><circle cx="54" cy="194" r="9"/><circle cx="54" cy="246" r="9"/></g>
              <rect x="144" y="64" width="205" height="215" rx="18" fill="#fffef8" stroke="#a9c1ae"/>
              <text x="169" y="99" fill="#315f51" font-family="Georgia,serif" font-size="21">Φ<tspan baseline-shift="sub" font-size="13">η(t)</tspan></text>
              <g fill="#1a7565"><rect x="170" y="120" width="140" height="13" rx="6"/><rect x="170" y="146" width="66" height="13" rx="6" opacity=".45"/><rect x="170" y="172" width="110" height="13" rx="6" opacity=".7"/><rect x="170" y="198" width="40" height="13" rx="6" opacity=".3"/><rect x="170" y="224" width="153" height="13" rx="6"/></g>
              <path d="M349 170H404" fill="none" stroke="#548b7a" stroke-width="2" marker-end="url(#arrow)"/>
              <text x="378" y="155" text-anchor="middle" fill="#315f51" font-family="Georgia,serif" font-size="20">β<tspan baseline-shift="sub" font-size="12">t</tspan></text>
              <rect x="408" y="135" width="65" height="70" rx="16" fill="#143e38"/><text x="440" y="178" text-anchor="middle" fill="#f2f2df" font-family="Georgia,serif" font-size="21">f<tspan baseline-shift="sub" font-size="12">t</tspan><tspan baseline-shift="baseline">(x)</tspan></text>
              <path d="M378 131V35H248V60" fill="none" stroke="#548b7a" stroke-width="1.5" stroke-dasharray="5 5" marker-start="url(#arrow)" marker-end="url(#arrow)"/>
            </svg>
            <div class="visual-keys"><span>#{c['figure_input']}</span><span>#{c['figure_feature']}</span><span>#{c['figure_output']}</span></div>
            <figcaption><span class="tiny-dot"></span>#{c['figure_feedback']}<small>#{c['figure_caption']}</small></figcaption>
          </figure>
        </section>

        <section id="idea" class="idea section wrap">
          <div class="section-heading"><p class="eyebrow">#{c['idea_kicker']}</p><div><h2>#{c['idea_title']}</h2><p class="section-lead">#{c['idea_intro']}</p></div></div>
          <div class="equation-band"><div class="main-equation" aria-label="f t of x equals inner product of feature map Phi eta t of x and beta t"><var>f</var><sub>t</sub>(<var>x</var>) = ⟨<span>Φ<sub>η<sub>t</sub></sub>(<var>x</var>)</span>, <span>β<sub>t</sub></span>⟩</div><p>#{c['equation_caption']}</p></div>
          <div class="concepts">#{concepts}</div>
          <p class="source-line">#{c['idea_source']} · <a href="https://arxiv.org/html/2412.18756v2">#{c['idea_source_title']} ↗</a></p>
        </section>

        <section id="playground" class="lab-section">
          <div class="wrap section">
            <div class="section-heading"><p class="eyebrow">#{c['lab_kicker']}</p><div><h2>#{c['lab_title']}</h2><p class="section-lead">#{c['lab_intro']}</p></div></div>
            <div class="lab" data-lab data-lang="#{lang}">
              <div class="lab-heading"><span class="eyebrow">#{c['toy_label']}</span><button class="reset-button" type="button" id="reset" hidden>↺ #{c['reset']}</button></div>
              <noscript><p class="no-script">#{c['noscript']}</p></noscript>
              <div class="lab-controls" id="lab-controls" hidden>
                <fieldset class="scenario"><legend>#{c['scenario']}</legend><div class="segmented"><label><input type="radio" name="scenario" value="misaligned" checked><span>#{c['misaligned']}</span></label><label><input type="radio" name="scenario" value="aligned"><span>#{c['aligned']}</span></label></div></fieldset>
                <div class="range-control"><label for="training-time">#{c['time']} <output for="training-time" id="time-value">5.0</output></label><input id="training-time" type="range" min="0" max="20" step="0.1" value="5"></div>
                <div class="range-control"><label for="noise">#{c['noise']} <output for="noise" id="noise-value">0.10</output></label><input id="noise" type="range" min="0" max="0.5" step="0.05" value="0.1"></div>
              </div>
              <div id="lab-results" hidden>
                <div class="chart-topline"><h3>#{c['fit_title']}</h3><div class="legend"><span class="legend-truth">#{c['truth']}</span><span class="legend-fixed">#{c['fixed']}</span><span class="legend-adaptive">#{c['adaptive']}</span></div></div>
                <div id="fit-chart" class="chart" role="img" aria-label="#{c['chart_aria']}"></div>
                <div class="lab-bottom"><div class="weight-panel"><h3>#{c['weights_title']}</h3><div class="legend"><span class="legend-initial">#{c['initial']}</span><span class="legend-adaptive">#{c['learned']}</span></div><div id="weight-chart" role="img" aria-label="#{c['weight_aria']}"></div></div><div class="metrics"><p>#{c['mse']}</p><div><span>#{c['fixed']}</span><strong id="fixed-mse">—</strong></div><div class="adaptive-metric"><span>#{c['adaptive']}</span><strong id="adaptive-mse">—</strong></div></div></div>
                <p class="sr-only" id="lab-live" aria-live="polite" aria-atomic="true">#{c['live']}</p>
                <details class="data-details"><summary>#{zh ? '查看图表数据' : 'View chart data'}</summary><div class="table-scroll"><table><caption>#{zh ? '各坐标的数值' : 'Values by coordinate'}</caption><thead><tr><th scope="col">j</th><th scope="col">#{c['truth']}</th><th scope="col">#{c['fixed']}</th><th scope="col">#{c['adaptive']}</th><th scope="col">#{c['learned']}</th></tr></thead><tbody id="chart-data"></tbody></table></div></details>
              </div>
              <p class="lab-note">#{c['lab_note']}</p>
              <details class="method-details"><summary>#{c['details']}</summary><p>#{c['methods_intro']}</p><div class="method-formulas"><div><span>#{c['fixed_formula']}</span><code>θ̂j(t) = (1 − exp(−λj t)) zj</code></div><div><span>#{c['adaptive_formula']}</span><code>dθj/dt = √(λj² + 4θj²) (zj − θj)</code><code>λj(t) = aj(t)² = (λj + √(λj² + 4θj²)) / 2</code></div></div><p>#{c['methods_end']}</p><a href="https://arxiv.org/html/2409.00894v2">#{c['methods_source']} ↗</a></details>
            </div>
          </div>
        </section>

        <section id="research" class="section wrap research">
          <div class="section-heading"><p class="eyebrow">#{c['research_kicker']}</p><div><h2>#{c['research_title']}</h2><p class="section-lead">#{c['research_intro']}</p></div></div>
          <div class="papers">#{papers}</div>
          <aside class="research-note"><h3>#{c['limits_title']}</h3><p>#{c['limits_body']}</p><a href="https://arxiv.org/html/2511.09425v3">#{c['limits_link']} ↗</a></aside>
        </section>

        <section id="about" class="about-section">
          <div class="wrap section about-grid"><div><p class="eyebrow">#{c['about_kicker']}</p><h2>#{c['about_title']}</h2><p class="role">#{c['about_role']}</p><p>#{c['about_body']}</p><div class="profile-links"><a href="https://www.stat.tsinghua.edu.cn/#{zh ? '' : 'en/'}info/1023/#{zh ? '2413' : '1049'}.htm">#{c['faculty']} ↗</a><a href="https://scholar.google.com/citations?user=kHPrqdgAAAAJ&amp;hl=en">#{c['scholar']} ↗</a></div><p class="contact"><span>#{c['contact']}</span>qianlin [at] tsinghua [dot] edu [dot] cn</p></div><aside class="reading-guide"><span class="guide-symbol" aria-hidden="true">↗</span><h3>#{c['guide_title']}</h3><p>#{c['guide_body']}</p><a class="survey-link" href="https://arxiv.org/abs/2412.18756v2">#{c['survey']} ↗</a><p class="authors">#{c['survey_meta']}</p></aside></div>
        </section>
      </main>
      <footer class="wrap"><span>Adaptive Feature <span class="footer-divider">/</span> #{c['footer']}</span><span>#{c['checked']} <time datetime="#{data['checked_on']}">#{data['checked_on']}</time></span><a href="#top">#{c['top']} ↑</a></footer>
    </body>
    </html>
  HTML
  File.write(File.join(root, file), html)
  puts "Rendered #{file}"
end
