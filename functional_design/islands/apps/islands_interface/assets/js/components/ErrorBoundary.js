import React, { Component, Fragment } from "react"
import { AppRegistry, View, Text } from "react-native"

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

AppRegistry.registerComponent("ErrorBoundary", () => ErrorBoundary)
