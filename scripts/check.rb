#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'
require 'cgi'
require 'uri'

root = File.expand_path('..', __dir__)
data = JSON.parse(File.read(File.join(root, 'data/content.json')))
failures = []
failures << 'Language keys differ' unless data['en'].keys.sort == data['zh'].keys.sort
paper_ids = data['papers'].map { |p| p['id'] }
failures << 'Duplicate paper IDs' unless paper_ids.uniq == paper_ids
personal_homepages = %w[
  https://qianlinpage.github.io/TestWeb/index.html
  https://qianlinpage.github.io/TestWeb/index.zh.html
]

%w[index research prototype papers].product(['.html', '.zh.html']).map(&:join).each do |file|
  html = File.read(File.join(root, file))
  ids = html.scan(/\bid="([^"]+)"/).flatten
  failures << "#{file}: duplicate IDs" unless ids.uniq == ids
  failures << "#{file}: unprotected email" if html.match?(/mailto:|qianlin@/i)
  # The author requested these external homepage links; local assets stay separate.
  isolated_html = personal_homepages.reduce(html) { |markup, url| markup.gsub("href=\"#{url}\"", '') }
  failures << "#{file}: linked to old project" if isolated_html.include?('TestWeb') || isolated_html.include?('academic-homepage')
  expected_papers = file.start_with?('papers') ? data['papers'].length : 0
  failures << "#{file}: wrong paper count" unless html.scan('class="paper"').length == expected_papers
  failures << "#{file}: prototype on wrong page" unless html.include?('data-lab') == file.start_with?('prototype')
  failures << "#{file}: dynamics on wrong page" unless html.include?('data-dynamics') == file.start_with?('research')
  page = file.split('.').first
  if html.include?('class="katex"')
    failures << "#{file}: missing local math stylesheet" unless html.include?('assets/vendor/katex-0.19.1/katex.min.css?v=')
    failures << "#{file}: missing accessible math" unless html.include?('<math xmlns="http://www.w3.org/1998/Math/MathML"')
  end
  failures << "#{file}: unrendered math placeholder" if html.include?('{{math:')
  failures << "#{file}: missing language counterpart" unless html.include?("href=\"#{page}.html\"") && html.include?("href=\"#{page}.zh.html\"")
  html.scan(/\b(?:href|src)="([^"]+)"/).flatten.each do |raw|
    url = CGI.unescapeHTML(raw)
    next if url.match?(/\Ahttps:\/\//)
    uri = URI.parse(url)
    path, fragment = uri.path, uri.fragment
    target = path.empty? ? file : path
    target_path = File.join(root, target)
    unless File.file?(target_path)
      failures << "#{file}: missing #{target}"
      next
    end
    if fragment && !File.read(target_path).include?("id=\"#{fragment}\"")
      failures << "#{file}: missing anchor #{url}"
    end
  end
end
Dir.glob(File.join(root, 'assets', '**', '*.css')).each do |stylesheet|
  File.read(stylesheet).scan(/url\(([^)]+)\)/).flatten.each do |raw|
    url = raw.strip.sub(/\A["']/, '').sub(/["']\z/, '')
    next if url.start_with?('data:', 'https:', 'http:', '#')
    resource = File.expand_path(URI.parse(url).path, File.dirname(stylesheet))
    failures << "#{stylesheet.delete_prefix(root + '/')}: missing resource #{url}" unless File.file?(resource)
  end
end
abort failures.join("\n") unless failures.empty?
puts 'Passed: bilingual content, local links and CSS resources, accessible math, anchors, paper count and project separation.'
