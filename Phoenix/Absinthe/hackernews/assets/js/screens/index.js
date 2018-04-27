import React from "react";
import { AppRegistry, View, Text } from "react-native";
import Router from "./Router";

export default class Screen extends React.Component {
  render() {
    return <View>
             <Text>MOBILE HEADER</Text>
             <Router/>
             <Text>MOBILE FOOTER</Text>
           </View>;
  }
}

AppRegistry.registerComponent("Screen", () => Screen);
