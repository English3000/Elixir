import React from "react";
import { AppRegistry, View, Text, TextInput, Button, StyleSheet, Platform } from "react-native";
import ErrorBoundary from "../ErrorBoundary";
import { commitMutation, graphql } from "react-relay";
import environment from "../../environment";
import { styles } from "../../app";
import { pageStyles } from "../../pages";
import { screenStyles } from "../../screens";

export default class Form extends React.Component {
  constructor() {
    super();
    this.state = {email: "", password: ""};
  }

  render() {
    const { email, password } = this.state;
    const format = (Platform.OS === "web") ? pageStyles : screenStyles;

    return (
      <ErrorBoundary>
        <View style={[styles.central, format.modal]}>
          <Button title="Sign Up"
                  style={{width: 75}}
                  onPress={() => this.createSession(signUpMutation)}/>
{/* Sign Up prints "signed in" w/ empty fields... */}
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

          <Button title="Sign In"
                  style={{width: 75}}
                  onPress={() => this.createSession(signInMutation)}/>
        </View>
      </ErrorBoundary>
    );
  }

  createSession(mutation) {
    const { email, password } = this.state;
    const variables = {email, password};

    commitMutation(environment, { mutation, variables,
                   onCompleted: () => console.log("signed in"),
                   onError: err => console.log(err) });
  }
}

const custom = StyleSheet.create({
  fields: { width: 125, marginHorizontal: 10, backgroundColor: "white", borderRadius: 5 }
});

const signUpMutation = graphql`
  mutation FormSignUpMutation($email: String!, $password: String!) {
    signUp(email: $email, password: $password) {
      ...FormSession
    }
  }
`;

const signInMutation = graphql`
  mutation FormSignInMutation($email: String!, $password: String!) {
    signIn(email: $email, password: $password) {
      ...FormSession
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
  }
`;

AppRegistry.registerComponent("UserForm", () => Form);
