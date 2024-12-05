import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="goban"
export default class extends Controller {
  static targets = ["intersection"]

  static values = {
    gameid: Number,
    color: String
  }

  connect() {
    // console.log(this.colorValue)
  }

  play(event) {
    // console.log("coucou")
    let intersection = event.currentTarget;

    // Si une pierre est déjà posée, on ne fait rien
    // if (intersection.querySelector('.stone')) {
    //   return;
    // }
    // if (intersection.dataset.status !== "empty" || this.colorValue === this.lastColorValue) {
    //   return;
    // }

    // Créer une nouvelle pierre
    // const stone = document.createElement('div');
    // stone.classList.add('stone', this.colorValue);

  // Placer la pierre dans l'intersection
  // intersection.appendChild(stone);
  // intersection.dataset.status = this.colorValue;

  // Le fetch envoie les données au serveur
  fetch(`${this.gameidValue}/play`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({"color": this.colorValue, "column":intersection.dataset.column, "row":intersection.dataset.row})
  })
  .then(response => {
    if (response.ok) {
      location.reload();
    }
  })

 }
}
