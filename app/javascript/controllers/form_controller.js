import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  onRequest() {
    this.showSpinner()
  }

  onResponse() {
    this.element.reset()
  }
}
