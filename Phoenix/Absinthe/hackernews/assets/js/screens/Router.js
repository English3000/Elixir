import React from "react";
import { Platform, AppRegistry } from "react-native";
import { withRouter, Switch, Route } from "react-router-native";
import ErrorBoundary from "../components/ErrorBoundary";
import Home from "./Home";

const MobileRouter = () => (
  <ErrorBoundary>
    <Switch>
      <Route exact path="/" component={Home}/>
    </Switch>
  </ErrorBoundary>
);

AppRegistry.registerComponent("MobileRouter", () => MobileRouter);
export default withRouter(MobileRouter);
