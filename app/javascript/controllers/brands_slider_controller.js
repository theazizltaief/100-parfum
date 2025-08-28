import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["track"];

  connect() {
    console.log("Brands Slider controller connecté");
    this.fetchBrands();
  }

  async fetchBrands() {
    const apiUrl = "/api/v1/brands_only"; // Votre endpoint API

    try {
      const response = await fetch(apiUrl);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const brands = await response.json();
      this.renderBrands(brands);
    } catch (error) {
      console.error("Erreur lors de la récupération des marques:", error);
      this.trackTarget.innerHTML = "<p style='color: #cc0000; text-align: center; width: 100%;'>Impossible de charger les marques. Veuillez réessayer plus tard.</p>";
    }
  }

  renderBrands(brands) {
    if (!brands || brands.length === 0) {
      this.trackTarget.innerHTML = "<p style='color: #666; text-align: center; width: 100%;'>Aucune marque à afficher pour le moment.</p>";
      return;
    }

    const duplicatedBrands = [...brands, ...brands]; 

    const brandHtml = duplicatedBrands.map(brand => `
      <a href="/vitrine/brands/${brand.id}" class="brand-logo-item-link">
        <div class="brand-logo-item">
          <img src="${brand.image_url}" alt="${brand.name}" />
        </div>
      </a>
    `).join('');

    this.trackTarget.innerHTML = brandHtml;
  }
}