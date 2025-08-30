import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  static targets = ["deleteForm", "dropdown"]

  connect() {
    console.log("AdminOrders controller connected")
    document.addEventListener("click", this.closeAllDropdowns.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeAllDropdowns.bind(this))
  }

  closeAllDropdowns(event) {
    const dropdowns = document.querySelectorAll(".admin-status-menu")
    dropdowns.forEach(dropdown => {
      if (!dropdown.contains(event.target) && !event.target.closest(".admin-status-dropdown button")) {
        dropdown.style.display = "none"
      }
    })
  }

  toggleDropdown(event) {
    console.log("toggleDropdown triggered")
    event.preventDefault()
    const menu = event.currentTarget.nextElementSibling
    if (menu && menu.classList.contains("admin-status-menu")) {
      menu.style.display = menu.style.display === "block" ? "none" : "block"
      console.log("Menu display toggled to:", menu.style.display)
    } else {
      console.error("Menu not found or invalid structure")
    }
  }

  confirmDelete(event) {
    event.preventDefault()

    const link = event.currentTarget.closest("a")
    const orderId = link.dataset.orderId
    const message = link.dataset.confirmMessage || "Êtes-vous sûr de vouloir supprimer cette commande ?"
    const actionUrl = link.getAttribute("href")

    Swal.fire({
      title: "Supprimer la commande ?",
      text: message,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#dc3545",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Oui, supprimer",
      cancelButtonText: "Annuler",
      reverseButtons: true,
    }).then((result) => {
      if (result.isConfirmed) {
        const form = document.createElement("form")
        form.method = "POST"
        form.action = actionUrl

        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
        const csrfInput = document.createElement("input")
        csrfInput.type = "hidden"
        csrfInput.name = "authenticity_token"
        csrfInput.value = csrfToken
        form.appendChild(csrfInput)

        const methodInput = document.createElement("input")
        methodInput.type = "hidden"
        methodInput.name = "_method"
        methodInput.value = "delete"
        form.appendChild(methodInput)

        document.body.appendChild(form)
        form.submit()

        Swal.fire({
          title: "Suppression en cours...",
          allowOutsideClick: false,
          didOpen: () => Swal.showLoading(),
        })
      }
    })
  }

  confirmDetailStatusChange(event) {
    event.preventDefault()

    const button = event.currentTarget
    const orderId = button.dataset.orderId
    const actionUrl = button.getAttribute("href")

    let actionText = "changer le statut"
    let statusText = button.dataset.statusText || ""

    if (button.textContent.includes("Confirmer")) {
      actionText = "confirmer"
      statusText = "Confirmée"
    } else if (button.textContent.includes("Marquer comme expédiée")) {
      actionText = "marquer comme expédiée"
      statusText = "Expédiée"
    } else if (button.textContent.includes("Marquer comme livrée")) {
      actionText = "marquer comme livrée"
      statusText = "Livrée"
    } else if (button.textContent.includes("Annuler")) {
      actionText = "annuler"
      statusText = "Annulée"
    }

    Swal.fire({
      title: `${actionText.charAt(0).toUpperCase() + actionText.slice(1)} la commande ?`,
      text: `Voulez-vous ${actionText} la commande #${orderId} vers "${statusText}" ?`,
      icon: "question",
      showCancelButton: true,
      confirmButtonColor: "#007bff",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Oui, continuer",
      cancelButtonText: "Annuler",
      reverseButtons: true,
    }).then((result) => {
      if (result.isConfirmed) {
        this.submitStatusChangeForm(actionUrl)

        Swal.fire({
          title: "Mise à jour en cours...",
          allowOutsideClick: false,
          didOpen: () => Swal.showLoading(),
        })
      }
    })
  }

  confirmStatusChange(event) {
    event.preventDefault()

    const link = event.currentTarget
    const orderId = link.dataset.orderId
    const actionUrl = link.getAttribute("href")
    const statusText = link.querySelector(".admin-status-badge").textContent

    Swal.fire({
      title: "Changer le statut ?",
      text: `Voulez-vous changer le statut de la commande #${orderId} vers "${statusText}" ?`,
      icon: "question",
      showCancelButton: true,
      confirmButtonColor: "#007bff",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Oui, continuer",
      cancelButtonText: "Annuler",
      reverseButtons: true,
    }).then((result) => {
      if (result.isConfirmed) {
        this.submitStatusChangeForm(actionUrl)

        Swal.fire({
          title: "Mise à jour en cours...",
          allowOutsideClick: false,
          didOpen: () => Swal.showLoading(),
        })
      }
    })
  }

  submitStatusChangeForm(actionUrl) {
    const form = document.createElement("form")
    form.method = "POST"
    form.action = actionUrl

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
    if (csrfToken) {
      const csrfInput = document.createElement("input")
      csrfInput.type = "hidden"
      csrfInput.name = "authenticity_token"
      csrfInput.value = csrfToken
      form.appendChild(csrfInput)
    }

    const methodInput = document.createElement("input")
    methodInput.type = "hidden"
    methodInput.name = "_method"
    methodInput.value = "patch"
    form.appendChild(methodInput)

    document.body.appendChild(form)
    form.submit()
  }
}