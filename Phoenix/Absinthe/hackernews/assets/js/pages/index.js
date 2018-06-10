import React from "react";
import { AppRegistry, View, Dimensions, StyleSheet } from "react-native";
import Header from "./Header";
import Router from "../components/Router";
import Footer from "./Footer";

const Page = ({ data }) => (
  <View>
    <Header data={data}/>
    <Router data={data}/>
    <Footer style={custom.footer}/>
  </View>
);

const { width, height } = Dimensions.get("window");

const custom = StyleSheet.create({
  footer: { position: "absolute",
            marginTop: height - 45,
            width,
            alignItems: "center",
            paddingVertical: 12.5 }
});

AppRegistry.registerComponent("Page", () => Page);

export const pageStyles = StyleSheet.create({
  textInput: { paddingTop: 3,
               paddingLeft: 7.5,
               paddingRight: 5,
               paddingBottom: 4.5,
               borderWidth: 1.7,
               backgroundColor: "white",
               borderColor: "black" },

      modal: { flexDirection: "row",
               padding: 15,
               backgroundColor: "pink",
               borderRadius: 5 },
});

export default Page;
