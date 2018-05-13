import React from "react";
import { AppRegistry, View, Text } from "react-native";

export default class ErrorBoundary extends React.Component {
  constructor() {
    super();
    this.state = {error: null};
  }

  componentDidCatch(error) { this.setState({error}); }

  render() {
    const {error} = this.state;
    return error ? <View><Text>{error.toString()}</Text></View> : this.props.children;
  }
}

AppRegistry.registerComponent("ErrorBoundary", () => ErrorBoundary);
