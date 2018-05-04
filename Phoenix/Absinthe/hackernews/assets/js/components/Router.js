import React from "react";
import { AppRegistry } from "react-native";
import { Switch, Route } from "react-router-dom";
import ErrorBoundary from "./ErrorBoundary";
import List from "./link/List";
import Form from "./link/Form";

const Router = ({data}) => (
  <ErrorBoundary>
    <Switch>
      <Route exact path="/" render={() => <List data={data}/>}/>
      <Route exact path="/create" component={Form}/>
    </Switch>
  </ErrorBoundary>
);

AppRegistry.registerComponent("Router", () => Router);

export default Router;
