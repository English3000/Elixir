import React from "react";
import { AppRegistry, View } from "react-native";
import { createFragmentContainer, graphql } from "react-relay";
import Link from "./Link";

class List extends React.Component {
  render() {
    console.log(this.props);
    //mock data
    // const links = [{
    //   id: '1',
    //   description: 'The coolest GraphQL backend 😎',
    //   url: 'https://www.graph.cool'
    // }, {
    //   id: '2',
    //   description: 'Highly performant GraphQL client from Facebook',
    //   url: 'https://facebook.github.io/relay/'
    // }]
    const {data} = this.props;
    return <View>{data ? data.allLinks.map(link => <Link key={link.id} data={link}/>) : null}</View>;
  }
}

AppRegistry.registerComponent("List", () => List);

export default createFragmentContainer(List, graphql`
  fragment List on RootQueryType { allLinks { ...Link } }
`); //not working
