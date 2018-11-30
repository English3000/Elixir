import css from "../css/app.css"
import "phoenix_html"
// Change to `vue.min.js` in prod
import Counter from "./vues/counter.js"
import Calculator from "./vues/calculator.js"

import Vue from "vue/dist/vue.js"

function b(){ return this.a + 1 }

new Vue({ el: "#computed", data: {a: 4}, computed: {b} })
