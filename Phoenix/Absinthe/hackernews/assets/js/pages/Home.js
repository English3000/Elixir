import React from "react";
import { AppRegistry } from "react-native-web";
import Form from "../components/Form";

export default class HomePage extends React.Component {
  render() { return <Form/>; }
}

AppRegistry.registerComponent("HomePage", () => HomePage);
