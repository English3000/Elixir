import React from "react";
import { AppRegistry, View, Text, TextInput, Button, TouchableOpacity, StyleSheet, Platform } from "react-native";
import ErrorBoundary from "../ErrorBoundary";
import { commitMutation, graphql } from "react-relay";
import environment from "../../environment";
import { styles } from "../../app";
import { pageStyles } from "../../pages";
import { screenStyles } from "../../screens";

export default class Form extends React.Component {
  constructor() {
    super();
    this.state = { email: "", password: "" };
  }

  render() {
    const { email, password } = this.state;
    const format = (Platform.OS === "web") ? pageStyles : screenStyles;

    return (
      <ErrorBoundary>
        <View style={[format.modal, styles.central]}>
          <TouchableOpacity style={styles.central}
                            onPress={() => this.createSession(signUpMutation)}>
            <TouchableOpacity style={[custom.button, custom.signUp]}></TouchableOpacity>
            <Text style={[styles.text, {position: "absolute", marginTop: 19.5, textAlign: "center"}]}>{`Sign\nUp`}</Text>
          </TouchableOpacity>

          <View style={custom.fields}>
            <TextInput onChangeText={email => this.setState({email})}
                       placeholder="email"
                       value={email}
                       style={[format.textInput, styles.topRound]}/>
            <TextInput onChangeText={password => this.setState({password})}
                       placeholder="password"
                       value={password}
                       style={[format.textInput, styles.bottomRound]}/>
          </View>

          <TouchableOpacity style={styles.central}
                            onPress={() => this.createSession(signInMutation)}>
            <TouchableOpacity style={[custom.button, custom.signIn]}></TouchableOpacity>
            <Text style={[styles.text, {position: "absolute", marginLeft: -7.5}]}>Sign In</Text>
          </TouchableOpacity>
        </View>
      </ErrorBoundary>
    );
  }

  createSession(mutation) {
    const { email, password } = this.state;
    const variables = {email, password};
    console.log("pressed");

    commitMutation(environment, {
      mutation,
      variables,
      onCompleted: (resp, err) => console.log(resp, err),
      onError: err => console.log(err)
    });
  }
}

const custom = StyleSheet.create({
  fields: { width: 125,
            marginLeft: 10.25,
            marginRight: 13.75,
            borderRadius: 5 },

  button: { width: 0,
            height: 0,
            borderStyle: "solid",
            padding: 0,
            margin: 0,
            borderRadius: 0,
            backgroundColor: "transparent" },

  signUp: { borderTopWidth: 0,
            borderRightWidth: 35,
            borderBottomWidth: 55,
            borderLeftWidth: 35,
            borderColor: "transparent",
            borderBottomColor: "royalblue" },

  signIn: { borderTopWidth: 32,
            borderRightWidth: 0,
            borderBottomWidth: 32,
            borderLeftWidth: 55,
            borderColor: "transparent",
            borderLeftColor: "royalblue" },
});

const signUpMutation = graphql`
  mutation FormSignUpMutation($email: String!, $password: String!) {
    signUp(email: $email, password: $password) {
      # ...FormSession
      session {
        user {
          id
          name
          email
        }
      }

      errors {
        key
        message
      }
    }
  }
`;

const signInMutation = graphql`
  mutation FormSignInMutation($email: String!, $password: String!) {
    signIn(email: $email, password: $password) {
      # ...FormSession
      session {
        user {
          id
          name
          email
        }
      }

      errors {
        key
        message
      }
    }
  }
`;

const fragment = graphql`
  fragment FormSession on SessionResult {
    session {
      user {
        id
        name
        email
      }
    }

    errors {
      key
      message
    }
  }
`;

AppRegistry.registerComponent("UserForm", () => Form);
