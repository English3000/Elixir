import React from "react";
import { Platform, AppRegistry } from "react-native";
import ErrorBoundary from "./ErrorBoundary";

const routeLib = Platform.OS === "web" ? "dom" : "native";
import { withRouter, Switch, Route } from "react-router-" + routeLib;

const Router = () => (
  <ErrorBoundary>
    <Switch>
      <Route exact path="/" component={}/>
    </Switch>
  </ErrorBoundary>
);

AppRegistry.registerComponent("Router", () => Router);
export default withRouter(Router);
