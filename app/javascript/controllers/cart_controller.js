import { Controller } from "@hotwired/stimulus";

function getCsrfToken() {
  const el = document.querySelector('meta[name="csrf-token"]');
  return el && el.content;
}

async function postJson(url, data) {
  return fetch(url, {
    method: 'POST',
    credentials: 'same-origin',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-CSRF-Token': getCsrfToken()
    },
    body: JSON.stringify(data)
  });
}

export default class extends Controller {
  static targets = [
    "overlay",
    "cartItems",
    "totalDisplay",
    "subtotalDisplay",
    "deliveryDisplay",
    "cartCount",
    "cartPageItems",
    "subtotalPageDisplay",
    "deliveryPageDisplay",
    "totalPageDisplay"
  ];

  static values = { open: Boolean };

  connect() {
    console.log("Cart controller connected!");
    this.openValue = false;
    this.loadCartFromLocalStorage();
    this.updateCartCount();
    if (window.location.pathname === "/vitrine/cart") {
      this.renderCartPageItems();
    }
    window.addEventListener('cart-updated', this.handleCartUpdate.bind(this));
  }

  disconnect() {
    window.removeEventListener('cart-updated', this.handleCartUpdate.bind(this));
  }

  handleCartUpdate() {
    this.loadCartFromLocalStorage();
    this.updateCartCount();
    if (this.hasOverlayTarget) {
      if (this.openValue) {
        this.renderCartSliderItems();
      } else {
        this.toggle();
      }
    }
    if (this.hasCartPageItemsTarget) {
      this.renderCartPageItems();
    }
  }

  toggle() {
    if (!this.hasOverlayTarget) {
      console.warn("Cart slider not available on this page");
      return;
    }
    this.openValue = !this.openValue;
    if (this.openValue) {
      this.overlayTarget.classList.add("is-open");
      this.renderCartSliderItems();
    } else {
      this.overlayTarget.classList.remove("is-open");
    }
  }

  close() {
    if (!this.hasOverlayTarget) return;
    this.openValue = false;
    this.overlayTarget.classList.remove("is-open");
  }

  loadCartFromLocalStorage() {
    try {
      const cartData = localStorage.getItem("cart");
      this.cartItems = cartData ? JSON.parse(cartData) : [];
    } catch (e) {
      console.error("Failed to load cart from localStorage:", e);
      this.cartItems = [];
    }
  }

  saveCartToLocalStorage() {
    try {
      localStorage.setItem("cart", JSON.stringify(this.cartItems));
    } catch (e) {
      console.error("Failed to save cart to localStorage:", e);
    }
  }

  addToCart(event) {
    event.preventDefault();
    event.stopPropagation();
    console.log("addToCart called", event.currentTarget);
    console.log("Dataset:", event.currentTarget.dataset);
    const parfumId = event.currentTarget.dataset.parfumId;
    const parfumName = event.currentTarget.dataset.parfumName;
    const parfumSize = event.currentTarget.dataset.parfumSize || 'N/A';
    const parfumPrice = parseFloat(event.currentTarget.dataset.parfumPrice) || 0;
    const parfumImageUrl = event.currentTarget.dataset.parfumImageUrl || "/placeholder.svg?height=50&width=50&text=P";

    console.log("Attempting to add to cart:", { parfumId, parfumName, parfumSize, parfumPrice, parfumImageUrl });

    if (!parfumId || !parfumName || parfumPrice <= 0 || parfumSize === 'N/A') {
      console.error("Missing or invalid parfum data for adding to cart:", { parfumId, parfumName, parfumPrice, parfumSize });
      alert("Veuillez sélectionner une contenance valide avec un prix supérieur à 0.");
      return;
    }

    const itemKey = `${parfumId}-${parfumSize}`;
    const existingItem = this.cartItems.find((item) => item.key === itemKey);

    if (existingItem) {
      existingItem.quantity += 1;
    } else {
      this.cartItems.push({
        key: itemKey,
        id: parfumId,
        name: parfumName,
        price: parfumPrice,
        size: parfumSize,
        imageUrl: parfumImageUrl,
        quantity: 1
      });
    }

    this.saveCartToLocalStorage();
    window.dispatchEvent(new Event('cart-updated'));
    this.showAddToCartNotification(parfumName);
  }

  buyNow(event) {
    event.preventDefault();
    event.stopPropagation();
    const parfumId = event.currentTarget.dataset.parfumId;
    const quantity = event.currentTarget.dataset.quantity || 1;
    const parfumPrice = parseFloat(event.currentTarget.dataset.parfumPrice) || 0;
    const parfumSize = event.currentTarget.dataset.parfumSize || 'N/A';

    if (!parfumId || parfumPrice <= 0 || parfumSize === 'N/A') {
      console.error("Missing or invalid parfum data for buy now:", { parfumId, parfumPrice, parfumSize });
      alert("Veuillez sélectionner une contenance valide avec un prix supérieur à 0.");
      return;
    }

    window.location.href = `/vitrine/checkout?parfum_id=${parfumId}&quantity=${quantity}&size=${encodeURIComponent(parfumSize)}&price=${parfumPrice}`;
  }

  updateQuantity(event) {
    event.preventDefault();
    event.stopPropagation();
    const parfumId = event.currentTarget.dataset.parfumId;
    const parfumSize = event.currentTarget.dataset.parfumSize || 'N/A';
    const itemKey = `${parfumId}-${parfumSize}`;
    let newQuantity;

    if (event.currentTarget.dataset.actionType === "increment") {
      newQuantity = this.cartItems.find((item) => item.key === itemKey).quantity + 1;
    } else if (event.currentTarget.dataset.actionType === "decrement") {
      newQuantity = this.cartItems.find((item) => item.key === itemKey).quantity - 1;
    } else if (event.currentTarget.tagName === "INPUT") {
      newQuantity = Number.parseInt(event.currentTarget.value, 10);
      if (isNaN(newQuantity) || newQuantity < 0) {
        newQuantity = 1;
      }
    }

    const itemIndex = this.cartItems.findIndex((item) => item.key === itemKey);

    if (itemIndex > -1) {
      if (newQuantity <= 0) {
        this.cartItems.splice(itemIndex, 1);
      } else {
        this.cartItems[itemIndex].quantity = newQuantity;
      }
      this.saveCartToLocalStorage();
      window.dispatchEvent(new Event('cart-updated'));
    }
  }

  removeItem(event) {
    event.preventDefault();
    event.stopPropagation();
    const parfumId = event.currentTarget.dataset.parfumId;
    const parfumSize = event.currentTarget.dataset.parfumSize || 'N/A';
    const itemKey = `${parfumId}-${parfumSize}`;
    this.cartItems = this.cartItems.filter((item) => item.key !== itemKey);
    this.saveCartToLocalStorage();
    window.dispatchEvent(new Event('cart-updated'));
  }

renderCartSliderItems() {
  if (!this.hasCartItemsTarget) {
    console.warn("cartItems target not found, skipping slider render");
    return;
  }
  if (this.cartItems.length === 0) {
    this.cartItemsTarget.innerHTML = `<p class="cart-slider-empty-message">Votre panier est vide.</p>`;
    this.updateSliderTotals(0, 0, 0);
    return;
  }

  const itemsHtml = this.cartItems.map(item => `
    <div class="cart-slider-item">
      <img src="${item.imageUrl}" alt="${item.name}" class="cart-slider-item-image">
      <div class="cart-slider-item-info">
        <h4 class="cart-slider-item-name">${item.name}</h4>
        <p class="cart-slider-item-volume">${item.size || 'N/A'} x ${item.quantity}</p>
        <p class="cart-slider-item-price">${this.formatCurrency(item.price * item.quantity)}</p>
      </div>
      <button class="cart-slider-item-remove" data-action="click->cart#removeItem" data-parfum-id="${item.id}" data-parfum-size="${item.size || 'N/A'}" aria-label="Supprimer ${item.name}">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-x"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
      </button>
    </div>
  `).join("");

  this.cartItemsTarget.innerHTML = itemsHtml;
  this.calculateAndDisplayTotals();
}

  renderCartPageItems() {
    if (!this.hasCartPageItemsTarget) return;
    if (this.cartItems.length === 0) {
      this.cartPageItemsTarget.innerHTML = `
        <tr>
          <td colspan="4" class="cart-table-empty-message">Votre panier est vide.</td>
        </tr>
      `;
      this.updatePageTotals(0, 0, 0);
      return;
    }

    const itemsHtml = this.cartItems.map(item => `
      <tr>
        <td class="cart-table-cell cart-item-info-cell" data-label="Produit">
          <img src="${item.imageUrl}" alt="${item.name}" class="cart-item-image">
          <div>
            <span class="cart-item-name">${item.name}</span>
            <p class="cart-item-volume">${item.size || 'N/A'}</p>
          </div>
        </td>
        <td class="cart-table-cell cart-item-quantity-controls" data-label="Quantité">
          <button class="quantity-btn" data-action="click->cart#updateQuantity" data-action-type="decrement" data-parfum-id="${item.id}" data-parfum-size="${item.size || 'N/A'}">-</button>
          <input type="number" value="${item.quantity}" min="1" class="quantity-input" data-parfum-id="${item.id}" data-parfum-size="${item.size || 'N/A'}" data-action="change->cart#updateQuantity:debounce(300)">
          <button class="quantity-btn" data-action="click->cart#updateQuantity" data-action-type="increment" data-parfum-id="${item.id}" data-parfum-size="${item.size || 'N/A'}">+</button>
        </td>
        <td class="cart-table-cell cart-item-price" data-label="Prix Unitaire">
          ${this.formatCurrency(item.price)}
        </td>
        <td class="cart-table-cell cart-item-actions" data-label="Actions">
          <button class="cart-item-remove-btn" data-action="click->cart#removeItem" data-parfum-id="${item.id}" data-parfum-size="${item.size || 'N/A'}" aria-label="Supprimer ${item.name}">
            Supprimer
          </button>
        </td>
      </tr>
    `).join("");

    this.cartPageItemsTarget.innerHTML = itemsHtml;
    this.calculateAndDisplayTotals();
  }

  updateCartCount() {
    if (this.hasCartCountTarget) {
      const totalItems = this.cartItems.reduce((sum, item) => sum + item.quantity, 0);
      this.cartCountTarget.textContent = totalItems.toString();
      this.cartCountTarget.classList.add("animate-pop");
      setTimeout(() => this.cartCountTarget.classList.remove("animate-pop"), 300);
    }
  }

  calculateAndDisplayTotals() {
    const subtotal = this.cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0);
    const deliveryFee = subtotal >= 250 ? 0 : 8;
    const total = subtotal + deliveryFee;
    this.updateSliderTotals(subtotal, deliveryFee, total);
    this.updatePageTotals(subtotal, deliveryFee, total);
  }

  updateSliderTotals(subtotal, deliveryFee, total) {
    if (this.hasSubtotalDisplayTarget) {
      this.subtotalDisplayTarget.textContent = this.formatCurrency(subtotal);
    }
    if (this.hasDeliveryDisplayTarget) {
      this.deliveryDisplayTarget.textContent = this.formatCurrency(deliveryFee);
    }
    if (this.hasTotalDisplayTarget) {
      this.totalDisplayTarget.textContent = this.formatCurrency(total);
    }
  }

  updatePageTotals(subtotal, deliveryFee, total) {
    if (this.hasSubtotalPageDisplayTarget) {
      this.subtotalPageDisplayTarget.textContent = this.formatCurrency(subtotal);
    }
    if (this.hasDeliveryPageDisplayTarget) {
      this.deliveryPageDisplayTarget.textContent = this.formatCurrency(deliveryFee);
    }
    if (this.hasTotalPageDisplayTarget) {
      this.totalPageDisplayTarget.textContent = this.formatCurrency(total);
    }
  }

  viewCartPage() {
    this.close();
    window.location.href = "/vitrine/cart";
  }

  orderCart() {
    if (this.cartItems.length === 0) {
      alert("Votre panier est vide !");
      return;
    }
    const cartData = encodeURIComponent(JSON.stringify(this.cartItems));
    window.location.href = `/vitrine/checkout?cart_items=${cartData}`;
  }

  showAddToCartNotification(parfumName) {
    const notification = document.createElement("div");
    notification.innerHTML = `
      <div style="
        position: fixed;
        top: 20px;
        right: 20px;
        background: #28a745;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 9999;
        font-family: Arial, sans-serif;
        font-size: 14px;
        max-width: 300px;
        animation: slideIn 0.3s ease-out;
      ">
        <strong>✓ Ajouté au panier !</strong><br>
        ${parfumName}
      </div>
      <style>
        @keyframes slideIn {
          from { transform: translateX(100%); opacity: 0; }
          to { transform: translateX(0); opacity: 1; }
        }
      </style>
    `;
    document.body.appendChild(notification);
    setTimeout(() => {
      notification.style.animation = "slideIn 0.3s ease-out reverse";
      setTimeout(() => {
        if (notification.parentNode) {
          notification.parentNode.removeChild(notification);
        }
      }, 300);
    }, 3000);
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat("fr-TN", { style: "currency", currency: "TND" }).format(amount);
  }
}