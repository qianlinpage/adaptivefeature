const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
function element(id) {
  return {id, attributes: {}, events: {}, hidden: false,
    setAttribute(k,v) { this.attributes[k] = v; },
    getAttribute(k) { return this.attributes[k]; },
    addEventListener(k,v) { this.events[k] = v; },
    focus() { this.focused = true; }};
}
const names = ['fixed','local','global'];
const panels = names.map(n => element(`view-${n}`));
const tabs = names.map((n,i) => { const t = element(`tab-${n}`); t.attributes['aria-controls'] = panels[i].id; return t; });
const tablist = {hidden:true};
const explorer = {querySelectorAll: () => tabs, querySelector: () => tablist};
const events = {};
const window = {location: {hash: '#view-local'}, addEventListener(k,v) { events[k] = v; }};
vm.runInNewContext(fs.readFileSync(path.join(__dirname,'../assets/program.js'),'utf8'), {
  window,
  document: {querySelector: () => explorer, querySelectorAll: () => [], getElementById: id => panels.find(p => p.id === id)}
});
function selected(index) {
  assert.deepEqual(panels.map(p => p.hidden), panels.map((_,i) => i !== index));
  assert.equal(tabs[index].attributes['aria-selected'], 'true');
  assert.equal(tabs[index].tabIndex, 0);
}
assert.equal(tablist.hidden, false);
selected(1);
tabs[1].events.keydown({key:'ArrowRight', preventDefault(){}}); selected(2); assert.equal(tabs[2].focused,true);
tabs[2].events.keydown({key:'Home', preventDefault(){}}); selected(0);
tabs[0].events.keydown({key:'End', preventDefault(){}}); selected(2);
tabs[1].events.click(); selected(1);
window.location.hash = '#view-global'; events.hashchange(); selected(2);
window.location.hash = '#feedback'; events.hashchange(); selected(0);
console.log('Passed: deep-linked views, mouse selection, keyboard navigation and hash changes.');
