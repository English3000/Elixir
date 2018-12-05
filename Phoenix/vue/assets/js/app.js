import css from "../css/app.css"
import "phoenix_html"
import React, { useState } from "react"
import { render } from "react-dom"

// really, this is simulating backend data, making it an unrealistic example...
let reactUsers = {
  Alex: ["I crashed my car today!",          "I ate someone's chocolate!" ] ,
  John: ["Yesterday, someone stole my bag!", "Someone ate my chocolate..."]
}

function Storyboard({users}){
  let [query, setQuery] = useState(""),
      [data,  setData]  = useState(users)

  function handleChange(event){
    setQuery(event.target.value)

    let newData = {}
    for (const key in users) {
      newData[key] = users[key].filter(
                       story => story.includes(event.target.value)
                     )
    }

    setData(newData)
  }

  return <div>
           <input type="text"
                  placeholder="Search for stories... with React Hooks!"
                  value={query}
                  onChange={handleChange}/>

           <ul>{Object.entries(data).map(([name, stories]) =>
             stories.map((story, index) =>
               <li key={index}>
                 {name} posted "{story}"
               </li>
             )
           )}</ul>
         </div>
}

render( <Storyboard users={reactUsers}/>, document.getElementById("react-storyboard") )
