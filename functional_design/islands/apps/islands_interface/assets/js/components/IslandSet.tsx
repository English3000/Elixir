import React from "react"
import { AppRegistry, View } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import { Undux } from "../Game"
import Island, { unit } from "./Island"

type Props = { style ?: {} }
export default function IslandSet({style} : Props){
  const {GameStore, GameplayStore} = Undux.useStores(),
        {count, islands}         = GameplayStore.getState()
  let topLeft = 0
  return (
    <ErrorBoundary key="unset-islands">
      <View style={style ? style : {}}>
        {Object.keys(islands).map(type => {
          console.log("Rendering...")
          const island = islands[type]
          let height = unit(island.bounds.height) + 10 // marginBottom

          topLeft += height

          return <Island key={type}
                         count={count}
                         GameStore={GameStore}
                         GameplayStore={GameplayStore}
                         island={island}
                         topLeft={topLeft - height}/> })}
      </View>
    </ErrorBoundary>
  )
}

AppRegistry.registerComponent("IslandSet", () => IslandSet)