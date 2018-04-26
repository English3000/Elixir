import React from "react";
import { View, Text } from "react-native";

export class ErrorBoundary extends React.Component {
  constructor() {
    super();
    this.state = {error: null};
  }

  componentDidCatch(error) { this.setState({error}); }

  render() { return this.state.error ?
    <View><Text>{this.state.error.toString()}</Text></View> : this.props.children;
  }
}

AppRegistry.registerComponent("ErrorBoundary", () => ErrorBoundary);
