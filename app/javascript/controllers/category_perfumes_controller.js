import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["categoryTitle", "categorySlogan", "perfumesGrid", "pagination", "dynamicFilterLabel", "dynamicFilterDropdown", "priceFilter"];
  static values = { filterType: String, filterValue: String };

  allRawPerfumes = []; // Stores all perfumes fetched from the API
  filteredAndSortedPerfumes = []; // Stores perfumes after applying all filters and sorting
  currentPage = 1;
  perfumesPerPage = 12;
  currentSecondaryFilterType = ''; // 'category' (for gender) or 'fragrance_class'
  currentSecondaryFilterValue = ''; // 'all_genders', 'homme', 'designer', etc.
  currentPriceSort = 'none';

  connect() {
    console.log(`Category Perfumes controller connected. Primary Filter Type: ${this.filterTypeValue}, Value: ${this.filterValueValue}`);
    this.updateHeaderContent();
    this.fetchPerfumes();
    this.setupDynamicFilter(); // Setup the dynamic dropdown based on primary filter
  }

  updateHeaderContent() {
    let titleText = '';
    let sloganText = '';
    const filterValueLower = this.filterValueValue.toLowerCase();

    if (this.filterTypeValue === 'category') {
      titleText = `Parfums ${this.capitalizeFirstLetter(filterValueLower)}`;
      sloganText = `Découvrez notre sélection de parfums pour ${filterValueLower}.`;
    } else if (this.filterTypeValue === 'fragrance_class') {
      titleText = `Parfums ${this.capitalizeFirstLetter(filterValueLower.replace('_', ' '))}`;
      sloganText = `Explorez l'univers des parfums de classe ${filterValueLower.replace('_', ' ')}.`;
    } else {
      titleText = "Parfums";
      sloganText = "Découvrez toutes nos fragrances.";
    }

    this.categoryTitleTarget.textContent = titleText;
    this.categorySloganTarget.textContent = sloganText;
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
      this.categoryTitleTarget.textContent = "Erreur de chargement";
      this.categorySloganTarget.textContent = "Une erreur est survenue lors du chargement des parfums.";
    }
  }

  setupDynamicFilter() {
    if (this.filterTypeValue === 'category') { // Primary filter is by gender (e.g., Homme, Femme)
      this.dynamicFilterLabelTarget.textContent = "Filtrer par classe :";
      this.dynamicFilterDropdownTarget.innerHTML = `
        <option value="all_classes">Toutes les classes</option>
        <option value="designer">Designer</option>
        <option value="niche">Niche</option>
        <option value="collection_privee">Collection Privée</option>
      `;
      this.currentSecondaryFilterType = 'fragrance_class';
      this.currentSecondaryFilterValue = 'all_classes'; // Default for this dropdown
    } else if (this.filterTypeValue === 'fragrance_class') { // Primary filter is by class (e.g., Designer, Niche)
      this.dynamicFilterLabelTarget.textContent = "Filtrer par genre :";
      this.dynamicFilterDropdownTarget.innerHTML = `
        <option value="all_genders">Tous les genres</option>
        <option value="homme">Homme</option>
        <option value="femme">Femme</option>
        <option value="unisexe">Unisexe</option>
      `;
      this.currentSecondaryFilterType = 'category';
      this.currentSecondaryFilterValue = 'all_genders'; // Default for this dropdown
    }
    // You might want to set the dropdown's value if it was previously selected (e.g., browser back button)
    // For simplicity, it resets to 'all' or 'all_classes' on page load for now.
  }

  filterPerfumes(event) {
    // This method is called when either the dynamic filter or price filter changes
    if (event.currentTarget === this.dynamicFilterDropdownTarget) {
      this.currentSecondaryFilterValue = event.target.value;
    } else if (event.currentTarget === this.priceFilterTarget) {
      this.currentPriceSort = event.target.value;
    }
    this.applyFiltersAndSortAndRender();
  }

  applyFiltersAndSortAndRender() {
    console.log("--- applyFiltersAndSortAndRender called ---");
    console.log("Raw perfumes count:", this.allRawPerfumes.length);
    console.log("Primary filter type (from URL):", this.filterTypeValue, "value:", this.filterValueValue);

    let tempPerfumes = [...this.allRawPerfumes]; // Create a mutable copy

    // 1. Apply primary filter from URL (gender or fragrance class)
    tempPerfumes = tempPerfumes.filter(perfume => {
      const perfumeCategoryLower = perfume.category ? perfume.category.toLowerCase() : '';
      const perfumeFragranceClassLower = perfume.fragrance_class ? perfume.fragrance_class.toLowerCase() : '';
      const urlFilterValueLower = this.filterValueValue.toLowerCase();

      if (this.filterTypeValue === 'category') {
        return perfumeCategoryLower === urlFilterValueLower;
      } else if (this.filterTypeValue === 'fragrance_class') {
        return perfumeFragranceClassLower === urlFilterValueLower;
      }
      return true; // Should not happen if filterType is always set
    });
    console.log("Perfumes after primary URL filter:", tempPerfumes.length);

    // 2. Apply secondary filter from dynamic dropdown (gender or fragrance class, depending on primary)
    if (this.currentSecondaryFilterType === 'category' && this.currentSecondaryFilterValue !== 'all_genders') {
      tempPerfumes = tempPerfumes.filter(perfume => {
        const perfumeCategoryLower = perfume.category ? perfume.category.toLowerCase() : '';
        return perfumeCategoryLower === this.currentSecondaryFilterValue;
      });
      console.log("Perfumes after secondary gender filter:", tempPerfumes.length);
    } else if (this.currentSecondaryFilterType === 'fragrance_class' && this.currentSecondaryFilterValue !== 'all_classes') {
      tempPerfumes = tempPerfumes.filter(perfume => {
        const perfumeFragranceClassLower = perfume.fragrance_class ? perfume.fragrance_class.toLowerCase() : '';
        return perfumeFragranceClassLower === this.currentSecondaryFilterValue;
      });
      console.log("Perfumes after secondary class filter:", tempPerfumes.length);
    }

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
    console.log("--- Rendering complete ---");
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
        <a href="#" data-action="click->category-perfumes#previousPage" class="page-link">Précédent</a>
      </li>
    `;
    for (let i = 1; i <= totalPages; i++) {
      paginationHtml += `
        <li class="page-item ${this.currentPage === i ? 'current' : ''}">
          <a href="#" data-action="click->category-perfumes#goToPage" data-page="${i}" class="page-link">${i}</a>
      </li>
      `;
    }
    paginationHtml += `
      <li class="page-item ${this.currentPage === totalPages ? 'disabled' : ''}">
        <a href="#" data-action="click->category-perfumes#nextPage" class="page-link">Suivant</a>
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
