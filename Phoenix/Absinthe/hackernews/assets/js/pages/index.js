import React from "react";
import { AppRegistry, View, Text } from "react-native";
import Router from "../components/Router";

export default class Page extends React.Component {
  render() {
    return [
      <View key="header"><Text>WEB HEADER</Text></View>,
      <Router key="router"/>,
      <View key="footer"><Text>WEB FOOTER</Text></View>,
    ];
  }
}

AppRegistry.registerComponent("Page", () => Page);
