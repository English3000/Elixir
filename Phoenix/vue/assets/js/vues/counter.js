import Vue from "vue/dist/vue.js"

export default {
  Inline: new Vue({ el:   "#inline-counter",
                    data: { upvotes: 0 } })

, Method: new Vue({ el:      "#method-counter",
                    data:    { upvotes: 0 },
                    methods: { upvote: function(){ this.upvotes++ }} })
}
