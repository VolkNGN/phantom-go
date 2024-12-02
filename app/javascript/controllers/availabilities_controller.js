import { Controller } from "@hotwired/stimulus"
import { createConsumer } from  "@rails/actioncable"

// Connects to data-controller="availabilities"
export default class extends Controller {
  static values = {
    id: Number
  }
  connect() {
     this.channel = createConsumer().subscriptions.create(
      {
        channel: "AvailabilitiesChannel",
        id: this.idValue
      },
      {
        received: (data) => {
          window.location.href = data.url;
        }

      }



    )
  }
}
