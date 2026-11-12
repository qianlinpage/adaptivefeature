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
  nav = %w[idea dynamics cycle research].zip(c['nav']).map { |id, text| "<a href=\"##{id}\">#{escape.call(text)}</a>" }.join
  concepts = c['family_terms'].each_with_index.map do |(title, body), index|
    "<article class=\"concept\"><span class=\"concept-number\">0#{index + 1}</span><h3>#{escape.call(title)}</h3><p>#{escape.call(body)}</p></article>"
  end.join("\n")
  dynamics_tabs = c['dynamics'].each_with_index.map do |view, index|
    "<button type=\"button\" role=\"tab\" id=\"tab-#{view['id']}\" aria-controls=\"view-#{view['id']}\" aria-selected=\"#{index.zero?}\" tabindex=\"#{index.zero? ? '0' : '-1'}\"><span>0#{index + 1}</span>#{escape.call(view['label'])}</button>"
  end.join("\n")
  dynamics_panels = c['dynamics'].map do |view|
    nodes = view['symbols'].zip(view['labels']).map do |symbol, label|
      "<div class=\"sketch-node\"><span class=\"sketch-symbol\">#{escape.call(symbol)}</span><span>#{escape.call(label)}</span></div>"
    end.join('<span class="sketch-arrow" aria-hidden="true">→</span>')
    <<~HTML
      <article class="dynamics-panel" id="view-#{view['id']}" aria-labelledby="heading-#{view['id']}">
        <div class="dynamics-copy"><h3 id="heading-#{view['id']}">#{escape.call(view['title'])}</h3><p>#{escape.call(view['body'])}</p><dl><dt>#{c['dynamics_question']}</dt><dd>#{escape.call(view['question'])}</dd><dt>#{c['dynamics_focus']}</dt><dd>#{escape.call(view['focus'])}</dd></dl></div>
        <figure class="dynamics-sketch" data-view="#{view['id']}"><p class="eyebrow">#{c['dynamics_diagram']}</p><div class="sketch-flow">#{nodes}</div><figcaption>#{escape.call(view['caption'])}</figcaption></figure>
      </article>
    HTML
  end.join("\n")
  cycle_steps = c['cycle_steps'].each_with_index.map do |(title, body), index|
    "<li><span class=\"cycle-number\">0#{index + 1}</span><div><h3>#{escape.call(title)}</h3><p>#{escape.call(body)}</p></div></li>"
  end.join("\n")
  goal_chain = c['goal_chain'].map { |label| "<span>#{escape.call(label)}</span>" }.join('<span class="goal-arrow" aria-hidden="true">→</span>')
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
      <script src="assets/program.js" defer></script>
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
        <section class="hero program-hero wrap" aria-labelledby="hero-title">
          <div class="hero-copy">
            <p class="eyebrow"><span class="tiny-dot"></span>#{c['eyebrow']}</p>
            <h1 id="hero-title">#{c['hero_title']}</h1>
            <p class="hero-intro">#{c['hero_intro']}</p>
            <p class="byline">#{c['byline']}</p>
            <div class="hero-actions"><a class="button primary" href="#idea">#{c['cta']} <span>↗</span></a><a class="text-link" href="#cycle">#{c['cta_secondary']} <span>↓</span></a></div>
          </div>
          <figure class="program-map">
            <div class="visual-label">#{c['figure_label']}</div>
            <div class="map-loop">
              <div class="map-node map-family"><span>#{c['map_family']}</span><strong>Φ ∈ 𝓕</strong></div>
              <span class="map-arrow" aria-hidden="true">↓</span>
              <div class="map-analysis"><span>#{c['map_analysis']}</span><div>#{c['map_levels'].map { |label| "<span>#{escape.call(label)}</span>" }.join}</div></div>
              <span class="map-arrow" aria-hidden="true">↓</span>
              <div class="map-node map-network"><strong>#{c['map_network']}</strong><span>#{c['map_network_note']}</span></div>
              <div class="map-return" aria-hidden="true"><span>←</span></div>
            </div>
            <figcaption><span aria-hidden="true">↶</span>#{c['map_feedback']}</figcaption>
            <p class="map-goal">#{c['map_goal']}</p>
          </figure>
        </section>

        <section id="idea" class="idea section wrap">
          <div class="section-heading"><p class="eyebrow">#{c['idea_kicker']}</p><div><h2>#{c['idea_title']}</h2><p class="section-lead">#{c['idea_intro']}</p></div></div>
          <div class="family-equations"><div><span class="equation-label">#{c['family_label']}</span><div class="family-math">𝓕 ⊆ {Φ : 𝓧 → ℋ}</div></div><div><span class="equation-label">#{c['regression_label']}</span><div class="family-math"><var>f</var><sub>Φ,β</sub>(<var>x</var>) = ⟨Φ(<var>x</var>), β⟩<sub>ℋ</sub></div></div><p>#{c['equation_caption']}</p></div>
          <div class="concepts">#{concepts}</div>
          <p class="source-line">#{c['idea_source']} · <a href="https://arxiv.org/html/2412.18756v2">#{c['idea_source_title']} ↗</a></p>
        </section>

        <section id="dynamics" class="dynamics-section">
          <div class="wrap section">
            <div class="section-heading"><p class="eyebrow">#{c['dynamics_kicker']}</p><div><h2>#{c['dynamics_title']}</h2><p class="section-lead">#{c['dynamics_intro']}</p></div></div>
            <div class="dynamics-explorer" data-dynamics><div class="dynamics-tabs" role="tablist" aria-label="#{c['dynamics_nav']}" hidden>#{dynamics_tabs}</div>#{dynamics_panels}</div>
          </div>
        </section>

        <section id="cycle" class="section wrap">
          <div class="section-heading"><p class="eyebrow">#{c['cycle_kicker']}</p><div><h2>#{c['cycle_title']}</h2><p class="section-lead">#{c['cycle_intro']}</p></div></div>
          <div class="research-loop"><div><ol class="cycle-steps">#{cycle_steps}</ol><p class="cycle-return"><span aria-hidden="true">↶</span>#{c['cycle_return']}</p></div><aside class="program-goal"><p class="eyebrow">#{c['goal_kicker']}</p><h3>#{c['goal_title']}</h3><div class="goal-chain">#{goal_chain}</div><p>#{c['goal_body']}</p><p class="goal-note">#{c['goal_note']}</p></aside></div>
        </section>

        <section id="playground" class="lab-section">
          <div class="wrap section">
            <div class="section-heading"><p class="eyebrow">#{c['lab_kicker']}</p><div><h2>#{c['lab_title']}</h2><p class="section-lead">#{c['lab_intro']}</p></div></div>
            <details class="prototype-shell"><summary>#{c['prototype_open']} <span aria-hidden="true">↗</span></summary><div class="lab" data-lab data-lang="#{lang}">
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
            </div></details>
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
