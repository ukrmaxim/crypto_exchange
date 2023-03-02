import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="showhide"
export default class extends Controller {
  static targets = ["input", "output"]
  static values = { showIf: String }
  connect() {
    this.outputTarget.hidden = true
  }

  toggle() {
    this.outputTarget.hidden = this.inputTarget.value !== this.showIfValue;
  }
}
