import React from "react";
import { AppRegistry, View, Text } from "react-native-web";

export default class WebHome extends React.Component {
  render() { return <View><Text>WEB HOME PAGE</Text></View>; }
}

AppRegistry.registerComponent("WebHome", () => WebHome);
