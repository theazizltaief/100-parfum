import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["wrapper", "inputArea", "input", "results", "perfumeResults", "brandResults"];
  static values = { open: Boolean };

  connect() {
    console.log("Search controller connected!");
    if (this.openValue === undefined || this.openValue === null) {
      this.openValue = false;
    }
    this.debounceTimeout = null;
    if (this.openValue && window.innerWidth <= 768) {
      this._openUI();
      if (this.hasInputTarget) {
        this.inputTarget.focus();
      }
    }
  }

  _openUI() {
    if (this.hasWrapperTarget) this.wrapperTarget.classList.add("is-open");
    if (this.hasInputAreaTarget) this.inputAreaTarget.classList.add("is-open");
  }

  _closeUI() {
    if (this.hasWrapperTarget) this.wrapperTarget.classList.remove("is-open");
    if (this.hasInputAreaTarget) this.inputAreaTarget.classList.remove("is-open");
  }

  toggle() {
    this.openValue = !this.openValue;
    if (this.openValue) {
      this._openUI();
      if (this.hasInputTarget) this.inputTarget.focus();
    } else {
      this._closeUI();
      this.clear();
    }
  }

  close() {
    this.openValue = false;
    this._closeUI();
    this.clear();
  }

  search() {
    clearTimeout(this.debounceTimeout);
    this.debounceTimeout = setTimeout(() => {
      const query = this.hasInputTarget ? this.inputTarget.value.trim() : "";
      console.log("Search query:", query);
      if (query.length > 2) {
        this.fetchResults(query);
      } else {
        this.clearResults();
      }
    }, 300);
  }

  async fetchResults(query) {
    try {
      const url = `/api/v1/search?query=${encodeURIComponent(query)}`;
      console.log("Fetching from URL:", url);
      const response = await fetch(url);
      if (!response.ok) {
        const errorText = await response.text();
        console.error(`HTTP error! Status: ${response.status}, Response: ${errorText}`);
        if (this.hasResultsTarget) {
          this.resultsTarget.innerHTML = `<p class='inline-search-error-message'>Une erreur est survenue lors de la recherche: ${response.status}</p>`;
          this.resultsTarget.classList.add('is-open');
        }
        return;
      }
      const data = await response.json();
      console.log("Received data:", data);
      this.displayResults(data);
    } catch (error) {
      console.error("Erreur lors de la recherche (connexion ou parsing):", error);
      if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = "<p class='inline-search-error-message'>Une erreur est survenue lors de la recherche (connexion ou données).</p>";
        this.resultsTarget.classList.add('is-open');
      }
    }
  }

  displayResults(data) {
    let perfumeHtml = '';
    let brandHtml = '';

    if (data.perfumes && data.perfumes.length > 0) {
      perfumeHtml += '<h3>Parfums</h3><div class="inline-search-results-grid">';
      perfumeHtml += data.perfumes.map(perfume => {
        const imageUrl = perfume.image_url || "https://via.placeholder.com/50x50?text=P";
        const validVariants = perfume.variants && perfume.variants.length > 0 
          ? perfume.variants.filter(v => v.price && parseFloat(v.price) > 0)
          : [{ size: 'N/A', price: 0 }];
        const defaultVariant = validVariants.length > 0 ? validVariants[0] : { size: 'N/A', price: 0 };
        const safePrice = parseFloat(defaultVariant.price) || 0;
        const safeSize = defaultVariant.size || 'N/A';

        return `
          <a href="/vitrine/parfums/${perfume.id}" class="inline-search-result-item">
            <img src="${imageUrl}" alt="${perfume.name}" class="inline-search-result-image">
            <div class="inline-search-result-info">
              <h4>${perfume.name}</h4>
              <p>${this.truncateText(perfume.description, 50)}</p>
              <p class="search-result-price">${this.formatCurrency(safePrice)}</p>
              <p class="search-result-volume">${safeSize}</p>
            </div>
          </a>
        `;
      }).join('');
      perfumeHtml += '</div>';
    } else {
      perfumeHtml = '<p class="inline-search-no-results-message">Aucun parfum trouvé.</p>';
    }

    if (data.brands && data.brands.length > 0) {
      brandHtml += '<h3>Marques</h3><div class="inline-search-results-grid">';
      brandHtml += data.brands.map(brand => `
        <a href="/vitrine/brands/${brand.id}" class="inline-search-result-item">
          <img src="${brand.image_url || 'https://via.placeholder.com/50x50?text=M'}" alt="${brand.name} Logo" class="inline-search-result-image">
          <div class="inline-search-result-info">
            <h4>${brand.name}</h4>
            ${brand.description ? `<p>${this.truncateText(brand.description, 50)}</p>` : ""}
          </div>
        </a>
      `).join('');
      brandHtml += '</div>';
    } else {
      brandHtml = '<p class="inline-search-no-results-message">Aucune marque trouvée.</p>';
    }

    if (this.hasPerfumeResultsTarget) this.perfumeResultsTarget.innerHTML = perfumeHtml;
    if (this.hasBrandResultsTarget) this.brandResultsTarget.innerHTML = brandHtml;

    if (this.hasResultsTarget) {
      if (this.hasInputTarget && this.inputTarget.value.length > 0) {
        this.resultsTarget.classList.add('is-open');
      } else {
        this.resultsTarget.classList.remove('is-open');
      }
    }
  }

  clearResults() {
    if (this.hasPerfumeResultsTarget) this.perfumeResultsTarget.innerHTML = '';
    if (this.hasBrandResultsTarget) this.brandResultsTarget.innerHTML = '';
    if (this.hasResultsTarget) this.resultsTarget.classList.remove('is-open');
  }

  clear() {
    if (this.hasInputTarget) this.inputTarget.value = '';
    this.clearResults();
  }

  formatCurrency(amount) {
    const num = parseFloat(amount) || 0;
    return new Intl.NumberFormat('fr-TN', { style: 'currency', currency: 'TND' }).format(num);
  }

  truncateText(text, maxLength) {
    if (!text || text.length <= maxLength) {
      return text || '';
    }
    return text.substring(0, maxLength) + '...';
  }
}