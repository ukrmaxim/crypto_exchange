import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["exRate", "exFee", "netFee", "sendAmount", "getAmount", "exFeeAmount", "exFeeAmountHidden"]

  updateGetAmount() {
    const exfee = this.exFeeTarget.textContent / 100
    const exrate = Number(this.exRateTarget.textContent - (this.exRateTarget.textContent * exfee))
    const netfee = Number(this.netFeeTarget.textContent)
    const sum = (this.sendAmount() * exrate) - netfee
    if (sum > 0) {
      this.getAmountTarget.value = sum.toFixed(8)
    } else {
      this.getAmountTarget.value = 0
    }
  }

  updateSendAmount() {
    const exfee = this.exFeeTarget.textContent / 100
    const exrate = Number(this.exRateTarget.textContent - (this.exRateTarget.textContent * exfee))
    const netfee = Number(this.netFeeTarget.textContent)
    const sum = (this.getAmount() + netfee) / exrate
    console.log(sum)
    if (sum > 0) {
      this.sendAmountTarget.value = sum.toFixed(3)
    } else {
      this.sendAmountTarget.value = 0
    }
  }

  updateExFeeAmount() {
    const exrate = Number(this.exRateTarget.textContent)
    const exfee = Number(this.exFeeTarget.textContent) / 100
    const sum = (this.sendAmount() * exrate) * exfee
    if (sum > 0) {
      this.exFeeAmountTarget.textContent = sum.toFixed(8)
      this.exFeeAmountHiddenTarget.value = sum.toFixed(8)
    } else {
      this.exFeeAmountTarget.textContent = 0
      this.exFeeAmountHiddenTarget.value = 0
    }
  }

  // updateGetExFeeAmount() {
  //   const netfee = Number(this.netFeeTarget.textContent)
  //   const exrate = Number(this.exRateTarget.textContent)
  //   const exfee = Number(this.exFeeTarget.textContent) / 100
  //   const sum = ((this.getAmount() + netfee) + ((this.getAmount() + netfee) * exfee)) * exfee
  //   console.log(exrate, exfee, sum)
  //   if (sum > 0) {
  //     this.exFeeAmountTarget.textContent = sum.toFixed(8)
  //   } else {
  //     this.exFeeAmountTarget.textContent = 0
  //   }
  // }

  sendAmount() {
    return Number(parseFloat(this.sendAmountTarget.value))
  }

  getAmount() {
    return Number(parseFloat(this.getAmountTarget.value))
  }
}
