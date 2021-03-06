import { createFetcher, createSubscriber } from "@absinthe/socket-relay/compat/cjs"; //w/o `/compat/cjs`, compilation error
import { Environment, Network, RecordSource, Store } from "relay-runtime";
import absintheSocket from "./absinthe";
// Remove in production--makes page load slowly
// import { installRelayDevTools } from "relay-devtools";
// installRelayDevTools();
//--------------------
export default new Environment({ network: Network.create( createFetcher(absintheSocket),
                                                          createSubscriber(absintheSocket) ),
                                 store: new Store(new RecordSource()) });
