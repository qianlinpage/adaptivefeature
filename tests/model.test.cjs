const assert = require('node:assert/strict');
const {simulate, flow, lambda} = require('../assets/model.js');

function close(actual, expected, tolerance = 1e-8) {
  assert.ok(Math.abs(actual - expected) < tolerance, `${actual} differs from ${expected}`);
}

// Independent reference: integrate the two factor equations, rather than the
// scalar reduction used by the website. This also checks the meaning of a².
function factorReference(z, weight, time) {
  let a = Math.sqrt(weight), b = 0;
  const n = Math.ceil(time / 0.002), h = time / n;
  const derivative = (x, y) => [y * (z - x * y), x * (z - x * y)];
  for (let k = 0; k < n; k++) {
    const p = derivative(a, b);
    const q = derivative(a + h * p[0] / 2, b + h * p[1] / 2);
    const r = derivative(a + h * q[0] / 2, b + h * q[1] / 2);
    const s = derivative(a + h * r[0], b + h * r[1]);
    a += h * (p[0] + 2 * q[0] + 2 * r[0] + s[0]) / 6;
    b += h * (p[1] + 2 * q[1] + 2 * r[1] + s[1]) / 6;
  }
  return {theta: a * b, weight: a * a, invariant: a * a - b * b};
}

const start = simulate({time: 0});
start.fixed.forEach(value => close(value, 0));
assert.deepEqual(start.adaptive, Array(6).fill(0));
assert.deepEqual(start.weights, lambda);
assert.equal(start.fixedMSE, start.adaptiveMSE);

let cases = 0;
for (const scenario of ['aligned', 'misaligned']) {
  for (const time of [0, 0.1, 1, 5, 20]) {
    for (const noise of [0, 0.1, 0.5]) {
      const result = simulate({time, noise, scenario});
      for (let j = 0; j < 6; j++) {
        const z = result.observations[j];
        close(result.fixed[j], (1 - Math.exp(-lambda[j] * time)) * z);
        assert.ok(Number.isFinite(result.adaptive[j]));
        assert.ok(result.adaptive[j] >= Math.min(0, z) - 1e-10);
        assert.ok(result.adaptive[j] <= Math.max(0, z) + 1e-10);
        assert.ok(result.weights[j] >= lambda[j]);
        if (time > 0) {
          const reference = factorReference(z, lambda[j], time);
          close(result.adaptive[j], reference.theta, 1e-7);
          close(result.weights[j], reference.weight, 1e-7);
          close(reference.invariant, lambda[j]);
        }
      }
      cases++;
    }
  }
}

for (const weight of lambda) {
  close(flow(-0.9, weight, 5), -flow(0.9, weight, 5));
  close(flow(0.9, weight, 5, 0.02), flow(0.9, weight, 5, 0.005), 1e-7);
  assert.equal(flow(0, weight, 20), 0);
}
const converged = simulate({time: 200, noise: 0});
converged.adaptive.forEach((value, j) => close(value, converged.truth[j]));
for (const invalid of [{time: NaN}, {time: -1}, {time: 201}, {noise: Infinity}, {noise: 0.6}, {scenario: 'toString'}, {scenario: 'unknown'}, {step: 0}, {step: 0.2}]) {
  assert.throws(() => simulate(invalid), RangeError);
}
console.log(`Passed: ${cases} scenarios, independent factor dynamics, feature weights, convergence and input bounds.`);
