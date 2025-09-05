import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["brandName", "brandImage", "brandSlogan", "perfumesGrid", "pagination"];
  static values = { brandId: Number };

  allPerfumes = [];
  currentPage = 1;
  perfumesPerPage = 12;

  connect() {
    console.log("Brand Perfumes controller connecté pour la marque ID:", this.brandIdValue);
    this.fetchBrandPerfumes();
  }

  async fetchBrandPerfumes() {
    const apiUrl = `/api/v1/brands/${this.brandIdValue}`;

    try {
      const response = await fetch(apiUrl);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      
      this.renderBrandDetails(data);
      this.allPerfumes = data.parfums || [];
      this.renderPerfumes();
      this.renderPagination();
    } catch (error) {
      console.error("Erreur lors de la récupération des parfums de la marque:", error);
      this.perfumesGridTarget.innerHTML = "<p class='error-message'>Impossible de charger les parfums. Veuillez réessayer plus tard.</p>";
      this.brandNameTarget.textContent = "Marque Inconnue";
      this.brandImageTarget.src = "https://via.placeholder.com/200x200?text=Marque";
      this.brandSloganTarget.textContent = "Une erreur est survenue lors du chargement.";
    }
  }

  renderBrandDetails(brand) {
    this.brandNameTarget.textContent = brand.name || "Marque Inconnue";
    this.brandImageTarget.src = brand.image_url || "https://via.placeholder.com/200x200?text=Marque";
    this.brandImageTarget.alt = `${brand.name} Logo`;
    this.brandSloganTarget.textContent = `Découvrez l'essence de ${brand.name} à travers nos décants exclusifs.`;
  }

  renderPerfumes() {
    const startIndex = (this.currentPage - 1) * this.perfumesPerPage;
    const endIndex = startIndex + this.perfumesPerPage;
    const perfumesToDisplay = this.allPerfumes.slice(startIndex, endIndex);

    if (perfumesToDisplay.length === 0) {
      this.perfumesGridTarget.innerHTML = "<p class='no-perfumes-message'>Aucun parfum trouvé pour cette marque pour le moment.</p>";
      return;
    }

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
              <p class="perfume-description">${this.truncateText(perfume.description, 100)}</p>
              <div class="perfume-meta">
                <span class="perfume-category">${perfume.category ? this.capitalizeFirstLetter(perfume.category) : ''}</span>
                <span class="perfume-class">${perfume.fragrance_class ? this.capitalizeFirstLetter(perfume.fragrance_class) : ''}</span>
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
    const totalPages = Math.ceil(this.allPerfumes.length / this.perfumesPerPage);
    if (totalPages <= 1) {
      this.paginationTarget.innerHTML = '';
      return;
    }

    let paginationHtml = '<ul class="pagination">';
    paginationHtml += `
      <li class="page-item ${this.currentPage === 1 ? 'disabled' : ''}">
        <a href="#" data-action="click->brand-perfumes#previousPage" class="page-link">Précédent</a>
      </li>
    `;
    for (let i = 1; i <= totalPages; i++) {
      paginationHtml += `
        <li class="page-item ${this.currentPage === i ? 'current' : ''}">
          <a href="#" data-action="click->brand-perfumes#goToPage" data-page="${i}" class="page-link">${i}</a>
        </li>
      `;
    }
    paginationHtml += `
      <li class="page-item ${this.currentPage === totalPages ? 'disabled' : ''}">
        <a href="#" data-action="click->brand-perfumes#nextPage" class="page-link">Suivant</a>
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
    const totalPages = Math.ceil(this.allPerfumes.length / this.perfumesPerPage);
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

  capitalizeFirstLetter(string) {
    if (!string) return '';
    return string.charAt(0).toUpperCase() + string.slice(1);
  }
}