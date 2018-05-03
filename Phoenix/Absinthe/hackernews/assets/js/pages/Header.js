import React from "react";
import { AppRegistry, View, Text, TextInput, Button, Dimensions, StyleSheet } from "react-native";
import ErrorBoundary from "../components/ErrorBoundary";
import { styles } from "../app";
import { webStyles } from "./index";

export default class Header extends React.Component {
  constructor() {
    super();
    this.state = {auth: false, email: "", password: ""};
  }

  render() {
    const { auth, email, password } = this.state

    return (
      <ErrorBoundary>
        <View style={custom.header}>
          <Text style={{color: "white", textTransform: "uppercase"}} onPress={() => this.setState({auth: true})}>Authenticate</Text>
        </View>
        {auth ? (
          <View style={[styles.absolute, styles.central]}>
            <View style={[webStyles.modal, styles.central]}>
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
            <Text style={custom.x} onPress={() => this.setState({auth: false})}>&times;</Text>
          </View>
        ) : null}
      </ErrorBoundary>
    );
  }
}

const custom = StyleSheet.create({
  header: { alignItems: "center", backgroundColor: "#e00082", paddingVertical: 12.5 },
  x: {position: "absolute", zIndex: 3, marginTop: "-20%", marginLeft: "45%", fontWeight: "700"}
});

AppRegistry.registerComponent("WebHeader", () => Header);
