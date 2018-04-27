import React from "react";
import { AppRegistry } from "react-native-web";
import List from "../components/List";

export default class HomeScreen extends React.Component {
  render() { return <List/>; }
}

AppRegistry.registerComponent("HomeScreen", () => HomeScreen);
