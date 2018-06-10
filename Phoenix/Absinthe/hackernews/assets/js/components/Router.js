import React from "react";
import { AppRegistry, Platform } from "react-native";
import { Switch, Route } from "react-router-dom";
import ErrorBoundary from "./ErrorBoundary";
import List from "./link/List";
import Form from "./link/Form";
import { pageStyles } from "../pages";
import { screenStyles } from "../screens";

const Router = ({ data }) => {
  const format = (Platform.OS === "web") ? pageStyles : screenStyles;

  return (
    <ErrorBoundary>
      <Switch>
        <Route exact path="/" render={() => <List data={data}/>}/>
        <Route exact path="/create" render={() => <Form format={format}/>}/>
      </Switch>
    </ErrorBoundary>
  );
}

AppRegistry.registerComponent("Router", () => Router);

export default Router;
