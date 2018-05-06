import React from "react";
import { AppRegistry, View, Text, Linking } from "react-native";
import { createFragmentContainer, graphql } from "react-relay";
import ErrorBoundary from "../ErrorBoundary";

const Link = ({data}) => (
  <ErrorBoundary>
    <View style={{flexDirection: "row", marginVertical: 5}}>
      <Text style={{color: "#0000cc"}}
            onPress={() => Linking.openURL(data.url)}>{data.url}</Text>
      {data.description ? <Text> ~ {data.description}</Text> : null}
    </View>
  </ErrorBoundary>
);

AppRegistry.registerComponent("Link", () => Link);

export default createFragmentContainer(Link, graphql`
  fragment Link on Link {
    description
    url
  }
`);
