import React from "react";
import { AppRegistry, View, Text } from "react-native";
import Router from "./Router";

export default class Page extends React.Component {
  render() {
    return (
      <View>
        <Text style={{fontWeight: "700"}}>WEB HEADER</Text>
        <Router data={this.props.data}/>
        <Text style={{fontWeight: "700"}}>WEB FOOTER</Text>
      </View>
    );
  }
}

AppRegistry.registerComponent("Page", () => Page);
