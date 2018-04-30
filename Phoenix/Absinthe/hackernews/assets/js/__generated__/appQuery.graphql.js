/**
 * @flow
 * @relayHash 0703f58d3d5bf720e5430d8efcf6f723
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
type List$ref = any;
export type appQueryVariables = {||};
export type appQueryResponse = {|
  +$fragmentRefs: List$ref
|};
*/


/*
query appQuery {
  ...List
}

fragment List on RootQueryType {
  allLinks {
    ...Link
    id
  }
}

fragment Link on Link {
  id
  description
  url
}
*/

const node/*: ConcreteRequest*/ = {
  "kind": "Request",
  "operationKind": "query",
  "name": "appQuery",
  "id": null,
  "text": "query appQuery {\n  ...List\n}\n\nfragment List on RootQueryType {\n  allLinks {\n    ...Link\n    id\n  }\n}\n\nfragment Link on Link {\n  id\n  description\n  url\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "appQuery",
    "type": "RootQueryType",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "FragmentSpread",
        "name": "List",
        "args": null
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "appQuery",
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "allLinks",
        "storageKey": null,
        "args": null,
        "concreteType": "Link",
        "plural": true,
        "selections": [
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "description",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "url",
            "args": null,
            "storageKey": null
          }
        ]
      }
    ]
  }
};
// prettier-ignore
(node/*: any*/).hash = 'd3a8c02cbef6b596d20a4d4abb4b3356';
module.exports = node;
