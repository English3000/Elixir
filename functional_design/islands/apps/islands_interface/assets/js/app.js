// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into its own CSS file.
import css from "../css/app.css"

// Webpack automatically bundles all modules in your entry points.
// Those entry points can be configured in "webpack.config.js".

// Import dependencies
import "phoenix_html"

// Import local files using relative paths
import React from "react"
import { AppRegistry } from "react-native"
import Game from "./Game.js"

AppRegistry.runApplication( "Game", {rootTag: document.getElementById("islands")} )
