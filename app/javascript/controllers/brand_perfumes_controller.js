import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
static targets = ["brandName", "brandImage", "brandSlogan", "perfumesGrid", "pagination"];
static values = { brandId: Number }; // Pour récupérer l'ID de la marque depuis le HTML

allPerfumes = [];
currentPage = 1;
perfumesPerPage = 12; // Nombre de parfums à afficher par page, ajustez si besoin

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
    this.allPerfumes = data.parfums || []; // Stocke tous les parfums pour la pagination client
    this.renderPerfumes(); // Affiche la première page de parfums
    this.renderPagination(); // Affiche les contrôles de pagination
  } catch (error) {
    console.error("Erreur lors de la récupération des parfums de la marque:", error);
    this.perfumesGridTarget.innerHTML = "<p class='error-message'>Impossible de charger les parfums. Veuillez réessayer plus tard.</p>";
    this.brandNameTarget.textContent = "Marque Inconnue";
    this.brandImageTarget.src = "/placeholder.svg?height=200&width=200";
    this.brandSloganTarget.textContent = "Une erreur est survenue lors du chargement.";
  }
}

renderBrandDetails(brand) {
  this.brandNameTarget.textContent = brand.name || "Marque Inconnue";
  this.brandImageTarget.src = brand.image_url || "/placeholder.svg?height=200&width=200";
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
            <p class="perfume-description">${this.truncateText(perfume.description, 100)}</p>
            <div class="perfume-meta">
              <span class="perfume-category">${perfume.category ? perfume.category.charAt(0).toUpperCase() + perfume.category.slice(1) : ''}</span>
              <span class="perfume-class">${perfume.fragrance_class ? perfume.fragrance_class.charAt(0).toUpperCase() + perfume.fragrance_class.slice(1) : ''}</span>
            </div>
            <p class="perfume-price">${this.formatCurrency(perfume.prix)}</p>
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
        <div class="perfume-volume">10ml</div>
        <div class="perfume-availability-badge ${availabilityClass}">${availabilityStatus}</div>
      </div>
    `;
  }).join('');

  this.perfumesGridTarget.innerHTML = perfumeHtml;
}

renderPagination() {
  const totalPages = Math.ceil(this.allPerfumes.length / this.perfumesPerPage);
  if (totalPages <= 1) {
    this.paginationTarget.innerHTML = ''; // Cache la pagination s'il n'y a qu'une seule page
    return;
  }

  let paginationHtml = '<ul class="pagination">';

  // Bouton Précédent
  paginationHtml += `
    <li class="page-item ${this.currentPage === 1 ? 'disabled' : ''}">
      <a href="#" data-action="click->brand-perfumes#previousPage" class="page-link">Précédent</a>
    </li>
  `;

  // Numéros de page
  for (let i = 1; i <= totalPages; i++) {
    paginationHtml += `
      <li class="page-item ${this.currentPage === i ? 'current' : ''}">
        <a href="#" data-action="click->brand-perfumes#goToPage" data-page="${i}" class="page-link">${i}</a>
      </li>
    `;
  }

  // Bouton Suivant
  paginationHtml += `
    <li class="page-item ${this.currentPage === totalPages ? 'disabled' : ''}">
      <a href="#" data-action="click->brand-perfumes#nextPage" class="page-link">Suivant</a>
    </li>
  `;

  paginationHtml += '</ul>';
  this.paginationTarget.innerHTML = paginationHtml;
}

// Actions de pagination
previousPage(event) {
  event.preventDefault();
  if (this.currentPage > 1) {
    this.currentPage--;
    this.renderPerfumes();
    this.renderPagination();
    window.scrollTo({ top: 0, behavior: 'smooth' }); // Remonte en haut de page
  }
}

nextPage(event) {
  event.preventDefault();
  const totalPages = Math.ceil(this.allPerfumes.length / this.perfumesPerPage);
  if (this.currentPage < totalPages) {
    this.currentPage++;
    this.renderPerfumes();
    this.renderPagination();
    window.scrollTo({ top: 0, behavior: 'smooth' }); // Remonte en haut de page
  }
}

goToPage(event) {
  event.preventDefault();
  const page = parseInt(event.currentTarget.dataset.page);
  if (page && page !== this.currentPage) {
    this.currentPage = page;
    this.renderPerfumes();
    this.renderPagination();
    window.scrollTo({ top: 0, behavior: 'smooth' }); // Remonte en haut de page
  }
}

// Fonctions utilitaires
formatCurrency(amount) {
  // Assurez-vous que 'prix' est un nombre valide
  const num = parseFloat(amount);
  if (isNaN(num)) return amount; // Retourne tel quel si ce n'est pas un nombre
  // Changement ici : 'TND' pour le Dinar Tunisien
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
