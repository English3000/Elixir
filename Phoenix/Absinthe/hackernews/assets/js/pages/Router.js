import React from "react";
import { Platform, AppRegistry } from "react-native";
import { withRouter, Switch, Route } from "react-router-dom";
import ErrorBoundary from "../components/ErrorBoundary";
import List from "../components/List";
import Form from "../components/Form";

const PageRouter = () => (
  <ErrorBoundary>
    <Switch>
      <Route exact path="/" component={List}/>
      <Route exact path="/create" component={Form}/>
    </Switch>
  </ErrorBoundary>
);

AppRegistry.registerComponent("PageRouter", () => PageRouter);
export default withRouter(PageRouter);
