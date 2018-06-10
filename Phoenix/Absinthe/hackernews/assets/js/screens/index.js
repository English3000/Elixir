import React from "react";
import { AppRegistry, View, Text, StyleSheet } from "react-native";
import Router from "../components/Router";

const Screen = ({ data }) => (
  <View>
    <Text style={{fontWeight: "700"}}>MOBILE HEADER</Text>
    <Router data={data}/>
    <Text style={{fontWeight: "700"}}>MOBILE FOOTER</Text>
  </View>
);

AppRegistry.registerComponent("Screen", () => Screen);

export const screenStyles = StyleSheet.create({
  textInput: { paddingTop: 6,
               paddingLeft: 15,
               paddingRight: 6,
               paddingBottom: 9,
               borderWidth: 1.7,
               backgroundColor: "white",
               borderColor: "black" },
});

export default Screen;
