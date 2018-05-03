import React from "react";
import { AppRegistry, View, Text, Linking } from "react-native";
import { createFragmentContainer, graphql } from "react-relay";
import ErrorBoundary from "./ErrorBoundary";

class Link extends React.Component {
  // async vote() {}

  render() {
    const {description, url} = this.props.data;

    return (
      <ErrorBoundary>
        <View style={{flexDirection: "row", marginVertical: 5}}>
          <Text style={{color: "#0000cc"}} onPress={() => Linking.openURL(url)}>{url}</Text>
          {description ? <Text> ~ {description}</Text> : null}
        </View>
      </ErrorBoundary>
    );
  }
}

AppRegistry.registerComponent("Link", () => Link);

export default createFragmentContainer(Link, graphql`
  fragment Link on Link {
    id
    description
    url
  }
`);
