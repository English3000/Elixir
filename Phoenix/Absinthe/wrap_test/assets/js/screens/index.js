import React from "react";
import { AppRegistry, View, Text, StyleSheet } from "react-native";
import Router from "../components/Router";
// import Footer from "./Footer";

export default class Screen extends React.Component {
  render() {
    return (
      <View>
        <Router data={this.props.data}/>
        <Text style={{fontWeight: "700"}}>ADD MOBILE FOOTER</Text>
      </View>
    );
  }
}

AppRegistry.registerComponent("Screen", () => Screen);

export const screenStyles = StyleSheet.create({});
