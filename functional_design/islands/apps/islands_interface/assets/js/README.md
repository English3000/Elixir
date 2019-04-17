> After converting to `.tsx` && confirming `Undux` architecture works && merged into `master`,
>   add frontend tests, improve backend test coverage
>     * test that "what I see is what I get" (as a baseline) -- also setup build integration that auto-runs tests
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