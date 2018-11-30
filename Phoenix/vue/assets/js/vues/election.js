import Vue from "vue/dist/vue.js"

let data = {
  A:      0,
  B:      0,
  C:      0,
  D:      0,
  nobody: 0,
}

let methods = {
  vote_A:      function(){ this.A++ },
  vote_B:      function(){ this.B++ },
  vote_C:      function(){ this.C++ },
  vote_D:      function(){ this.D++ },
  vote_nobody: function(){ this.nobody++ },

  restart: function(){ Object.keys(data) .forEach(key => this[key] = 0) }
}

export default new Vue({ el: "#ballot", data, methods })
