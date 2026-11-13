#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'
require 'cgi'
require_relative 'components'

root = File.expand_path('..', __dir__)
data = JSON.parse(File.read(File.join(root, 'data/content.json')))
e = ->(value) { CGI.escapeHTML(value.to_s) }

%w[en zh].each do |lang|
  c = data.fetch(lang)
  zh = lang == 'zh'
  suffix = zh ? '.zh.html' : '.html'
  figure = "assets/figures/adaptive-feature-idea.#{lang}.svg"
  tabs = c['dynamics'].each_with_index.map do |view, i|
    "<button type=\"button\" role=\"tab\" id=\"tab-#{view['id']}\" aria-controls=\"view-#{view['id']}\" aria-selected=\"#{i.zero?}\" tabindex=\"#{i.zero? ? 0 : -1}\"><span>0#{i+1}</span>#{e.call(view['label'])}</button>"
  end.join
  panels = c['dynamics'].map do |view|
    <<~HTML
      <article class="dynamics-panel" id="view-#{view['id']}" aria-labelledby="heading-#{view['id']}">
        <div class="dynamics-copy"><h3 id="heading-#{view['id']}">#{e.call(view['title'])}</h3><p>#{e.call(view['body'])}</p><dl><dt>#{c['dynamics_question']}</dt><dd>#{e.call(view['question'])}</dd><dt>#{c['dynamics_focus']}</dt><dd>#{e.call(view['focus'])}</dd></dl><a class="inline-source" href="#{view['url']}">#{e.call(view['source'])} ↗</a></div>
        <p class="analysis-formula">#{e.call(view['formula'])}</p>
      </article>
    HTML
  end.join
  feedback = c['feedback_items'].each_with_index.map do |(label, title, body), i|
    "<article class=\"evidence-row\"><span class=\"evidence-number\">0#{i+1}</span><div><p class=\"eyebrow\">#{e.call(label)}</p><h3>#{e.call(title)}</h3></div><p>#{e.call(body)}</p></article>"
  end.join
  foundations = c['established_items'].map do |title, body, paper|
    "<li><h4>#{e.call(title)}</h4><p>#{e.call(body)}</p><a href=\"papers#{suffix}#paper-#{paper}\">#{c['read']} ↗</a></li>"
  end.join
  questions = c['questions_items'].map { |title, body| "<li><h4>#{e.call(title)}</h4><p>#{e.call(body)}</p></li>" }.join
  paper_cards = data['papers'].to_h do |paper|
    arxiv = paper['arxiv'] ? "<a href=\"#{paper['arxiv']}\">arXiv ↗</a>" : ''
    card = <<~HTML
      <article class="paper" id="paper-#{paper['id']}">
        <div class="paper-year">#{e.call(paper['year'])}</div>
        <div class="paper-body"><div class="paper-topline"><span>#{e.call(paper['tag'][lang])}</span><span class="status">#{e.call(paper['status'][lang])}</span></div><h3><a href="#{paper['url']}">#{e.call(paper['title'])}</a></h3><p class="authors">#{e.call(paper['authors'])}</p><p class="paper-summary">#{e.call(paper['summary'][lang])}</p><div class="paper-bottom"><span>#{e.call(paper['venue'])}</span><div><a href="#{paper['url']}">#{c['read']} ↗</a>#{arxiv}</div></div></div>
      </article>
    HTML
    [paper['id'], card]
  end
  papers = paper_cards.values.join
  sections = {}
  sections[:dynamics] = <<~HTML
        <section id="dynamics" class="section dynamics-section"><div class="wrap">
          <div class="section-heading"><div><h2>#{c['dynamics_title']}</h2><p class="section-lead">#{c['dynamics_intro']}</p></div></div>
          <div class="dynamics-explorer" data-dynamics><div class="dynamics-tabs" role="tablist" aria-label="#{c['dynamics_nav']}" hidden>#{tabs}</div>#{panels}</div>
        </div></section>
  HTML
  sections[:feedback] = <<~HTML
        <section id="feedback" class="section feedback-section wrap">
          <div class="section-heading"><div><h2>#{c['feedback_title']}</h2><p class="section-lead">#{c['feedback_intro']}</p></div></div>
          <div class="evidence-list">#{feedback}</div><div class="evidence-footer"><p>#{c['feedback_note']}</p><span>#{c['feedback_return']}</span></div>
        </section>
  HTML
  sections[:agenda] = <<~HTML
        <section id="agenda" class="section agenda-section"><div class="wrap">
          <div class="section-heading"><div><h2>#{c['agenda_title']}</h2><p class="section-lead">#{c['agenda_intro']}</p></div></div>
          <div class="agenda-grid"><article class="foundations"><h3><span class="key-solid" aria-hidden="true"></span>#{c['established_label']}</h3><ol>#{foundations}</ol></article><article class="questions"><h3><span class="key-dashed" aria-hidden="true"></span>#{c['questions_label']}</h3><ol>#{questions}</ol></article></div><p class="agenda-note">#{c['agenda_note']}</p>

        </div></section>
  HTML
  sections[:papers] = <<~HTML
        <section id="research" class="section wrap research"><div class="papers">#{papers}</div></section>
  HTML
  sections[:prototype] = <<~HTML
          <div id="playground" class="prototype-section">#{render_lab(c,zh)}</div>
  HTML
  views = c['framework_views'].map do |view|
    "<li><a href=\"research#{suffix}#view-#{view['id']}\"><div class=\"symbolic-illustration\"><img src=\"assets/figures/#{e.call(view['asset'])}\" width=\"240\" height=\"160\" alt=\"#{e.call(view['alt'])}\"></div><h3>#{e.call(view['label'])}</h3><p>#{e.call(view['summary'])}</p></a></li>"
  end.join
  transfers = [1, 0].map do |i|
    label = [c['framework_down'], c['framework_up']][i]
    points = i.zero? ? '38,127 48,142 58,127' : '38,23 48,8 58,23'
    "<div class=\"transfer-lane #{i.zero? ? 'application' : 'feedback'}\"><div class=\"transfer-visual\"><svg class=\"transfer-path\" viewBox=\"0 0 180 150\" aria-hidden=\"true\"><path d=\"M48 10V140\"/><polyline points=\"#{points}\"/></svg><div class=\"transfer-character\" style=\"--character:#{i}\"><img src=\"assets/figures/research-arrow-characters-v3.png\" width=\"1774\" height=\"887\" alt=\"#{e.call(c['framework_arrow_alts'][i])}\" decoding=\"async\"></div></div><p>#{e.call(label)}</p></div>"
  end.join
  framework = <<~HTML
    <figure class="framework-cartoon">
      <div class="theory-family"><p class="family-label">#{c['framework_family']}</p><ul class="analysis-views">#{views}</ul></div>
      <div class="framework-exchange">#{transfers}</div>
      <a class="network-view" href="research#{suffix}#feedback"><div class="symbolic-network"><img src="assets/figures/neural-network-v3.svg" width="520" height="180" alt="#{e.call(c['framework_network_alt'])}"></div><h3>#{c['framework_network']}</h3><p>#{c['framework_network_note']}</p></a>
      <figcaption>#{c['cartoon_caption']}</figcaption>
    </figure>
  HTML
  entrances = %w[research prototype papers].each_with_index.map do |name, i|
    "<li><a href=\"#{name}#{suffix}\"><span class=\"entry-number\" aria-hidden=\"true\">0#{i+1}</span><span class=\"entry-title\">#{c['site_pages'][i+1]}</span><span class=\"entry-description\">#{e.call(c['simple_routes'][i])}</span><span class=\"entry-arrow\" aria-hidden=\"true\">↗</span></a></li>"
  end.join
  overview = <<~HTML
    <div class="wrap home-overview">
      <section class="home-intro"><p class="intro-kicker"><span aria-hidden="true"></span>#{c['display_kicker']}</p><h1>#{e.call(c['display_title'][0])}<br><em>#{e.call(c['display_title'][1])}</em></h1><p class="intro">#{c['simple_intro']}</p><div class="intro-bottom"><p class="byline">#{c['byline']}</p><a href="research#{suffix}" class="intro-link">#{c['explore_label']} <span aria-hidden="true">↗</span></a></div></section>
      <section id="framework" class="home-strategy"><div class="strategy-heading"><div><h2>#{c['simple_strategy']}</h2><p>#{c['strategy_caption']}</p></div><a class="text-link" href="#{figure}">#{c['figure_open']} <span aria-hidden="true">↗</span></a></div>#{framework}<p class="scope-note">#{c['simple_scope']}</p></section>
      <section id="research" class="home-entrances"><h2>#{c['simple_routes_title']}</h2><ul class="entrance-list">#{entrances}</ul></section>
      <p class="home-contact"><a href="https://www.stat.tsinghua.edu.cn/#{zh ? '' : 'en/'}info/1023/#{zh ? '2413' : '1049'}.htm">#{c['faculty']}</a><span>qianlin [at] tsinghua [dot] edu [dot] cn</span></p>
    </div>
  HTML
  prototype = <<~HTML
    <section class="section wrap prototype-page"><p class="section-lead">#{c['prototype_context']}</p><a class="text-link" href="research#{suffix}">#{c['site_pages'][1]} ↗</a>#{sections[:prototype]}</section>
  HTML
  bodies = {
    'index' => overview,
    'research' => sections[:dynamics] + sections[:feedback] + sections[:agenda],
    'prototype' => prototype,
    'papers' => sections[:papers]
  }
  bodies.each_with_index do |(page, content), page_index|
    file = "#{page}#{suffix}"
    title = page == 'index' ? c['title'] : "#{c['site_pages'][page_index]} | Adaptive Feature"
    description = c['page_intros'][page_index]
    nav = bodies.keys.each_with_index.map { |name, i| "<a href=\"#{name}#{suffix}\"#{name == page ? ' aria-current="page"' : ''}>#{c['site_pages'][i]}</a>" }.join
    page_header = page == 'index' ? '' : "<div class=\"wrap page-heading\"><a class=\"text-link\" href=\"index#{suffix}\">← #{c['strategy_back']}</a><h1>#{c['site_pages'][page_index]}</h1><p class=\"section-lead\">#{e.call(description)}</p></div>"
    scripts = if page == 'research'
      '<script src="assets/program.js" defer></script>'
    elsif page == 'prototype'
      '<script src="assets/model.js" defer></script><script src="assets/site.js" defer></script>'
    else
      ''
    end
    html = <<~HTML
    <!DOCTYPE html>
    <html lang="#{zh ? 'zh-CN' : 'en'}">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>#{e.call(title)}</title>
      <meta name="description" content="#{e.call(description)}">
      <meta name="theme-color" content="#f8f7f3">
      <meta property="og:title" content="#{e.call(title)}">
      <meta property="og:description" content="#{e.call(description)}">
      <meta property="og:type" content="website">
      <link rel="icon" href="assets/favicon.svg" type="image/svg+xml">
      <link rel="stylesheet" href="assets/lab.css">
      <link rel="stylesheet" href="assets/site.css">
      <link rel="alternate" hreflang="en" href="#{page}.html">
      <link rel="alternate" hreflang="zh-CN" href="#{page}.zh.html">
      #{scripts}
    </head>
    <body id="top">
      <a class="skip-link" href="#main">#{c['skip']}</a>
      <header class="site-header"><div class="header-inner wrap">
        <a class="brand" href="index#{suffix}" aria-label="Adaptive Feature"><img src="assets/favicon.svg" width="32" height="32" alt=""><span>Adaptive<span class="brand-light">Feature</span></span></a>
        <nav aria-label="#{zh ? '主导航' : 'Main navigation'}">#{nav}</nav>
        <div class="languages" aria-label="Language / 语言"><a href="#{page}.zh.html" lang="zh-CN" hreflang="zh-CN"#{zh ? ' aria-current="page"' : ''}>中文</a><a href="#{page}.html" lang="en" hreflang="en"#{zh ? '' : ' aria-current="page"'}>EN</a></div>
      </div></header>
      <main id="main">
#{page_header}
#{content}
      </main>
      <footer class="wrap"><span>Adaptive Feature <span class="footer-divider">/</span> #{c['footer']}</span><span>#{c['checked']} <time datetime="#{data['checked_on']}">#{data['checked_on']}</time></span><a href="#top">#{c['top']} ↑</a></footer>
    </body>
    </html>
    HTML
    File.write(File.join(root,file),html)
    puts "Rendered #{file}"
  end
end
