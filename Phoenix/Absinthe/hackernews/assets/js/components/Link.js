import React from "react";
import { AppRegistry, Text } from "react-native";
import ErrorBoundary from "./ErrorBoundary";

export default class Link extends React.Component {
  // async vote() {}

  render() {
    const {description, url} = this.props.data;

    return (
      <ErrorBoundary>
        <Text>{url}</Text>
        {description ? <Text>{description}</Text> : null}
      </ErrorBoundary>
    );
  }
}

AppRegistry.registerComponent("Link", () => Link);
