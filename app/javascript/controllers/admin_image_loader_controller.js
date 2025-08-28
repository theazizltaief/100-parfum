import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "spinner", "container", "errorState"]
  static values = {
    timeout: { type: Number, default: 10000 }, // 10 secondes de timeout
    retryCount: { type: Number, default: 2 },
  }

  connect() {
    console.log("Admin Image Loader connected")
    this.currentRetries = 0
    this.isLoading = false
    this.isLoaded = false
    this.hasError = false

    // Initialiser l'état
    this.initializeState()
    this.loadImage()
  }

  initializeState() {
    // S'assurer qu'un seul état est visible au départ
    this.showSpinner()
    this.hideError()
    this.hideImage()
  }

  loadImage() {
    if (!this.hasImageTarget) {
      console.warn("No image target found")
      this.showError("Aucune image à charger")
      return
    }

    const img = this.imageTarget
    const originalSrc = img.dataset.src || img.src

    if (!originalSrc) {
      this.showError("Aucune source d'image")
      return
    }

    // Réinitialiser les états
    this.isLoading = true
    this.isLoaded = false
    this.hasError = false

    // Afficher uniquement le spinner
    this.showSpinner()
    this.hideError()
    this.hideImage()

    console.log("Loading image:", originalSrc)

    // Créer une nouvelle image pour le préchargement
    const preloadImg = new Image()

    // Timeout pour éviter les chargements trop longs
    const timeoutId = setTimeout(() => {
      if (this.isLoading) {
        console.log("Image loading timeout")
        this.handleLoadError("Timeout de chargement")
      }
    }, this.timeoutValue)

    // Gestionnaire de succès
    preloadImg.onload = () => {
      console.log("Image loaded successfully")
      clearTimeout(timeoutId)
      if (this.isLoading) {
        this.handleLoadSuccess(originalSrc)
      }
    }

    // Gestionnaire d'erreur
    preloadImg.onerror = () => {
      console.log("Image loading error")
      clearTimeout(timeoutId)
      if (this.isLoading) {
        this.handleLoadError("Erreur de chargement")
      }
    }

    // Démarrer le chargement
    preloadImg.src = originalSrc
  }

  showSpinner() {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove("hidden")
      this.spinnerTarget.setAttribute("aria-hidden", "false")
      console.log("Spinner shown")
    }
  }

  hideSpinner() {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add("hidden")
      this.spinnerTarget.setAttribute("aria-hidden", "true")
      console.log("Spinner hidden")
    }
  }

  showImage() {
    if (this.hasImageTarget) {
      this.imageTarget.classList.remove("admin-image-loading")
      this.imageTarget.classList.add("admin-image-loaded", "admin-image-fade-in")
      this.imageTarget.style.display = "block"
      console.log("Image shown")
    }
  }

  hideImage() {
    if (this.hasImageTarget) {
      this.imageTarget.classList.add("admin-image-loading")
      this.imageTarget.classList.remove("admin-image-loaded", "admin-image-fade-in")
      console.log("Image hidden")
    }
  }

  showError(message) {
    if (this.hasErrorStateTarget) {
      this.errorStateTarget.classList.remove("hidden")
      const errorText = this.errorStateTarget.querySelector(".admin-error-text")
      if (errorText) {
        errorText.textContent = message
      }
      console.log("Error shown:", message)
    }
  }

  hideError() {
    if (this.hasErrorStateTarget) {
      this.errorStateTarget.classList.add("hidden")
      console.log("Error hidden")
    }
  }

  handleLoadSuccess(src) {
    console.log("Handling load success for:", src)

    // Mettre à jour les états
    this.isLoading = false
    this.isLoaded = true
    this.hasError = false

    // Mettre à jour la source de l'image
    if (this.hasImageTarget) {
      this.imageTarget.src = src
    }

    // Afficher uniquement l'image
    this.hideSpinner()
    this.hideError()

    // Petit délai pour l'effet de transition
    setTimeout(() => {
      this.showImage()
    }, 100)

    // Dispatch d'un événement personnalisé
    this.dispatch("loaded", { detail: { src } })
  }

  handleLoadError(errorMessage) {
    console.log("Handling load error:", errorMessage)

    // Tentative de rechargement
    if (this.currentRetries < this.retryCountValue) {
      this.currentRetries++
      console.log(`Retry attempt ${this.currentRetries}/${this.retryCountValue}`)

      // Garder le spinner pendant le retry
      setTimeout(() => {
        if (!this.isLoaded) {
          this.loadImage()
        }
      }, 1000 * this.currentRetries) // Délai progressif

      return
    }

    // Mettre à jour les états
    this.isLoading = false
    this.isLoaded = false
    this.hasError = true

    // Afficher uniquement l'erreur
    this.hideSpinner()
    this.hideImage()
    this.showError(errorMessage)

    // Dispatch d'un événement d'erreur
    this.dispatch("error", { detail: { error: errorMessage } })
  }

  // Action pour relancer le chargement manuellement
  retry() {
    console.log("Manual retry triggered")
    this.currentRetries = 0
    this.isLoading = false
    this.isLoaded = false
    this.hasError = false

    this.initializeState()
    this.loadImage()
  }

  // Nettoyage à la déconnexion
  disconnect() {
    this.isLoading = false
    console.log("Admin Image Loader disconnected")
  }
}
