import React from "react";
import { AppRegistry, View, Dimensions, StyleSheet } from "react-native";
import Header from "./Header";
import Router from "../components/Router";
import Footer from "./Footer";

const Page = ({data}) => (
  <View>
    <Header data={data}/>
    <Router data={data}/>
    <Footer style={custom.footer}/>
  </View>
);

AppRegistry.registerComponent("Page", () => Page);

export default Page;
//==================

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

const { width, height } = Dimensions.get("window");

const custom = StyleSheet.create({
  footer: { position: "absolute",
            marginTop: height - 45,
            width,
            alignItems: "center",
            paddingVertical: 12.5 }
});
