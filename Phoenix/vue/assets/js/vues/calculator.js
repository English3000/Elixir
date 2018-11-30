import Vue from "vue/dist/vue.js"

let data = {
  x:         null,
  y:         null,
  z:         null,
  operation: "+"
}

function calculate(event){// @L 369
  event.preventDefault()

  switch(this.operation){
    case "+": this.z = this.x + this.y ; break
    case "-": this.z = this.x - this.y ; break
    case "*": this.z = this.x * this.y ; break
    case "/": this.z = this.x / this.y ; break
  }
}

export default new Vue({ el: "#calculator", data, methods: {calculate} })
