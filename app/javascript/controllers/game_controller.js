import {createConsumer} from "@rails/actioncable";

import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="game"
export default class extends Controller {
  static values = {
    gameid: Number,
    playerid: Number
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      {channel: "GameChannel", gameid: this.gameidValue, playerid: this.playeridValue},
      {
        received: (data) => {
          window["opponent-timerController"].stop()
          window['current-timerController'].start()
          Turbo.renderStreamMessage(data.html)
        }
      }
    )
  }
}
