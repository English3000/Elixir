import React from "react";
import { Platform, AppRegistry } from "react-native";
import { withRouter, Switch, Route } from "react-router-dom";
import ErrorBoundary from "../components/ErrorBoundary";
import Home from "./Home";

const PageRouter = () => (
  <ErrorBoundary>
    <Switch>
      <Route exact path="/" component={Home}/>
    </Switch>
  </ErrorBoundary>
);

AppRegistry.registerComponent("PageRouter", () => PageRouter);
export default withRouter(PageRouter);
