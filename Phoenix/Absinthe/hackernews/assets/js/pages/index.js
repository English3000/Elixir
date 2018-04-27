import React from "react";
import { AppRegistry, View, Text } from "react-native";
import Router from "./Router";

export default class Page extends React.Component {
  render() {
    return <View>
             <Text>WEB HEADER</Text>
             <Router/>
             <Text>WEB FOOTER</Text>
           </View>;
  }
}

AppRegistry.registerComponent("Page", () => Page);
