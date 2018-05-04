import React from "react";
import { AppRegistry, View, Text, TextInput, Button } from "react-native";
import ErrorBoundary from "../ErrorBoundary";
import { styles } from "../../app";

export default class Form extends React.Component {
  constructor() {
    super();
    this.state = {email: "", password: ""};
  }

  render() {
    const { email, password } = this.state;

    return (
      <ErrorBoundary>
        <View style={[styles.central, this.props.style]}>
          <TextInput onChangeText={email => this.setState({email})}
                     placeholder="email"
                     value={email}/>
          <TextInput onChangeText={password => this.setState({password})}
                     placeholder="password"
                     value={password}/>
          <View style={{width: "20%"}}>
            <Button title="ENTER"/>
          </View>
        </View>
      </ErrorBoundary>
    );
  }
}

AppRegistry.registerComponent("UserForm", () => Form);
