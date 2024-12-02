import { createConsumer } from "@rails/actioncable";

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game"
export default class extends Controller {
  connect() {
    this.channel = createConsumer().subscriptions.create(
      {channel: "GameChannel", gameid: 1, playerid: 1},
      {received: (data) => {
        console.log(data)
      }}
    )
  }
}
