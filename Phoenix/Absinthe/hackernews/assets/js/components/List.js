import React from "react";
import { AppRegistry, View } from "react-native";
import { createFragmentContainer, graphql } from "react-relay";
import Link from "./Link";

const List = ({data}) => (
  <View style={{marginVertical: 5}}>{data ?
    data.allLinks.map(link => <Link key={link["__id"]} data={link}/>) : null
  }</View>
);

AppRegistry.registerComponent("List", () => List);

export default createFragmentContainer(List, graphql`
  fragment List on RootQueryType {
    allLinks {
      ...Link
    }
  }
`);
