import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  confirm(event) {
    event.preventDefault()

    const message = this.element.dataset.confirmMessage || "Êtes-vous sûr de vouloir supprimer ?"
    const form = this.element

    Swal.fire({
      title: 'Supprimer ?',
      text: message,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Oui, supprimer',
      cancelButtonText: 'Annuler'
    }).then((result) => {
      if (result.isConfirmed) {
        form.submit()
      }
    })
  }
}
