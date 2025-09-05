import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["categoryTitle", "categorySlogan", "perfumesGrid", "pagination", "dynamicFilterDropdown", "priceFilter", "dynamicFilterLabel"];
  static values = {
    filterType: String,
    filterValue: String
  };

  allRawPerfumes = [];
  filteredAndSortedPerfumes = [];
  currentPage = 1;
  perfumesPerPage = 12;
  currentClassFilter = 'all_classes';
  currentPriceSort = 'none';

  connect() {
    console.log(`Category Perfumes controller connected. Filter Type: ${this.filterTypeValue}, Value: ${this.filterValueValue}`);
    this.populateFilterOptions();
    this.updateTitleAndSlogan();
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
      this.allRawPerfumes = data.map(perfume => {
        const validVariants = perfume.variants && perfume.variants.length > 0 
          ? perfume.variants.filter(v => v.price && parseFloat(v.price) > 0)
          : [{ size: 'N/A', price: 0 }];
        return {
          ...perfume,
          min_price: validVariants.length > 0 ? Math.min(...validVariants.map(v => parseFloat(v.price))) : 0
        };
      });
      console.log("Fetched perfumes:", this.allRawPerfumes.length);
      this.applyFiltersAndSortAndRender();
    } catch (error) {
      console.error("Error fetching perfumes:", error);
      this.perfumesGridTarget.innerHTML = "<p class='error-message'>Impossible de charger les parfums. Veuillez réessayer plus tard.</p>";
      if (this.hasCategoryTitleTarget) this.categoryTitleTarget.textContent = "Erreur de chargement";
      if (this.hasCategorySloganTarget) this.categorySloganTarget.textContent = "Une erreur est survenue lors du chargement des parfums.";
    }
  }

  populateFilterOptions() {
    console.log("Populating filter options...");
    if (this.hasDynamicFilterDropdownTarget && this.dynamicFilterDropdownTarget.options.length <= 1) {
      const classOptions = [
        { value: 'all_classes', label: 'Toutes les classes' },
        { value: 'designer', label: 'Designer' },
        { value: 'niche', label: 'Niche' },
        { value: 'collection_privee', label: 'Collection Privée' }
      ];
      this.dynamicFilterDropdownTarget.innerHTML = classOptions.map(opt => 
        `<option value="${opt.value}" ${opt.value === this.currentClassFilter ? 'selected' : ''}>${opt.label}</option>`
      ).join('');
      console.log("Class filter options populated:", classOptions.map(opt => opt.label));
    }

    if (this.hasDynamicFilterLabelTarget) {
      this.dynamicFilterLabelTarget.textContent = 'Filtrer par classe :';
      console.log("Dynamic filter label set to: Filtrer par classe");
    }
  }

  updateTitleAndSlogan() {
    if (!this.hasCategoryTitleTarget || !this.hasCategorySloganTarget) {
      console.warn("Missing categoryTitleTarget or categorySloganTarget in DOM");
      return;
    }

    let title = "Parfums";
    let slogan = "Découvrez notre sélection de fragrances exquises.";

    if (this.filterTypeValue && this.filterValueValue) {
      if (this.filterTypeValue === 'category') {
        title = `Parfums ${this.formatFilterValue(this.filterValueValue)}`;
        slogan = `Explorez nos parfums pour ${this.filterValueValue.toLowerCase()}.`;
      } else if (this.filterTypeValue === 'fragrance_class') {
        title = `Parfums ${this.formatFilterValue(this.filterValueValue)}`;
        slogan = `Découvrez notre collection de parfums ${this.formatFilterValue(this.filterValueValue).toLowerCase()}.`;
      }
    }

    console.log(`Updating title to: ${title}, slogan to: ${slogan}`);
    this.categoryTitleTarget.textContent = title;
    this.categorySloganTarget.textContent = slogan;
  }

  filterPerfumes(event) {
    if (event.currentTarget === this.dynamicFilterDropdownTarget) {
      this.currentClassFilter = event.target.value;
    } else if (event.currentTarget === this.priceFilterTarget) {
      this.currentPriceSort = event.target.value;
    }
    console.log(`Filters updated: class=${this.currentClassFilter}, priceSort=${this.currentPriceSort}`);
    this.applyFiltersAndSortAndRender();
  }

  applyFiltersAndSortAndRender() {
    console.log("--- applyFiltersAndSortAndRender called ---");
    console.log("Raw perfumes count:", this.allRawPerfumes.length);
    console.log(`Primary filter type (from URL): ${this.filterTypeValue}, value: ${this.filterValueValue}`);
    
    let tempPerfumes = [...this.allRawPerfumes];

    // Apply primary filter from URL
    if (this.filterTypeValue && this.filterValueValue) {
      if (this.filterTypeValue === 'category') {
        tempPerfumes = tempPerfumes.filter(perfume => {
          const perfumeCategoryLower = perfume.category ? perfume.category.toLowerCase() : '';
          return perfumeCategoryLower === this.filterValueValue.toLowerCase();
        });
      } else if (this.filterTypeValue === 'fragrance_class') {
        tempPerfumes = tempPerfumes.filter(perfume => {
          const perfumeFragranceClassLower = perfume.fragrance_class ? perfume.fragrance_class.toLowerCase() : '';
          return perfumeFragranceClassLower === this.filterValueValue.toLowerCase();
        });
      }
    }
    console.log("Perfumes after primary URL filter:", tempPerfumes.length);

    // Apply additional class filter
    if (this.currentClassFilter !== 'all_classes') {
      tempPerfumes = tempPerfumes.filter(perfume => {
        const perfumeFragranceClassLower = perfume.fragrance_class ? perfume.fragrance_class.toLowerCase() : '';
        return perfumeFragranceClassLower === this.currentClassFilter;
      });
    }
    console.log("Perfumes after class filter:", tempPerfumes.length);

    // Apply price sort
    if (this.currentPriceSort === 'asc') {
      tempPerfumes.sort((a, b) => (a.min_price || 0) - (b.min_price || 0));
    } else if (this.currentPriceSort === 'desc') {
      tempPerfumes.sort((a, b) => (b.min_price || 0) - (a.min_price || 0));
    }
    console.log("Perfumes after price sort:", tempPerfumes.length);

    this.filteredAndSortedPerfumes = tempPerfumes;
    this.currentPage = 1;

    if (this.filteredAndSortedPerfumes.length === 0) {
      this.perfumesGridTarget.innerHTML = "<p class='no-perfumes-message'>Aucun parfum trouvé pour cette sélection pour le moment.</p>";
      this.paginationTarget.innerHTML = '';
      if (this.hasCategoryTitleTarget) this.categoryTitleTarget.textContent = "Aucun résultat";
      if (this.hasCategorySloganTarget) this.categorySloganTarget.textContent = "Aucun parfum ne correspond à votre recherche.";
      return;
    }

    this.renderPerfumes();
    this.renderPagination();
    this.updateTitleAndSlogan();
    console.log("--- Rendering complete ---");
  }

  renderPerfumes() {
    const startIndex = (this.currentPage - 1) * this.perfumesPerPage;
    const endIndex = startIndex + this.perfumesPerPage;
    const perfumesToDisplay = this.filteredAndSortedPerfumes.slice(startIndex, endIndex);

    const perfumeHtml = perfumesToDisplay.map(perfume => {
      const imageUrl = perfume.image_url || "https://via.placeholder.com/250x250?text=Parfum";
      const availabilityStatus = perfume.disponible ? 'Disponible' : 'Rupture de stock';
      const availabilityClass = perfume.disponible ? 'perfume-availability-badge--available' : 'perfume-availability-badge--unavailable';
      const validVariants = perfume.variants && perfume.variants.length > 0 
        ? perfume.variants.filter(v => v.price && parseFloat(v.price) > 0)
        : [{ size: 'N/A', price: 0 }];
      const defaultVariant = validVariants.length > 0 ? validVariants[0] : { size: 'N/A', price: 0 };
      const safePrice = parseFloat(defaultVariant.price) || 0;
      const safeSize = defaultVariant.size || 'N/A';

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
                <span class="perfume-category">${perfume.category ? this.formatFilterValue(perfume.category) : ''}</span>
                <span class="perfume-class">${perfume.fragrance_class ? this.formatFilterValue(perfume.fragrance_class) : ''}</span>
              </div>
              <p class="perfume-price">${this.formatCurrency(safePrice)}</p>
              <div class="perfume-volume">${safeSize}</div>
              <div class="perfume-card-actions">
                <button
                  class="perfume-card-add-to-cart-btn"
                  data-action="click->cart#addToCart"
                  data-parfum-id="${perfume.id}"
                  data-parfum-name="${perfume.name}"
                  data-parfum-price="${safePrice}"
                  data-parfum-size="${safeSize}"
                  data-parfum-image-url="${imageUrl}"
                  ${!perfume.disponible || validVariants.length === 0 || safePrice <= 0 ? 'disabled' : ''}
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
    const num = parseFloat(amount) || 0;
    return new Intl.NumberFormat('fr-TN', { style: 'currency', currency: 'TND' }).format(num);
  }

  truncateText(text, maxLength) {
    if (!text || text.length <= maxLength) {
      return text || '';
    }
    return text.substring(0, maxLength) + '...';
  }

  formatFilterValue(value) {
    if (!value) return '';
    if (value.toLowerCase() === 'collection_privee') return 'Collection Privée';
    return value.charAt(0).toUpperCase() + value.slice(1);
  }
}