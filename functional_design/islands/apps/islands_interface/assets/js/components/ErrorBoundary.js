import React, { Component, Fragment } from "react"
import { AppRegistry, View, Text } from "react-native"

// NOTE: JS class component b/c `componentDidCatch/1` not yet supported by React Hooks
export default class ErrorBoundary extends Component {
  constructor() {
    super()
    this.state = {error: null}
  }

  componentDidCatch(error) { this.setState({error}) }

  render() {
    const {error} = this.state
    return error ? <View><Text>{error.toString()}</Text></View> :
                     <Fragment>{this.props.children}</Fragment>
  }
}

AppRegistry.registerComponent("ErrorBoundary.js", () => ErrorBoundary)