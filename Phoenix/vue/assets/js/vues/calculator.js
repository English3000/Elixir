import Vue from "vue/dist/vue.js"

let data = {
  x:         null,
  y:         null,
  operation: "+"
}

function z(){
  if (this.x && this.y) {
    switch(this.operation){
      case "+": return this.x + this.y
      case "-": return this.x - this.y
      case "*": return this.x * this.y
      case "/": return this.x / this.y
    }
  }
}

export default new Vue({ el: "#calculator", data, computed: {z} })
