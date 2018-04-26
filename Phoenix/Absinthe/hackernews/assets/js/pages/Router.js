import React from "react";
import { Platform, AppRegistry } from "react-native";
import { withRouter, Switch, Route } from "react-router-dom";
import ErrorBoundary from "../components/ErrorBoundary";
import Home from "./Home";

const WebRouter = () => (
  <ErrorBoundary>
    <Switch>
      <Route exact path="/" component={Home}/>
    </Switch>
  </ErrorBoundary>
);

AppRegistry.registerComponent("WebRouter", () => WebRouter);
export default withRouter(WebRouter);
