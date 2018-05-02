import React from "react";
import { AppRegistry, View, Text } from "react-native";
import Router from "../components/Router";

export default class Screen extends React.Component {
  render() {
    return (
      <View>
        <Text style={{fontWeight: "700"}}>MOBILE HEADER</Text>
        <Router data={this.props.data}/>
        <Text style={{fontWeight: "700"}}>MOBILE FOOTER</Text>
      </View>
    );
  }
}

AppRegistry.registerComponent("Screen", () => Screen);
