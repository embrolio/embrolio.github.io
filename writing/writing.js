/* ──── brolio.dev/writing — Shared Runtime ──── */

(function() {
  'use strict';

  // ──── Reading Time Calculation ────

  function calculateReadingTime() {
    var article = document.querySelector('[data-reading-time]');
    if (!article) return;

    var text = article.textContent || '';
    var words = text.trim().split(/\s+/).length;
    var minutes = Math.ceil(words / 200);

    var display = document.querySelector('.reading-time');
    if (display) {
      display.textContent = minutes + ' min read';
    }
  }

  // ──── Reading Progress Bar ────

  function initProgressBar() {
    var progress = document.querySelector('.reading-progress');
    var article = document.querySelector('.writing-article-content');

    if (!progress || !article) return;

    var ticking = false;

    function updateProgress() {
      var rect = article.getBoundingClientRect();
      var viewportHeight = window.innerHeight;
      var articleHeight = article.offsetHeight;

      var scrolled = -rect.top;
      var total = articleHeight - viewportHeight;
      var percent;

      if (total <= 0) {
        percent = scrolled >= 0 ? 100 : 0;
      } else {
        percent = Math.max(0, Math.min(100, (scrolled / total) * 100));
      }

      progress.style.width = percent + '%';
      ticking = false;
    }

    window.addEventListener('scroll', function() {
      if (!ticking) {
        requestAnimationFrame(updateProgress);
        ticking = true;
      }
    }, { passive: true });

    updateProgress();
  }

  // ──── Mobile Sidebar Toggle ────

  function initMobileNav() {
    var sidebar = document.querySelector('.writing-sidebar');
    if (!sidebar) return;

    // Create toggle regardless of viewport so it exists when resizing
    var existing = sidebar.querySelector('.writing-sidebar__toggle');
    if (!existing) {
      var toggle = document.createElement('button');
      toggle.className = 'writing-sidebar__toggle';
      toggle.textContent = 'All Articles';
      toggle.setAttribute('aria-expanded', 'false');

      toggle.addEventListener('click', function() {
        var isOpen = sidebar.classList.toggle('writing-sidebar--open');
        toggle.setAttribute('aria-expanded', String(isOpen));
      });

      sidebar.insertBefore(toggle, sidebar.firstChild);
    }

    // Sync nav state on resize
    var resizeTimer;
    window.addEventListener('resize', function() {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function() {
        syncMobileNav(sidebar);
      }, 150);
    });

    // Initial sync
    syncMobileNav(sidebar);
  }

  function syncMobileNav(sidebar) {
    var toggle = sidebar.querySelector('.writing-sidebar__toggle');
    var isMobile = window.innerWidth < 1040;

    if (toggle) {
      toggle.style.display = isMobile ? '' : 'none';
    }

    if (!isMobile) {
      // Desktop: ensure nav is visible
      sidebar.classList.remove('writing-sidebar--open');
      if (toggle) {
        toggle.setAttribute('aria-expanded', 'false');
      }
    }
  }

  // ──── Archive Reading Times ────

  function initArchiveReadingTimes() {
    var items = document.querySelectorAll('.writing-archive__item article');
    for (var i = 0; i < items.length; i++) {
      var text = items[i].textContent || '';
      var words = text.trim().split(/\s+/).length;
      var minutes = Math.ceil(words / 200);

      var timeEl = items[i].querySelector('.reading-time');
      if (timeEl && !timeEl.textContent) {
        timeEl.textContent = minutes + ' min read';
      }
    }
  }

  // ──── Hide Empty State When Articles Exist ────

  function checkEmptyState() {
    var articles = document.querySelectorAll('.writing-archive__item');
    var empty = document.querySelector('.writing-empty');
    if (!empty) return;

    if (articles.length > 0) {
      empty.style.display = 'none';
    }
  }

  // ──── Initialize ────

  document.addEventListener('DOMContentLoaded', function() {
    calculateReadingTime();
    initProgressBar();
    initMobileNav();
    initArchiveReadingTimes();
    checkEmptyState();
  });
})();
