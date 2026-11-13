# frozen_string_literal: true

def render_lab(c, zh)
  <<~HTML
            <details class="prototype-shell"><summary>#{c['prototype_open']} <span aria-hidden="true">↗</span></summary><div class="lab" data-lab data-lang="#{zh ? 'zh' : 'en'}">
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
  HTML
end
