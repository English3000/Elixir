import React from "react";
import { AppRegistry, View, Text } from "react-native";

const Footer = props => (
  <View style={props.style}>
    <Text style={{color: "lightgray"}}>WEB FOOTER</Text>
  </View>
);

AppRegistry.registerComponent("PageFooter", () => Footer);

export default Footer;
