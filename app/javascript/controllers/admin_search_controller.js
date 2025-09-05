import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "results"]
  static values = {
    url: String,
    minLength: { type: Number, default: 2 },
  }

  connect() {
    console.log("Admin Search controller connected")
    this.timeout = null
  }

  search() {
    const query = this.inputTarget.value.trim()

    // Annuler la recherche précédente
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    // Si la requête est trop courte, cacher les résultats
    if (query.length < this.minLengthValue) {
      this.hideDropdown()
      return
    }

    // Débounce la recherche
    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }

  async performSearch(query) {
    try {
      console.log(`Performing search for query: ${query}`)
      const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
        headers: {
          Accept: "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
      })

      console.log(`Response status: ${response.status}`)
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const data = await response.json()
      console.log("Response data:", data)
      this.displayResults(data)
    } catch (error) {
      console.error("Search error:", error)
    }
  }

  displayResults(data) {
    if (!this.hasDropdownTarget) return

    let html = ""

    // Afficher un résumé
    if (data.total > 0) {
      html += `<div class="admin-search-dropdown-header">
        <small class="text-muted">${data.total} résultat(s) pour "${data.query}"</small>
      </div>`

      // Parfums
      if (data.parfums && data.parfums.length > 0) {
        html += '<div class="admin-search-dropdown-section">'
        html += '<h6 class="admin-search-dropdown-title"><i class="fas fa-box-open me-1"></i> Parfums</h6>'
        data.parfums.forEach((parfum) => {
          html += `
            <a href="${parfum.url}" class="admin-search-dropdown-item">
              <div class="admin-search-dropdown-item-content">
                <strong>${parfum.name}</strong>
                <small class="text-muted d-block">${parfum.brand || "Sans marque"}</small>
              </div>
            </a>
          `
        })
        html += "</div>"
      }

      // Marques
      if (data.brands && data.brands.length > 0) {
        html += '<div class="admin-search-dropdown-section">'
        html += '<h6 class="admin-search-dropdown-title"><i class="fas fa-tags me-1"></i> Marques</h6>'
        data.brands.forEach((brand) => {
          html += `
            <a href="${brand.url}" class="admin-search-dropdown-item">
              <div class="admin-search-dropdown-item-content">
                <strong>${brand.name}</strong>
                <small class="text-muted d-block">${brand.parfums_count} parfum(s)</small>
              </div>
            </a>
          `
        })
        html += "</div>"
      }

      // Commandes
      if (data.orders && data.orders.length > 0) {
        html += '<div class="admin-search-dropdown-section">'
        html += '<h6 class="admin-search-dropdown-title"><i class="fas fa-shopping-cart me-1"></i> Commandes</h6>'
        data.orders.forEach((order) => {
          html += `
            <a href="${order.url}" class="admin-search-dropdown-item">
              <div class="admin-search-dropdown-item-content">
                <strong>Commande #${order.id}</strong>
                <small class="text-muted d-block">${order.customer_name} • ${order.total}</small>
              </div>
            </a>
          `
        })
        html += "</div>"
      }

      // Lien vers tous les résultats
      html += `
        <div class="admin-search-dropdown-footer">
          <a href="/admin_panel/search?q=${encodeURIComponent(data.query)}" class="admin-search-view-all">
            Voir tous les résultats →
          </a>
        </div>
      `
    } else {
      html = `
        <div class="admin-search-dropdown-empty">
          <small class="text-muted">Aucun résultat pour "${data.query}"</small>
        </div>
      `
    }

    this.dropdownTarget.innerHTML = html
    this.showDropdown()
  }

  showDropdown() {
    if (this.hasDropdownTarget) {
      this.dropdownTarget.classList.add("show")
    }
  }

  hideDropdown() {
    if (this.hasDropdownTarget) {
      this.dropdownTarget.classList.remove("show")
    }
  }

  // Cacher le dropdown quand on clique ailleurs
  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideDropdown()
    }
  }

  // Soumettre le formulaire
  submit(event) {
    const query = this.inputTarget.value.trim()
    if (query.length >= this.minLengthValue) {
      // Laisser le formulaire se soumettre normalement
      return true
    } else {
      event.preventDefault()
      return false
    }
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}