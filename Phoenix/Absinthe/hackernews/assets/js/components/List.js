import React from "react";
import { AppRegistry, View, Text } from "react-native";
import Link from "./Link";

export default class List extends React.Component {
  render() {
    //mock data
    const links = [{
      id: '1',
      description: 'The coolest GraphQL backend 😎',
      url: 'https://www.graph.cool'
    }, {
      id: '2',
      description: 'Highly performant GraphQL client from Facebook',
      url: 'https://facebook.github.io/relay/'
    }]

    return <View>{links.map(link => <Link key={link.id} data={link}/>)}</View>;
  }
}

AppRegistry.registerComponent("List", () => List);
