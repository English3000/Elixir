import React from "react";
import { AppRegistry, View, Text, Dimensions, StyleSheet } from "react-native";
import Router from "../components/Router";
// import Footer from "./Footer";

const Page = ({ data }) => (
  <View>
    <Router data={data}/>
    <Text style={custom.footer}>ADD YOUR OWN STYLED FOOTER</Text>
  </View>
);

AppRegistry.registerComponent("Page", () => Page);

export default Page;
//==================

const { width, height } = Dimensions.get("window");

const custom = StyleSheet.create({
  footer: { position: "absolute",
            marginTop: height - 45,
            width,
            alignItems: "center",
            paddingVertical: 12.5 }
});

export const pageStyles = StyleSheet.create({
  textInput: { paddingTop: 3,
               paddingBottom: 4.5,
               paddingRight: 5,
               paddingLeft: 7.5,
               borderWidth: 1.7,
               borderColor: "black" },
      modal: { flexDirection: "row",
               padding: 15,
               backgroundColor: "pink",
               borderRadius: 5 },
});
