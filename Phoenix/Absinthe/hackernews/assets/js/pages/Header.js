import React from "react";
import { AppRegistry, View, Text, StyleSheet } from "react-native";
import Form from "../components/user/Form";
import ErrorBoundary from "../components/ErrorBoundary";
import { styles } from "../app";
import { webStyles } from "./index";

export default class Header extends React.Component {
  constructor() {
    super();
    this.state = {visible: false};
  }

  render() {
    return (
      <ErrorBoundary>
        <View style={custom.header}>
          <Text style={{color: "white", textTransform: "uppercase"}}
                onPress={() => this.setState({visible: true})}>Authenticate</Text>
        </View>
        {this.state.visible ? (
          <View style={[styles.absolute, styles.central]}>
            <Form style={webStyles.modal}/>
            <Text style={custom.x} onPress={() => this.setState({visible: false})}>&times;</Text>
          </View>
        ) : null}
      </ErrorBoundary>
    );
  }
}

const custom = StyleSheet.create({
  header: { alignItems: "center", backgroundColor: "#e00082", paddingVertical: 12.5 },
  x: {position: "absolute", zIndex: 3, marginTop: "-20%", marginLeft: "45%", fontWeight: "700"},
});

AppRegistry.registerComponent("WebHeader", () => Header);
