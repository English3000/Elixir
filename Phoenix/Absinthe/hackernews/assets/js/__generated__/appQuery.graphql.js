/**
 * @flow
 * @relayHash 7ad641de773a3d4e455207926e8d330b
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
type HeaderSession$ref = any;
type List$ref = any;
export type appQueryVariables = {||};
export type appQueryResponse = {|
  +$fragmentRefs: List$ref & HeaderSession$ref
|};
*/


/*
query appQuery {
  ...List
  ...HeaderSession
}

fragment List on RootQueryType {
  allLinks {
    ...Link
    id
  }
}

fragment HeaderSession on RootQueryType {
  me {
    id
    name
    email
  }
}

fragment Link on Link {
  description
  url
}
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "operationKind": "query",
  "name": "appQuery",
  "id": null,
  "text": "query appQuery {\n  ...List\n  ...HeaderSession\n}\n\nfragment List on RootQueryType {\n  allLinks {\n    ...Link\n    id\n  }\n}\n\nfragment HeaderSession on RootQueryType {\n  me {\n    id\n    name\n    email\n  }\n}\n\nfragment Link on Link {\n  description\n  url\n}\n",
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
      },
      {
        "kind": "FragmentSpread",
        "name": "HeaderSession",
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
          },
          v0
        ]
      },
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "me",
        "storageKey": null,
        "args": null,
        "concreteType": "User",
        "plural": false,
        "selections": [
          v0,
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "name",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "email",
            "args": null,
            "storageKey": null
          }
        ]
      }
    ]
  }
};
})();
// prettier-ignore
(node/*: any*/).hash = '620776a9a4fdcf80349eac4fd61cd100';
module.exports = node;
