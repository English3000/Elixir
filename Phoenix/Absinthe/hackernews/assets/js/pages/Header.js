import React from "react";
import { AppRegistry, View, Text, StyleSheet } from "react-native";
import Nav from "./Nav";
import Form from "../components/user/Form";
import ErrorBoundary from "../components/ErrorBoundary";
import { createFragmentContainer, graphql } from "react-relay";
import { styles } from "../app";

class Header extends React.Component {
  constructor() {
    super();
    this.state = {visible: false};
  }

  render() {
    return this.props.data.me ? <Nav /> : (
      <ErrorBoundary>
        <View style={styles.header}>
          <Text style={{color: "white", textTransform: "uppercase"}}
                onPress={() => this.setState({visible: true})}>Authenticate</Text>
        </View>
        {this.state.visible ? (
          <View style={[styles.absolute, styles.central]}>
            <Form />
            <Text style={custom.x}
                  onPress={() => this.setState({visible: false})}>&times;</Text>
          </View>
        ) : null}
      </ErrorBoundary>
    );
  }
}

const custom = StyleSheet.create({
  x: { position: "absolute",
       zIndex: 1,
       marginTop: "-17.5%",
       marginLeft: "45%",
       fontWeight: "700" },
});

AppRegistry.registerComponent("PageHeader", () => Header);

export default createFragmentContainer(Header, graphql`
  fragment HeaderSession on RootQueryType {
    me {
      id
      name
      email
    }
  }
`);
