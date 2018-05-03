import React from "react";
import { AppRegistry, View, TextInput, Button } from "react-native";
import ErrorBoundary from "./ErrorBoundary";
import { commitMutation, graphql } from "react-relay";
import environment from "../environment";

const mutation = graphql`
  mutation FormMutation($input: LinkInput!) {
    createLink(input: $input) {
      link {
        id
        description
        url
        # insertedAt
      }
    }
  }
`;

export default class Form extends React.Component {
  constructor() {
    super();
    this.state = {description: "", url: ""};
    this.createLink = this.createLink.bind(this);
  }

  render() {
    return (
      <ErrorBoundary>
        <TextInput onChangeText={description => this.setState({description})}
                   placeholder="Link Description"
                   value={this.state.description}/>
        <TextInput onChangeText={url => this.setState({url})}
                   placeholder="Link URL"
                   value={this.state.url}/>
        <View style={{width: "20%"}}>
          <Button title="Create Link" onPress={this.createLink}/>
        </View>
      </ErrorBoundary>
    );
  }

  createLink() {
    const {description, url} = this.state;
    const variables = {input: {description, url, clientMutationId: ""}};

    commitMutation( environment, { mutation, variables,
                    onCompleted: () => this.props.history.push("/"),
                    onError: err => console.error(err) } )
  }
}

AppRegistry.registerComponent("LinkForm", () => Form);
