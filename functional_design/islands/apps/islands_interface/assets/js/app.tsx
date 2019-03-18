// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into its own CSS file.
// @ts-ignore
import css from "../css/app.css" // false positive: -(+)

// Webpack automatically bundles all modules in your entry points.
// Those entry points can be configured in "webpack.config.js".

// Import dependencies
import "phoenix_html"

// Import local files using relative paths
import * as React from "react"
// @ts-ignore
import { AppRegistry } from "react-native"
import Game, { Undux } from "./Game"

const App = () => <Undux.Container>
                    <Game/>
                  </Undux.Container>

AppRegistry.registerComponent("App", () => App)
AppRegistry.runApplication("App", {rootTag: document.getElementById("islands")})
