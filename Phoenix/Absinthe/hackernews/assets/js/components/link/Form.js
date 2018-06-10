import React from "react";
import { AppRegistry, View, Text, TextInput, TouchableOpacity, Dimensions, StyleSheet } from "react-native";
import ErrorBoundary from "../ErrorBoundary";
import { commitMutation, graphql } from "react-relay";
import environment from "../../environment";
import { styles } from "../../app";

export default class Form extends React.Component {
  constructor() {
    super();
    this.state = {description: "", url: ""};
    this.createLink = this.createLink.bind(this);
  }

  render() {
    const { format } = this.props;

    return (
      <ErrorBoundary>
        <View style={[{width}, styles.central]}>
          <View style={custom.fields}>
            <TextInput onChangeText={url => this.setState({url})}
                       placeholder="Link URL"
                       value={this.state.url}
                       style={[format.textInput, {marginTop: 12.5}]}/>
            <TextInput onChangeText={description => this.setState({description})}
                       placeholder="Link Description"
                       multiline={true}
                       value={this.state.description}
                       style={[format.textInput, {marginTop: 5, marginBottom: 8.75}]}/>
            <TouchableOpacity style={[styles.central, {backgroundColor: "royalblue", borderRadius: 5, padding: 5}]}
                              onPress={this.createLink}>
              <Text style={styles.text}>Create Link</Text>
            </TouchableOpacity>
          </View>
        </View>
      </ErrorBoundary>
    );
  }

  createLink() {
    const { description, url } = this.state;
    const variables = {input: { description, url, clientMutationId: "" }};

    commitMutation(environment, {
      mutation,
      variables,
      onCompleted: () => this.props.history.push("/"),
      onError: err => console.error(err)
    });
  }
}

const mutation = graphql`
  mutation FormMutation($input: LinkInput!) {
    createLink(input: $input) {
      link {
        id
        description
        url
      }

      errors {
        key
        message
      }
    }
  }
`;

const { width } = Dimensions.get("window");

const custom = StyleSheet.create({
  fields: { width: 250,
            marginHorizontal: 10,
            backgroundColor: "white",
            borderRadius: 5 },
});

AppRegistry.registerComponent("LinkForm", () => Form);
