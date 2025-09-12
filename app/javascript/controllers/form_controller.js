import { Controller } from "@hotwired/stimulus"
import { debounce } from "helpers/timing_helpers";

export default class extends Controller {
  static targets = [ "cancel" ]

  static values = {
    debounceTimeout: { type: Number, default: 300 }
  }

  initialize() {
    this.debouncedSubmit = debounce(this.debouncedSubmit.bind(this), this.debounceTimeoutValue)
  }

  submit() {
    this.element.requestSubmit()
  }

  debouncedSubmit(event) {
    this.submit(event)
  }

  submitToTopTarget(event) {
    this.element.setAttribute("data-turbo-frame", "_top")
    this.submit()
  }

  cancel() {
    this.cancelTarget?.click()
  }

  preventAttachment(event) {
    event.preventDefault()
  }

  select(event) {
    event.target.select()
  }
}
