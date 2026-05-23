// theme-toggle.js
// Handles dark mode toggle and persistence via localStorage
(function () {
  const THEME_KEY = 'theme';
  const DARK = 'dark';
  const LIGHT = 'light';

  // Apply the stored theme or system preference on page load
  const applyTheme = (theme) => {
    document.documentElement.setAttribute('data-theme', theme);
  };

  const initTheme = () => {
    const stored = localStorage.getItem(THEME_KEY);
    if (stored) {
      applyTheme(stored);
    } else {
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      applyTheme(prefersDark ? DARK : LIGHT);
    }
  };

  // Toggle between dark and light themes
  window.toggleTheme = function () {
    const current = document.documentElement.getAttribute('data-theme') || LIGHT;
    const next = current === DARK ? LIGHT : DARK;
    applyTheme(next);
    localStorage.setItem(THEME_KEY, next);
  };

  // Initialise on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTheme);
  } else {
    initTheme();
  }
})();
