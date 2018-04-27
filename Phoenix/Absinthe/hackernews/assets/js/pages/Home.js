import React from "react";
import { AppRegistry } from "react-native-web";
import List from "../components/List";

export default class HomePage extends React.Component {
  render() { return <List/>; }
}

AppRegistry.registerComponent("HomePage", () => HomePage);
