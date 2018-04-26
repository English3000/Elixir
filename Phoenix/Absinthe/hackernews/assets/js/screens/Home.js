import React from "react";
import { AppRegistry, View, Text } from "react-native-web";

export default class MobileHome extends React.Component {
  render() { return <View><Text>MOBILE HOME SCREEN</Text></View>; }
}

AppRegistry.registerComponent("MobileHome", () => MobileHome);
