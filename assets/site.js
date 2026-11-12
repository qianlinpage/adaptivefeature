(function () {
  'use strict';
  const lab = document.querySelector('[data-lab]');
  if (!lab || !window.AdaptiveFeatureModel) return;
  const zh = lab.dataset.lang === 'zh';
  const time = document.getElementById('training-time'), noise = document.getElementById('noise');
  const fit = document.getElementById('fit-chart'), weights = document.getElementById('weight-chart');
  const ns = 'http://www.w3.org/2000/svg';
  let announcement, lastWidth = 0;
  function svgNode(tag, attributes, text) {
    const node = document.createElementNS(ns, tag);
    Object.entries(attributes || {}).forEach(([name, value]) => node.setAttribute(name, value));
    if (text !== undefined) node.textContent = text;
    return node;
  }
  function plot(container, series, lower, upper, ticks, height) {
    const width = Math.max(280, Math.round(container.clientWidth || 680));
    const left = 34, right = width - 12, top = 16, bottom = height - 32;
    const y = value => bottom - (value - lower) / (upper - lower) * (bottom - top);
    const svg = svgNode('svg', {viewBox: `0 0 ${width} ${height}`, width, height, 'aria-hidden': 'true', focusable: 'false'});
    ticks.forEach(value => {
      svg.append(svgNode('line', {x1: left, y1: y(value), x2: right, y2: y(value), stroke: value === 0 ? '#b1bbb2' : '#e6eae3', 'stroke-width': 1}));
      svg.append(svgNode('text', {x: left - 8, y: y(value) + 4, 'text-anchor': 'end', fill: '#727e75', 'font-size': 11}, value.toFixed(1)));
    });
    const group = (right - left) / 6, bar = Math.min(18, (group - 12) / series.length);
    for (let j = 0; j < 6; j++) {
      const center = left + group * (j + 0.5);
      series.forEach((item, k) => {
        const value = item.values[j];
        const rect = svgNode('rect', {x: center + (k - series.length / 2) * (bar + 2), y: Math.min(y(0), y(value)), width: bar, height: Math.max(0.6, Math.abs(y(0) - y(value))), rx: 2, fill: item.fill, stroke: item.stroke || 'none', 'stroke-width': 1.4});
        svg.append(rect);
      });
      svg.append(svgNode('text', {x: center, y: height - 9, 'text-anchor': 'middle', fill: '#627168', 'font-size': 12}, `j${j + 1}`));
    }
    container.replaceChildren(svg);
  }
  function render() {
    const scenario = document.querySelector('input[name="scenario"]:checked').value;
    const result = window.AdaptiveFeatureModel.simulate({time: Number(time.value), noise: Number(noise.value), scenario});
    document.getElementById('time-value').value = Number(time.value).toFixed(1);
    document.getElementById('noise-value').value = Number(noise.value).toFixed(2);
    plot(fit, [
      {values: result.truth, fill: '#f7f7ef', stroke: '#657c6b'},
      {values: result.fixed, fill: '#cb865b'},
      {values: result.adaptive, fill: '#1b7869'}
    ], -0.5, 1.5, [-0.5, 0, 0.5, 1, 1.5], 280);
    plot(weights, [{values: result.initialWeights, fill: '#cbd4c8'}, {values: result.weights, fill: '#1b7869'}], 0, 2, [0, 1, 2], 180);
    document.getElementById('fixed-mse').textContent = result.fixedMSE.toFixed(4);
    document.getElementById('adaptive-mse').textContent = result.adaptiveMSE.toFixed(4);
    const body = document.getElementById('chart-data');
    body.replaceChildren(...result.truth.map((truth, j) => {
      const tr = document.createElement('tr'), th = document.createElement('th');
      th.scope = 'row'; th.textContent = `j${j + 1}`; tr.append(th);
      [truth, result.fixed[j], result.adaptive[j], result.weights[j]].forEach(value => { const td = document.createElement('td'); td.textContent = value.toFixed(4); tr.append(td); });
      return tr;
    }));
    clearTimeout(announcement);
    announcement = setTimeout(() => {
      document.getElementById('lab-live').textContent = zh
        ? `训练时间 ${time.value}，固定特征均方误差 ${result.fixedMSE.toFixed(4)}，自适应特征均方误差 ${result.adaptiveMSE.toFixed(4)}。`
        : `Training time ${time.value}. Fixed-feature MSE ${result.fixedMSE.toFixed(4)}. Adaptive-feature MSE ${result.adaptiveMSE.toFixed(4)}.`;
    }, 350);
  }
  document.getElementById('lab-controls').hidden = false;
  document.getElementById('lab-results').hidden = false;
  const reset = document.getElementById('reset'); reset.hidden = false;
  [time, noise, ...document.querySelectorAll('input[name="scenario"]')].forEach(control => control.addEventListener('input', render));
  reset.addEventListener('click', () => { time.value = 5; noise.value = 0.1; document.querySelector('input[value="misaligned"]').checked = true; render(); });
  render();
  if ('ResizeObserver' in window) new ResizeObserver(() => { const width = Math.round(fit.clientWidth); if (width !== lastWidth) { lastWidth = width; render(); } }).observe(fit);
}());
