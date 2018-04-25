import React from "react";
import { AppRegistry, View, Text } from "react-native";
import Router from "../components/Router";

export default class Screen extends React.Component {
  render() {
    return [
      <View key="header"><Text>MOBILE HEADER</Text></View>,
      <Router key="router"/>,
      <View key="footer"><Text>MOBILE FOOTER</Text></View>,
    ];
  }
}

AppRegistry.registerComponent("Screen", () => Screen);
