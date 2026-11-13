(function () {
  'use strict';
  const explorer = document.querySelector('[data-dynamics]');
  if (!explorer) return;
  const tabs = Array.from(explorer.querySelectorAll('[role="tab"]'));
  const panels = tabs.map(tab => document.getElementById(tab.getAttribute('aria-controls')));
  function select(index, moveFocus) {
    tabs.forEach((tab, i) => {
      tab.setAttribute('aria-selected', String(i === index));
      tab.tabIndex = i === index ? 0 : -1;
      panels[i].hidden = i !== index;
    });
    if (moveFocus) tabs[index].focus();
  }
  tabs.forEach((tab, index) => {
    panels[index].setAttribute('role', 'tabpanel');
    panels[index].setAttribute('aria-labelledby', tab.id);
    panels[index].tabIndex = 0;
    tab.addEventListener('click', () => select(index, false));
    tab.addEventListener('keydown', event => {
      let next;
      if (event.key === 'ArrowRight') next = (index + 1) % tabs.length;
      else if (event.key === 'ArrowLeft') next = (index + tabs.length - 1) % tabs.length;
      else if (event.key === 'Home') next = 0;
      else if (event.key === 'End') next = tabs.length - 1;
      else return;
      event.preventDefault();
      select(next, true);
    });
  });
  explorer.querySelector('[role="tablist"]').hidden = false;
  function selectFromHash() {
    const index = panels.findIndex(panel => `#${panel.id}` === window.location.hash);
    select(index === -1 ? 0 : index, false);
  }
  selectFromHash();
  window.addEventListener('hashchange', selectFromHash);
  document.querySelectorAll('[data-select-view]').forEach(link => {
    link.addEventListener('click', () => {
      const index = tabs.findIndex(tab => tab.id === `tab-${link.dataset.selectView}`);
      if (index !== -1) select(index, false);
    });
  });
}());
