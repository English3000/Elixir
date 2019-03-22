> After converting to `.tsx` && confirming `Undux` architecture works && merged into `master`,
> try 2nd branch using **Flow** (&& see which I prefer... Flow seems to have better type _inference_ than TS)
>   add `JSDoc`s _a la_:

## Store

```ts
              payload ?: {}
              message ?: string
              id      ?: string
GameState = { form     : Form = false | { complete : boolean } }
                                          game     : string
                                          player   : string

GameplayState = { count    : number }
                  islands ?: {}

(BoardRenderer) // SFC
(IslandSet)     // SFC

IslandState = { onBoard       : number }
                pan           : {}
                panResponder ?: {}
```

## Functions

* `locate/2`