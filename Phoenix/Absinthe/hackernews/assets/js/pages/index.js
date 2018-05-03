import React from "react";
import { AppRegistry, View, Text, Dimensions, StyleSheet } from "react-native";
import Header from "./Header";
import Router from "../components/Router";

const Page = ({data}) => (
  <View>
    <Header />
    <Router data={data}/>
    <Text style={{fontWeight: "700"}}>WEB FOOTER</Text>
  </View>
);

AppRegistry.registerComponent("Page", () => Page);

export default Page;
//==================

const { width, height } = Dimensions.get("window");

export const webStyles = StyleSheet.create({
  modal: { width: width * 0.5, height: height * 0.33, backgroundColor: "pink", borderRadius: 5 }
});
