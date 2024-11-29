import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="goban"
export default class extends Controller {
  static targets = ["intersection"]

  static values = {
    gameid: Number,
    color: String
  }

  connect() {
    console.log(this.colorValue)
  }

  play(event) {
    // console.log("coucou")
    let intersection = event.currentTarget;

    // Si une pierre est déjà posée, on ne fait rien
    // if (intersection.querySelector('.stone')) {
    //   return;
    // }
    if (intersection.dataset.status !== "empty") {
      return;
    }

    // Créer une nouvelle pierre
    const stone = document.createElement('div');
    stone.classList.add('stone', this.colorValue);

  // Placer la pierre dans l'intersection
  intersection.appendChild(stone);
  intersection.dataset.status = "black"

  // fetch(url)
  // .then(response => response.json())
  // .then((data) => {
  //   console.log(data);
  // });


 }
}
