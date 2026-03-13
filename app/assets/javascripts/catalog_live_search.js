(function () {
  function debounce(fn, wait) {
    let timeout;
    return function () {
      const context = this;
      const args = arguments;
      clearTimeout(timeout);
      timeout = setTimeout(function () {
        fn.apply(context, args);
      }, wait);
    };
  }

  function initLiveSearch() {
    const form = document.getElementById("catalog-search-form");
    const input = document.getElementById("catalog-search-input");

    if (!form || !input) return;

    const doSearch = debounce(function () {
      const url = new URL(form.action, window.location.origin);
      const formData = new FormData(form);

      url.searchParams.delete("producto");
      url.searchParams.delete("categoria");
      url.searchParams.delete("marca");
      url.searchParams.delete("page");

      formData.forEach(function (value, key) {
        if (value !== null && String(value).trim() !== "") {
          url.searchParams.set(key, value);
        }
      });

      fetch(url.toString(), {
        headers: {
          "X-Requested-With": "XMLHttpRequest"
        },
        credentials: "same-origin"
      })
        .then(function (response) {
          return response.text();
        })
        .then(function (html) {
          const oldResults = document.getElementById("catalog-results");
          if (!oldResults) return;

          oldResults.outerHTML = html;
          window.history.replaceState({}, "", url.toString());
        })
        .catch(function (error) {
          console.error("Error en búsqueda en tiempo real:", error);
        });
    }, 300);

    input.addEventListener("input", doSearch);

    const category = document.getElementById("catalog-category");
    const brand = document.getElementById("catalog-brand");

    if (category) {
      category.addEventListener("change", doSearch);
    }

    if (brand) {
      brand.addEventListener("change", doSearch);
    }
  }

  document.addEventListener("turbolinks:load", initLiveSearch);
  document.addEventListener("DOMContentLoaded", initLiveSearch);
})();