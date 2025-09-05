import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["variants"];

  connect() {
    console.log("NestedForm controller connected!");
  }

  add(event) {
    event.preventDefault();
    console.log("Add variant clicked");
    const timestamp = new Date().getTime();
    const newVariant = `
      <div class="variant-form mb-3 border p-3">
        <label class="form-label">Contenance (ex: 50ml)</label>
        <input type="text" name="parfum[variants_attributes][${timestamp}][size]" class="form-control" required>
        <div class="invalid-feedback">Veuillez spécifier une contenance</div>
        <label class="form-label">Prix</label>
        <input type="number" step="0.01" name="parfum[variants_attributes][${timestamp}][price]" class="form-control" required min="0.01">
        <div class="invalid-feedback">Veuillez spécifier un prix supérieur à 0</div>
        <button type="button" class="btn btn-danger mt-2" data-action="click->nested-form#remove">Supprimer</button>
      </div>
    `;
    this.variantsTarget.insertAdjacentHTML('beforeend', newVariant);
  }

  remove(event) {
    event.preventDefault();
    console.log("Remove variant clicked");
    const wrapper = event.target.closest('.variant-form');
    const destroyInput = wrapper.querySelector('input[name*="_destroy"]');
    if (destroyInput) {
      destroyInput.value = '1';
      wrapper.style.display = 'none';
    } else {
      wrapper.remove();
    }
  }
}