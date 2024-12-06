import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    minutes: Number,
    seconds: Number,
    isPlaying: Boolean
  }

  connect() {
    window[`${this.element.id}Controller`] = this

    this.timer = null
    this.remainingTime = (this.minutesValue * 60) + this.secondsValue

    if (this.isPlayingValue) {
      this.start()
    }
  }

  disconnect() {
    window.timerController = null
    this.stop()
  }

  start() {
    if (this.timer) return

    this.timer = setInterval(() => {
      this.remainingTime--

      if (this.remainingTime <= 0) {
        this.stop()
        // TODO : Fetch GameOver
      }

      this.#updateDisplay()
    }, 1000)
  }

  stop() {
    if (!this.timer) return

    clearInterval(this.timer)
    this.timer = null
  }

  #updateDisplay() {
    const minutes = Math.floor(this.remainingTime / 60)
    const seconds = this.remainingTime % 60

    const formattedMinutes = minutes.toString().padStart(2, '0')
    const formattedSeconds = seconds.toString().padStart(2, '0')

    this.element.textContent = `${formattedMinutes}:${formattedSeconds}`
  }
}
