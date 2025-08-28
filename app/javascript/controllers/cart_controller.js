import { Controller } from "@hotwired/stimulus"
function getCsrfToken() {
  const el = document.querySelector('meta[name="csrf-token"]')
  return el && el.content
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
  })
}
export default class extends Controller {
  static targets = [
    "overlay",
    "cartItems", // Pour le slider
    "totalDisplay",
    "subtotalDisplay",
    "deliveryDisplay",
    "cartCount",
    "cartPageItems", // Pour le tableau de la page panier
    "subtotalPageDisplay", // Pour le total de la page panier
    "deliveryPageDisplay", // Pour le total de la page panier
    "totalPageDisplay", // Pour le total de la page panier
  ]

  static values = { open: Boolean }

  connect() {
    console.log("Cart controller connected!")
    this.openValue = false // Le slider est fermé par défaut
    this.loadCartFromLocalStorage() // Charge le panier au démarrage
    this.updateCartCount() // Met à jour le compteur dans la navbar
    // NOUVEAU : Vérifie si nous sommes sur la page du panier et déclenche le rendu
    if (window.location.pathname === "/vitrine/cart") {
      this.renderCartPageItems()
    }
    window.addEventListener('cart-updated', this.handleCartUpdate.bind(this))
  }

  disconnect() {
    window.removeEventListener('cart-updated', this.handleCartUpdate.bind(this))
  }

  handleCartUpdate() {
    this.loadCartFromLocalStorage()
    this.updateCartCount()
    if (this.hasOverlayTarget) {
      if (this.openValue) {
        this.renderCartSliderItems()
      } else {
        this.toggle()
      }
    }
    if (this.hasCartPageItemsTarget) {
      this.renderCartPageItems()
    }
  }

  // --- Gestion de l'ouverture/fermeture du slider ---
  toggle() {
    // Vérifie si le slider existe avant de l'ouvrir
    if (!this.hasOverlayTarget) {
      console.warn("Cart slider not available on this page")
      return
    }

    this.openValue = !this.openValue
    if (this.openValue) {
      this.overlayTarget.classList.add("is-open")
      this.renderCartSliderItems() // Affiche les articles du panier quand le slider s'ouvre
    } else {
      this.overlayTarget.classList.remove("is-open")
    }
  }

  close() {
    if (!this.hasOverlayTarget) return

    this.openValue = false
    this.overlayTarget.classList.remove("is-open")
  }

  // --- Gestion des articles du panier (localStorage) ---
  // Charge le panier depuis le localStorage
  loadCartFromLocalStorage() {
    try {
      const cartData = localStorage.getItem("cart")
      this.cartItems = cartData ? JSON.parse(cartData) : []
    } catch (e) {
      console.error("Failed to load cart from localStorage:", e)
      this.cartItems = []
    }
  }

  // Sauvegarde le panier dans le localStorage
  saveCartToLocalStorage() {
    try {
      localStorage.setItem("cart", JSON.stringify(this.cartItems))
    } catch (e) {
      console.error("Failed to save cart to localStorage:", e)
    }
  }

  // Action pour ajouter un parfum au panier
  addToCart(event) {
    event.preventDefault()
    event.stopPropagation() // Empêche l'événement de remonter aux parents

    console.log("addToCart called", event.currentTarget) // DEBUG
    console.log("Dataset:", event.currentTarget.dataset) // DEBUG

    const parfumId = event.currentTarget.dataset.parfumId
    const parfumName = event.currentTarget.dataset.parfumName
    const parfumPrice = Number.parseFloat(event.currentTarget.dataset.parfumPrice)
    const parfumImageUrl = event.currentTarget.dataset.parfumImageUrl || "/placeholder.svg?height=50&width=50&text=P"

    console.log("Attempting to add to cart:", { parfumId, parfumName, parfumPrice, parfumImageUrl })

    if (!parfumId || !parfumName || isNaN(parfumPrice)) {
      console.error("Missing or invalid parfum data for adding to cart.")
      return
    }

    const existingItem = this.cartItems.find((item) => item.id === parfumId)

    if (existingItem) {
      // Si le parfum existe déjà, incrémente la quantité
      existingItem.quantity += 1
      console.log(`Quantité de '${parfumName}' incrémentée à ${existingItem.quantity}.`)
    } else {
      // Sinon, ajoute le nouveau parfum
      this.cartItems.push({
        id: parfumId,
        name: parfumName,
        price: parfumPrice,
        imageUrl: parfumImageUrl,
        quantity: 1, // Quantité initiale
      })
      console.log(`Parfum '${parfumName}' ajouté au panier.`)
    }

    this.saveCartToLocalStorage()
    window.dispatchEvent(new Event('cart-updated'))
    this.updateCartCount()

    // CORRIGÉ : Vérifie si les targets existent avant de les utiliser
    if (this.hasCartItemsTarget) {
      this.renderCartSliderItems() // Met à jour l'affichage du slider
    }

    if (this.hasCartPageItemsTarget) {
      this.renderCartPageItems() // Met à jour l'affichage de la page panier si ouverte
    }

    // CORRIGÉ : Ouvre le slider seulement s'il existe
    if (this.hasOverlayTarget) {
      if (!this.openValue) {
        this.toggle() // Ouvre si fermé
      } else {
        this.renderCartSliderItems() // Met à jour si déjà ouvert
      }
    }
  }

  // NOUVELLE MÉTHODE : Notification quand le slider n'est pas disponible
  showAddToCartNotification(parfumName) {
    // Crée une notification temporaire
    const notification = document.createElement("div")
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
    `

    document.body.appendChild(notification)

    // Supprime la notification après 3 secondes
    setTimeout(() => {
      notification.style.animation = "slideIn 0.3s ease-out reverse"
      setTimeout(() => {
        if (notification.parentNode) {
          notification.parentNode.removeChild(notification)
        }
      }, 300)
    }, 3000)
  }

  // NOUVELLE MÉTHODE : Acheter maintenant
  buyNow(event) {
    event.preventDefault()
    event.stopPropagation()

    const parfumId = event.currentTarget.dataset.parfumId
    const quantity = event.currentTarget.dataset.quantity || 1

    if (!parfumId) {
      console.error("Missing parfum ID for buy now.")
      return
    }

    // Redirige directement vers checkout avec ce produit
    window.location.href = `/vitrine/checkout?parfum_id=${parfumId}&quantity=${quantity}`
  }

  // NOUVEAU : Méthode pour mettre à jour la quantité d'un article
  updateQuantity(event) {
    event.preventDefault()
    event.stopPropagation()

    const parfumId = event.currentTarget.dataset.parfumId
    let newQuantity

    // Détermine la nouvelle quantité en fonction de l'action ou de la valeur de l'input
    if (event.currentTarget.dataset.actionType === "increment") {
      newQuantity = this.cartItems.find((item) => item.id === parfumId).quantity + 1
    } else if (event.currentTarget.dataset.actionType === "decrement") {
      newQuantity = this.cartItems.find((item) => item.id === parfumId).quantity - 1
    } else if (event.currentTarget.tagName === "INPUT") {
      newQuantity = Number.parseInt(event.currentTarget.value, 10)
      if (isNaN(newQuantity) || newQuantity < 0) {
        newQuantity = 1 // Valeur par défaut si l'input est invalide
      }
    }

    const itemIndex = this.cartItems.findIndex((item) => item.id === parfumId)

    if (itemIndex > -1) {
      if (newQuantity <= 0) {
        // Supprime l'article si la quantité est 0 ou moins
        this.cartItems.splice(itemIndex, 1)
        console.log(`Parfum (ID: ${parfumId}) retiré du panier.`)
      } else {
        // Met à jour la quantité
        this.cartItems[itemIndex].quantity = newQuantity
        console.log(`Quantité de parfum (ID: ${parfumId}) mise à jour à ${newQuantity}.`)
      }

      this.saveCartToLocalStorage()
      window.dispatchEvent(new Event('cart-updated'))
      this.updateCartCount()

      // CORRIGÉ : Vérifie si les targets existent
      if (this.hasCartItemsTarget) {
        this.renderCartSliderItems() // Met à jour le slider
      }
      if (this.hasCartPageItemsTarget) {
        this.renderCartPageItems() // Met à jour la page panier
      }
    }
  }

  // Action pour supprimer un article du panier (utilisée par le bouton "Supprimer")
  removeItem(event) {
    event.preventDefault()
    event.stopPropagation()

    const parfumIdToRemove = event.currentTarget.dataset.parfumId
    this.cartItems = this.cartItems.filter((item) => item.id !== parfumIdToRemove)

    this.saveCartToLocalStorage()
    window.dispatchEvent(new Event('cart-updated'))
    this.updateCartCount()

    // CORRIGÉ : Vérifie si les targets existent
    if (this.hasCartItemsTarget) {
      this.renderCartSliderItems() // Met à jour le slider
    }
    if (this.hasCartPageItemsTarget) {
      this.renderCartPageItems() // Met à jour la page panier
    }

    console.log(`Parfum (ID: ${parfumIdToRemove}) retiré du panier.`)
  }

  // --- Rendu du panier (pour le slider) ---
  renderCartSliderItems() {
    // CORRIGÉ : Vérifie si la target existe
    if (!this.hasCartItemsTarget) {
      console.warn("cartItems target not found, skipping slider render")
      return
    }

    if (this.cartItems.length === 0) {
      this.cartItemsTarget.innerHTML = `<p class="cart-slider-empty-message">Votre panier est vide.</p>`
      this.updateSliderTotals(0, 0, 0)
      return
    }

    const itemsHtml = this.cartItems
      .map(
        (item) => `
      <div class="cart-slider-item">
        <img src="${item.imageUrl}" alt="${item.name}" class="cart-slider-item-image">
        <div class="cart-slider-item-info">
          <h4 class="cart-slider-item-name">${item.name}</h4>
          <p class="cart-slider-item-volume">10ml x ${item.quantity}</p>
          <p class="cart-slider-item-price">${this.formatCurrency(item.price * item.quantity)}</p>
        </div>
        <button class="cart-slider-item-remove" data-action="click->cart#removeItem" data-parfum-id="${item.id}" aria-label="Supprimer ${item.name}">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-x"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
        </button>
      </div>
    `,
      )
      .join("")

    this.cartItemsTarget.innerHTML = itemsHtml
    this.calculateAndDisplayTotals()
  }

  // --- Rendu du panier (pour la page dédiée) ---
  renderCartPageItems() {
    if (!this.hasCartPageItemsTarget) return // S'assure que la cible existe (on est sur la page panier)

    if (this.cartItems.length === 0) {
      this.cartPageItemsTarget.innerHTML = `
        <tr>
          <td colspan="4" class="cart-table-empty-message">Votre panier est vide.</td>
        </tr>
      `
      this.updatePageTotals(0, 0, 0)
      return
    }

    const itemsHtml = this.cartItems
      .map(
        (item) => `
      <tr>
        <td class="cart-table-cell cart-item-info-cell" data-label="Produit">
          <img src="${item.imageUrl}" alt="${item.name}" class="cart-item-image">
          <div>
            <span class="cart-item-name">${item.name}</span>
            <p class="cart-item-volume">10ml</p>
          </div>
        </td>
        <td class="cart-table-cell cart-item-quantity-controls" data-label="Quantité">
          <button class="quantity-btn" data-action="click->cart#updateQuantity" data-action-type="decrement" data-parfum-id="${item.id}">-</button>
          <input type="number" value="${item.quantity}" min="1" class="quantity-input" data-parfum-id="${item.id}" data-action="change->cart#updateQuantity:debounce(300)">
          <button class="quantity-btn" data-action="click->cart#updateQuantity" data-action-type="increment" data-parfum-id="${item.id}">+</button>
        </td>
        <td class="cart-table-cell cart-item-price" data-label="Prix Unitaire">
          ${this.formatCurrency(item.price)}
        </td>
        <td class="cart-table-cell cart-item-actions" data-label="Actions">
          <button class="cart-item-remove-btn" data-action="click->cart#removeItem" data-parfum-id="${item.id}" aria-label="Supprimer ${item.name}">
            Supprimer
          </button>
        </td>
      </tr>
    `,
      )
      .join("")

    this.cartPageItemsTarget.innerHTML = itemsHtml
    this.calculateAndDisplayTotals()
  }

  // Met à jour le compteur dans la navbar
  updateCartCount() {
    if (this.hasCartCountTarget) {
      // Calcule le nombre total d'articles (somme des quantités)
      const totalItems = this.cartItems.reduce((sum, item) => sum + item.quantity, 0)
      this.cartCountTarget.textContent = totalItems.toString()
      this.cartCountTarget.classList.add("animate-pop")
      setTimeout(() => this.cartCountTarget.classList.remove("animate-pop"), 300)
    }
  }

  // --- Calcul et affichage des totaux ---
  calculateAndDisplayTotals() {
    // Calcule le sous-total en tenant compte des quantités
    const subtotal = this.cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0)
    const deliveryFee = subtotal >= 250 ? 0 : 8 // Livraison gratuite si > 250 TND
    const total = subtotal + deliveryFee

    this.updateSliderTotals(subtotal, deliveryFee, total)
    this.updatePageTotals(subtotal, deliveryFee, total)
  }

  updateSliderTotals(subtotal, deliveryFee, total) {
    if (this.hasSubtotalDisplayTarget) {
      this.subtotalDisplayTarget.textContent = this.formatCurrency(subtotal)
    }
    if (this.hasDeliveryDisplayTarget) {
      this.deliveryDisplayTarget.textContent = this.formatCurrency(deliveryFee)
    }
    if (this.hasTotalDisplayTarget) {
      this.totalDisplayTarget.textContent = this.formatCurrency(total)
    }
  }

  updatePageTotals(subtotal, deliveryFee, total) {
    if (this.hasSubtotalPageDisplayTarget) {
      this.subtotalPageDisplayTarget.textContent = this.formatCurrency(subtotal)
    }
    if (this.hasDeliveryPageDisplayTarget) {
      this.deliveryPageDisplayTarget.textContent = this.formatCurrency(deliveryFee)
    }
    if (this.hasTotalPageDisplayTarget) {
      this.totalPageDisplayTarget.textContent = this.formatCurrency(total)
    }
  }

  // --- Navigation et Actions ---
  viewCartPage() {
    this.close() // Ferme le slider
    window.location.href = "/vitrine/cart" // Redirige vers la page du panier
  }

  // MODIFIÉ : Redirige vers checkout au lieu d'afficher une alerte
  orderCart() {
    if (this.cartItems.length === 0) {
      alert("Votre panier est vide !")
      return
    }

    // Encode les données du panier pour les passer en paramètre
    const cartData = encodeURIComponent(JSON.stringify(this.cartItems))
    window.location.href = `/vitrine/checkout?cart_items=${cartData}`
  }

  // --- Fonctions utilitaires ---
  formatCurrency(amount) {
    return new Intl.NumberFormat("fr-TN", { style: "currency", currency: "TND" }).format(amount)
  }
}