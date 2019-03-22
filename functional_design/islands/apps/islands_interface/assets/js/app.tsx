import "../css/app.css"
import "phoenix_html"

import React from "react"
import { AppRegistry } from "react-native"
import ErrorBoundary from "./components/ErrorBoundary.js"
import Game, { Undux } from "./Game"

const App = () => <ErrorBoundary>
                    <Undux.Container>
                      <Game />
                    </Undux.Container>
                  </ErrorBoundary>

AppRegistry.registerComponent("App", () => App)
AppRegistry.runApplication("App", {rootTag: document.getElementById("islands")})