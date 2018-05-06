import React from "react";
import { AppRegistry, View, Dimensions, StyleSheet } from "react-native";
import Header from "./Header";
import Router from "../components/Router";
import Footer from "./Footer";
import { styles } from "../app";

const Page = ({data}) => (
  <View>
    <Header data={data}/>
    <Router data={data}/>
    <Footer style={{position: "absolute", marginTop: height - 45, width, alignItems: "center", paddingVertical: 12.5}}/>
  </View>
);

AppRegistry.registerComponent("Page", () => Page);

export default Page;
//==================

const { width, height } = Dimensions.get("window");

export const pageStyles = StyleSheet.create({
  modal: { flexDirection: "row", padding: 15, backgroundColor: "pink", borderRadius: 5 },
  textInput: {paddingTop: 3, paddingBottom: 4.5, paddingRight: 5, paddingLeft: 7.5, borderWidth: 1.7, borderColor: "black"},
});
