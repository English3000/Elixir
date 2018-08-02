import React from "react"
import { View, StyleSheet } from "react-native"
import { Svg } from "expo"
//
import Atoll from ""
import Dot from ""
import L from ""
import S from ""
import Square from ""

export default class Islands extends React.Component {
  render(){
    return [ <Atoll/>,
             <Dot/>,
             <L/>
             <S/>
             <Square/> ]
  }
}
