#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const katex = require('../assets/vendor/katex-0.19.1/katex.min.js');

try {
  const expressions = JSON.parse(fs.readFileSync(0, 'utf8'));
  const rendered = {};
  for (const [key, expression] of Object.entries(expressions)) {
    if (typeof expression.tex !== 'string' || typeof expression.display !== 'boolean') {
      throw new Error(`Invalid math expression: ${key}`);
    }
    rendered[key] = katex.renderToString(expression.tex, {
      displayMode: expression.display,
      output: 'htmlAndMathml',
      throwOnError: true,
      strict: 'error',
      trust: false
    });
  }
  process.stdout.write(JSON.stringify(rendered));
} catch (error) {
  process.stderr.write(`Math rendering failed: ${error.message}\n`);
  process.exitCode = 1;
}
