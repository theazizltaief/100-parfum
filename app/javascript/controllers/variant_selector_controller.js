import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "price"];

  connect() {
    if (this.hasSelectTarget) {
      this.updatePrice();
    }
  }

  updatePrice() {
    const selectedOption = this.selectTarget.options[this.selectTarget.selectedIndex];
    if (!selectedOption) return;

    const price = parseFloat(selectedOption.value) || 0;
    const size = selectedOption.dataset.size || 'N/A';

    this.priceTarget.textContent = new Intl.NumberFormat("fr-TN", { style: "currency", currency: "TND" }).format(price);

    const addButton = this.element.querySelector('.vitrine-parfum-detail-add-to-cart-btn');
    const buyButton = this.element.querySelector('.vitrine-parfum-detail-buy-now-btn');
    if (addButton) {
      addButton.dataset.parfumPrice = price;
      addButton.dataset.parfumSize = size;
      addButton.disabled = price <= 0 || size === 'N/A';
    }
    if (buyButton) {
      buyButton.dataset.parfumPrice = price;
      buyButton.dataset.parfumSize = size;
      buyButton.disabled = price <= 0 || size === 'N/A';
    }
  }
}