import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["pageTitle", "pageSlogan", "perfumesGrid", "pagination", "genderFilter", "classFilter", "priceFilter"];

  allRawPerfumes = []; // Stores all perfumes fetched from the API
  filteredAndSortedPerfumes = []; // Stores perfumes after applying all filters and sorting
  currentPage = 1;
  perfumesPerPage = 12; // Number of perfumes to display per page

  currentGenderFilter = 'all_genders';
  currentClassFilter = 'all_classes';
  currentPriceSort = 'none';

  connect() {
    console.log("All Perfumes controller connected!");
    this.fetchPerfumes();
  }

  async fetchPerfumes() {
    const apiUrl = `/api/v1/parfums`;

    try {
      const response = await fetch(apiUrl);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      this.allRawPerfumes = data; // Store all unfiltered perfumes

      this.applyFiltersAndSortAndRender(); // Apply filters and render display
    } catch (error) {
      console.error("Error fetching perfumes:", error);
      this.perfumesGridTarget.innerHTML = "<p class='error-message'>Impossible de charger les parfums. Veuillez réessayer plus tard.</p>";
      this.pageTitleTarget.textContent = "Erreur de chargement";
      this.pageSloganTarget.textContent = "Une erreur est survenue lors du chargement des parfums.";
    }
  }

  filterPerfumes(event) {
    // This method is called when any filter dropdown changes
    if (event.currentTarget === this.genderFilterTarget) {
      this.currentGenderFilter = event.target.value;
    } else if (event.currentTarget === this.classFilterTarget) {
      this.currentClassFilter = event.target.value;
    } else if (event.currentTarget === this.priceFilterTarget) {
      this.currentPriceSort = event.target.value;
    }
    this.applyFiltersAndSortAndRender();
  }

  applyFiltersAndSortAndRender() {
    console.log("--- applyFiltersAndSortAndRender called for All Perfumes ---");
    let tempPerfumes = [...this.allRawPerfumes]; // Create a mutable copy

    // 1. Apply Gender filter
    if (this.currentGenderFilter !== 'all_genders') {
      tempPerfumes = tempPerfumes.filter(perfume => {
        const perfumeCategoryLower = perfume.category ? perfume.category.toLowerCase() : '';
        return perfumeCategoryLower === this.currentGenderFilter;
      });
    }
    console.log("Perfumes after gender filter:", tempPerfumes.length);

    // 2. Apply Class filter
    if (this.currentClassFilter !== 'all_classes') {
      tempPerfumes = tempPerfumes.filter(perfume => {
        const perfumeFragranceClassLower = perfume.fragrance_class ? perfume.fragrance_class.toLowerCase() : '';
        return perfumeFragranceClassLower === this.currentClassFilter;
      });
    }
    console.log("Perfumes after class filter:", tempPerfumes.length);

    // 3. Apply price sort
    if (this.currentPriceSort === 'asc') {
      tempPerfumes.sort((a, b) => a.prix - b.prix);
    } else if (this.currentPriceSort === 'desc') {
      tempPerfumes.sort((a, b) => b.prix - a.prix);
    }
    console.log("Perfumes after price sort:", tempPerfumes.length);

    this.filteredAndSortedPerfumes = tempPerfumes;
    this.currentPage = 1; // Reset to first page after any filter/sort change

    if (this.filteredAndSortedPerfumes.length === 0) {
      this.perfumesGridTarget.innerHTML = "<p class='no-perfumes-message'>Aucun parfum trouvé pour cette sélection pour le moment.</p>";
      this.paginationTarget.innerHTML = '';
      return;
    }

    this.renderPerfumes();
    this.renderPagination();
    console.log("--- Rendering complete for All Perfumes ---");
  }

  renderPerfumes() {
    const startIndex = (this.currentPage - 1) * this.perfumesPerPage;
    const endIndex = startIndex + this.perfumesPerPage;
    const perfumesToDisplay = this.filteredAndSortedPerfumes.slice(startIndex, endIndex);

    const perfumeHtml = perfumesToDisplay.map(perfume => {
      const imageUrl = perfume.image_url || "/placeholder.svg?height=250&width=250&text=Parfum";
      const availabilityStatus = perfume.disponible ? 'Disponible' : 'Rupture de stock';
      const availabilityClass = perfume.disponible ? 'perfume-availability-badge--available' : 'perfume-availability-badge--unavailable';

      return `
        <div class="perfume-card">
          <a href="/vitrine/parfums/${perfume.id}" class="perfume-card-link">
            <div class="perfume-image-wrapper">
              <img src="${imageUrl}" alt="${perfume.name}" class="perfume-image">
              <div class="image-overlay"></div>
            </div>
            <div class="perfume-content">
              <h3 class="perfume-name">${perfume.name}</h3>
              <p class="perfume-brand">${perfume.brand ? perfume.brand.name : 'Inconnue'}</p>
              <p class="perfume-description">${this.truncateText(perfume.description, 100)}</p>
              <div class="perfume-meta">
                <span class="perfume-category">${perfume.category ? this.capitalizeFirstLetter(perfume.category) : ''}</span>
                <span class="perfume-class">${perfume.fragrance_class ? this.capitalizeFirstLetter(perfume.fragrance_class) : ''}</span>
              </div>
              <p class="perfume-price">${this.formatCurrency(perfume.prix)}</p>
              <div class="perfume-volume">10ml</div>
              <div class="perfume-card-actions">
                <button
                  class="perfume-card-add-to-cart-btn"
                  data-action="click->cart#addToCart"
                  data-parfum-id="${perfume.id}"
                  data-parfum-name="${perfume.name}"
                  data-parfum-price="${perfume.prix}"
                  data-parfum-image-url="${imageUrl}"
                  ${!perfume.disponible ? 'disabled' : ''}
                >
                  Ajouter au panier
                </button>
              </div>
            </div>
          </a>
          <div class="perfume-availability-badge ${availabilityClass}">${availabilityStatus}</div>
        </div>
      `;
    }).join('');

    this.perfumesGridTarget.innerHTML = perfumeHtml;
  }

  renderPagination() {
    const totalPages = Math.ceil(this.filteredAndSortedPerfumes.length / this.perfumesPerPage);
    if (totalPages <= 1) {
      this.paginationTarget.innerHTML = '';
      return;
    }

    let paginationHtml = '<ul class="pagination">';
    paginationHtml += `
      <li class="page-item ${this.currentPage === 1 ? 'disabled' : ''}">
        <a href="#" data-action="click->all-perfumes#previousPage" class="page-link">Précédent</a>
      </li>
    `;
    for (let i = 1; i <= totalPages; i++) {
      paginationHtml += `
        <li class="page-item ${this.currentPage === i ? 'current' : ''}">
          <a href="#" data-action="click->all-perfumes#goToPage" data-page="${i}" class="page-link">${i}</a>
      </li>
      `;
    }
    paginationHtml += `
      <li class="page-item ${this.currentPage === totalPages ? 'disabled' : ''}">
        <a href="#" data-action="click->all-perfumes#nextPage" class="page-link">Suivant</a>
      </li>
    `;
    paginationHtml += '</ul>';
    this.paginationTarget.innerHTML = paginationHtml;
  }

  previousPage(event) {
    event.preventDefault();
    if (this.currentPage > 1) {
      this.currentPage--;
      this.renderPerfumes();
      this.renderPagination();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }

  nextPage(event) {
    event.preventDefault();
    const totalPages = Math.ceil(this.filteredAndSortedPerfumes.length / this.perfumesPerPage);
    if (this.currentPage < totalPages) {
      this.currentPage++;
      this.renderPerfumes();
      this.renderPagination();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }

  goToPage(event) {
    event.preventDefault();
    const page = parseInt(event.currentTarget.dataset.page);
    if (page && page !== this.currentPage) {
      this.currentPage = page;
      this.renderPerfumes();
      this.renderPagination();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }

  formatCurrency(amount) {
    const num = parseFloat(amount);
    if (isNaN(num)) return amount;
    return new Intl.NumberFormat('fr-TN', { style: 'currency', currency: 'TND' }).format(num);
  }

  truncateText(text, maxLength) {
    if (!text || text.length <= maxLength) {
      return text;
    }
    return text.substring(0, maxLength) + '...';
  }

  capitalizeFirstLetter(string) {
    if (!string) return '';
    return string.charAt(0).toUpperCase() + string.slice(1);
  }
}
