(function (root, factory) {
  'use strict';
  const api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.AdaptiveFeatureModel = api;
}(typeof globalThis !== 'undefined' ? globalThis : this, function () {
  'use strict';
  const lambda = Object.freeze([1, 0.55, 0.25, 0.10, 0.04, 0.015]);
  const noiseDirection = Object.freeze([-0.7, 0.4, -0.8, 0.9, -0.6, 0.5]);
  const signals = Object.freeze({
    aligned: Object.freeze([1.1, 0.8, 0.4, 0, 0, 0]),
    misaligned: Object.freeze([0, 0, 0.4, 0.8, 0, 1.1])
  });
  function flow(observation, weight, time, step = 0.02) {
    if (time === 0 || observation === 0) return 0;
    let theta = 0;
    const count = Math.ceil(time / step), h = time / count;
    const derivative = value => Math.hypot(weight, 2 * value) * (observation - value);
    for (let i = 0; i < count; i++) {
      const k1 = derivative(theta), k2 = derivative(theta + h * k1 / 2);
      const k3 = derivative(theta + h * k2 / 2), k4 = derivative(theta + h * k3);
      theta += h * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
    }
    return theta;
  }
  function simulate({time = 5, noise = 0.1, scenario = 'misaligned', step = 0.02} = {}) {
    if (!Number.isFinite(time) || time < 0 || time > 200 || !Number.isFinite(noise) || noise < 0 || noise > 0.5 || !Object.prototype.hasOwnProperty.call(signals, scenario) || !Number.isFinite(step) || step <= 0 || step > 0.1) throw new RangeError('Invalid simulation parameters');
    const truth = signals[scenario].slice();
    const observations = truth.map((value, j) => value + noise * noiseDirection[j]);
    const fixed = observations.map((z, j) => -Math.expm1(-lambda[j] * time) * z);
    const adaptive = observations.map((z, j) => flow(z, lambda[j], time, step));
    const weights = adaptive.map((theta, j) => (lambda[j] + Math.hypot(lambda[j], 2 * theta)) / 2);
    const mse = values => values.reduce((sum, value, j) => sum + (value - truth[j]) ** 2, 0) / truth.length;
    return {truth, observations, fixed, adaptive, weights, initialWeights: lambda.slice(), fixedMSE: mse(fixed), adaptiveMSE: mse(adaptive)};
  }
  return Object.freeze({simulate, flow, lambda, noiseDirection});
}));
