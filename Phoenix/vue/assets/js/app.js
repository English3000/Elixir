import css from "../css/app.css"
import "phoenix_html"
import React, { useState } from "react"
import { render } from "react-dom"

// Input -> Storyboard, 26:30 ~ https://www.youtube.com/watch?v=dpw9EHDh2bM
function Storyboard(){
  const [query, setQuery] = useState("")

  function handleChange(event){ setQuery(event.target.value) }

  return (
    <input type="text"
           placeholder="Search for stories... with React Hooks!"
           value={query}
           onChange={handleChange}/>
  )
}

render( <Storyboard/>, document.getElementById("react-storyboard") )
