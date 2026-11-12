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

%w[index.html index.zh.html].each do |file|
  html = File.read(File.join(root, file))
  ids = html.scan(/\bid="([^"]+)"/).flatten
  failures << "#{file}: duplicate IDs" unless ids.uniq == ids
  failures << "#{file}: unprotected email" if html.match?(/mailto:|qianlin@/i)
  failures << "#{file}: linked to old project" if html.include?('TestWeb') || html.include?('academic-homepage')
  failures << "#{file}: wrong paper count" unless html.scan('class="paper"').length == data['papers'].length
  html.scan(/\b(?:href|src)="([^"]+)"/).flatten.each do |raw|
    url = CGI.unescapeHTML(raw)
    next if url.match?(/\Ahttps:\/\//)
    path, fragment = url.split('#', 2)
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
abort failures.join("\n") unless failures.empty?
puts 'Passed: bilingual content, unique IDs, local links, anchors, paper count and project separation.'
