import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  static targets = ["dropdown", "deleteForm"]

  connect() {
    // Fermer les dropdowns quand on clique ailleurs
    document.addEventListener("click", this.closeAllDropdowns.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeAllDropdowns.bind(this))
  }

  // Toggle dropdown au clic - MODIFIÉ pour calculer la position
  toggleDropdown(event) {
    event.preventDefault()
    event.stopPropagation()

    const dropdown = event.currentTarget.closest(".admin-status-dropdown")
    const menu = dropdown.querySelector(".admin-status-menu")
    const isActive = dropdown.classList.contains("active")

    // Fermer tous les autres dropdowns
    this.closeAllDropdowns()

    // Toggle le dropdown actuel
    if (!isActive) {
      dropdown.classList.add("active")

      // NOUVEAU: Calculer et définir la position du menu
      this.positionDropdownMenu(event.currentTarget, menu)
    }
  }

  // NOUVELLE MÉTHODE: Positionner le menu dropdown
  positionDropdownMenu(button, menu) {
    const buttonRect = button.getBoundingClientRect()
    const menuWidth = 160 // Largeur du menu définie dans le CSS
    const menuHeight = 200 // Hauteur approximative du menu

    // Position par défaut: en dessous et à droite du bouton
    let top = buttonRect.bottom + 5
    let left = buttonRect.right - menuWidth

    // Vérifier si le menu dépasse à droite de l'écran
    if (left + menuWidth > window.innerWidth) {
      left = buttonRect.left - menuWidth + buttonRect.width
    }

    // Vérifier si le menu dépasse à gauche de l'écran
    if (left < 10) {
      left = 10
    }

    // Vérifier si le menu dépasse en bas de l'écran
    if (top + menuHeight > window.innerHeight) {
      top = buttonRect.top - menuHeight - 5
    }

    // Vérifier si le menu dépasse en haut de l'écran
    if (top < 10) {
      top = buttonRect.bottom + 5
    }

    // Appliquer les positions calculées
    menu.style.top = `${top}px`
    menu.style.left = `${left}px`
  }

  // Fermer tous les dropdowns
  closeAllDropdowns(event) {
    // Si on clique sur un élément du dropdown, ne pas fermer
    if (event && event.target.closest(".admin-status-dropdown")) {
      return
    }

    const dropdowns = document.querySelectorAll(".admin-status-dropdown")
    dropdowns.forEach((dropdown) => {
      dropdown.classList.remove("active")
    })
  }

  // Confirmation de suppression avec SweetAlert
confirmDelete(event) {
  event.preventDefault();

  // Toujours cibler le lien <a>
  const link = event.currentTarget.closest("a");
  const orderId = link.dataset.orderId;
  const message = link.dataset.confirmMessage || "Êtes-vous sûr de vouloir supprimer cette commande ?";
  const actionUrl = link.getAttribute("href"); // 🔹 évite le null

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
      const form = document.createElement("form");
      form.method = "POST";
      form.action = actionUrl; // 🔹 URL sûre

      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
      const csrfInput = document.createElement("input");
      csrfInput.type = "hidden";
      csrfInput.name = "authenticity_token";
      csrfInput.value = csrfToken;
      form.appendChild(csrfInput);

      const methodInput = document.createElement("input");
      methodInput.type = "hidden";
      methodInput.name = "_method";
      methodInput.value = "delete";
      form.appendChild(methodInput);

      document.body.appendChild(form);
      form.submit();

      Swal.fire({
        title: "Suppression en cours...",
        allowOutsideClick: false,
        didOpen: () => Swal.showLoading(),
      });
    }
  });
}


  // Confirmation de changement de statut - AMÉLIORÉ
  confirmStatusChange(event) {
    event.preventDefault()

    // Récupérer les informations depuis l'élément cliqué
    const link = event.currentTarget
    const orderId = link.dataset.orderId || this.extractOrderIdFromUrl(link.href)
    const statusText = this.getStatusTextFromLink(link)
    const actionUrl = link.href

    console.log("Status change:", { orderId, statusText, actionUrl }) // Debug

    Swal.fire({
      title: "Changer le statut ?",
      text: `Voulez-vous changer le statut de la commande #${orderId} vers "${statusText}" ?`,
      icon: "question",
      showCancelButton: true,
      confirmButtonColor: "#007bff",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Oui, changer",
      cancelButtonText: "Annuler",
      reverseButtons: true,
    }).then((result) => {
      if (result.isConfirmed) {
        // Fermer le dropdown s'il existe
        this.closeAllDropdowns()

        // Créer et soumettre un formulaire pour le changement de statut
        this.submitStatusChangeForm(actionUrl)

        // Afficher un message de chargement
        Swal.fire({
          title: "Mise à jour en cours...",
          allowOutsideClick: false,
          didOpen: () => {
            Swal.showLoading()
          },
        })
      }
    })
  }

  // Méthode helper pour extraire l'ID de commande depuis l'URL
  extractOrderIdFromUrl(url) {
    const matches = url.match(/orders\/(\d+)/)
    return matches ? matches[1] : "N/A"
  }

  // Méthode helper pour obtenir le texte du statut
  getStatusTextFromLink(link) {
    // Essayer de trouver le badge dans le lien (pour les dropdowns)
    const badge = link.querySelector(".admin-status-badge")
    if (badge) {
      return badge.textContent.trim()
    }

    // Sinon, extraire depuis l'URL ou le texte du bouton
    const url = link.href
    if (url.includes("new_status=confirmed")) return "Confirmée"
    if (url.includes("new_status=shipped")) return "Expédiée"
    if (url.includes("new_status=delivered")) return "Livrée"
    if (url.includes("new_status=cancelled")) return "Annulée"
    if (url.includes("new_status=pending")) return "En attente"

    // Fallback: utiliser le texte du bouton
    return link.textContent.trim().replace(/.*\s/, "") // Prend le dernier mot
  }

  // Méthode helper pour soumettre le formulaire de changement de statut
  submitStatusChangeForm(actionUrl) {
    const form = document.createElement("form")
    form.method = "POST"
    form.action = actionUrl

    // Ajouter le token CSRF
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
    if (csrfToken) {
      const csrfInput = document.createElement("input")
      csrfInput.type = "hidden"
      csrfInput.name = "authenticity_token"
      csrfInput.value = csrfToken
      form.appendChild(csrfInput)
    }

    // Ajouter la méthode PATCH
    const methodInput = document.createElement("input")
    methodInput.type = "hidden"
    methodInput.name = "_method"
    methodInput.value = "patch"
    form.appendChild(methodInput)

    // Ajouter au DOM et soumettre
    document.body.appendChild(form)
    form.submit()
  }

  // Méthode spécifique pour les boutons de la page de détail
  confirmDetailStatusChange(event) {
    event.preventDefault()

    const button = event.currentTarget
    const orderId = button.dataset.orderId
    const actionUrl = button.href

    // Extraire le type d'action depuis le texte du bouton ou l'URL
    let actionText = "changer le statut"
    let statusText = ""

    if (button.textContent.includes("Confirmer")) {
      actionText = "confirmer"
      statusText = "Confirmée"
    } else if (button.textContent.includes("expédiée")) {
      actionText = "marquer comme expédiée"
      statusText = "Expédiée"
    } else if (button.textContent.includes("livrée")) {
      actionText = "marquer comme livrée"
      statusText = "Livrée"
    } else if (button.textContent.includes("Annuler")) {
      actionText = "annuler"
      statusText = "Annulée"
    }

    Swal.fire({
      title: `${actionText.charAt(0).toUpperCase() + actionText.slice(1)} la commande ?`,
      text: `Voulez-vous ${actionText} la commande #${orderId} ?`,
      icon: "question",
      showCancelButton: true,
      confirmButtonColor: "#007bff",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Oui, continuer",
      cancelButtonText: "Annuler",
      reverseButtons: true,
    }).then((result) => {
      if (result.isConfirmed) {
        // Soumettre le formulaire
        this.submitStatusChangeForm(actionUrl)

        // Afficher un message de chargement
        Swal.fire({
          title: "Mise à jour en cours...",
          allowOutsideClick: false,
          didOpen: () => {
            Swal.showLoading()
          },
        })
      }
    })
  }
}
