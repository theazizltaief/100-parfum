import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  static targets = ["deleteForm"]

  connect() {
    document.addEventListener("click", this.closeAllDropdowns.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeAllDropdowns.bind(this))
  }

  closeAllDropdowns() {
    // Méthode vide, car plus de dropdowns
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