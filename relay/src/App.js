import React, { Component } from 'react';
import { QueryRenderer, graphql } from 'react-relay';
import environment from "./relay-environment";
import NewMenuItemSubscription from "./subscriptions/NewMenuItemSubscription";

const query = graphql `query AppQuery { menuItems {id name} }`;

export default class App extends Component {
  componentDidMount() { NewMenuItemSubscription(); }
  
  renderMenuItem(menuItem) { return <li key={menuItem.id}>{menuItem.name}</li>; }

  render() {
    return <QueryRenderer environment={environment} query={query}
             render={({ error, props }) => {
        if (error) {      return <div>{error.message}</div>;
      } else if (props) { return <ul>{props.menuItems.map(this.renderMenuItem)}</ul>;
      } else {            return <div>Loading...</div>; }
    }}/>;
  }
}
