import { createFetcher, createSubscriber } from "@absinthe/socket-relay/compat/cjs";
import { Environment, Network, RecordSource, Store } from "relay-runtime";
import absintheSocket from "./absinthe";

export default new Environment({ network: Network.create( createFetcher(absintheSocket),
                                                          createSubscriber(absintheSocket) ),
                                 store: new Store(new RecordSource()) });
