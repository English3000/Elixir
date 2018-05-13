// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import React from "react";
import { AppRegistry, View, Text, Platform, Dimensions, StyleSheet } from "react-native";
import { QueryRenderer, graphql } from "react-relay";
import environment from "./environment";
import ErrorBoundary from "./components/ErrorBoundary";
import { BrowserRouter } from "react-router-dom";
import Page from "./pages";
import Screen from "./screens";

const Root = () => (
  <ErrorBoundary>
    <BrowserRouter>
      <QueryRenderer environment={environment} query={query}
        render={({ error, props }) => { //console.log(props);
        if (error)      { return <View><Text>{error.message}</Text></View>; }
        else if (props && Platform.OS === "web")
                        { return <ErrorBoundary><Page data={props}/></ErrorBoundary>; }
        else if (props) { return <ErrorBoundary><Screen data={props}/></ErrorBoundary>; }
        else            { return <View><Text>Loading...</Text></View>; }
      }}/>
    </BrowserRouter>
  </ErrorBoundary>
);

const query = graphql`
  query appQuery {
    ...List
    ...HeaderSession
  }
`;

AppRegistry.registerComponent("Root", () => Root);
AppRegistry.runApplication("Root", {rootTag: document.getElementById("replace-with-js")});
//==================

const { width, height } = Dimensions.get("window");

export const styles = StyleSheet.create({
  central:  { alignItems: "center", justifyContent: "center" },
  absolute: { position: "absolute", width, height },
  topRound: {borderTopLeftRadius: 5, borderTopRightRadius: 5, borderBottomWidth: 0.85},
  bottomRound: {borderBottomLeftRadius: 5, borderBottomRightRadius: 5, borderTopWidth: 0.85},
  header: { backgroundColor: "#e00082", alignItems: "center", paddingVertical: 12.5 },
});
