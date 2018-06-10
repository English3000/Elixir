/**
 * @flow
 * @relayHash a2c78ed88ba5c2c550a333f838b12a3f
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
export type LinkInput = {
  description?: ?string,
  url?: ?string,
};
export type FormMutationVariables = {|
  input: LinkInput
|};
export type FormMutationResponse = {|
  +createLink: ?{|
    +link: ?{|
      +id: string,
      +description: ?string,
      +url: string,
    |},
    +errors: ?$ReadOnlyArray<?{|
      +key: string,
      +message: string,
    |}>,
  |}
|};
*/


/*
mutation FormMutation(
  $input: LinkInput!
) {
  createLink(input: $input) {
    link {
      id
      description
      url
    }
    errors {
      key
      message
    }
  }
}
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "LinkInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "createLink",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input",
        "type": "LinkInput!"
      }
    ],
    "concreteType": "LinkResult",
    "plural": false,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "link",
        "storageKey": null,
        "args": null,
        "concreteType": "Link",
        "plural": false,
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
      },
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "errors",
        "storageKey": null,
        "args": null,
        "concreteType": "InputError",
        "plural": true,
        "selections": [
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "key",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "message",
            "args": null,
            "storageKey": null
          }
        ]
      }
    ]
  }
];
return {
  "kind": "Request",
  "operationKind": "mutation",
  "name": "FormMutation",
  "id": null,
  "text": "mutation FormMutation(\n  $input: LinkInput!\n) {\n  createLink(input: $input) {\n    link {\n      id\n      description\n      url\n    }\n    errors {\n      key\n      message\n    }\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "FormMutation",
    "type": "RootMutationType",
    "metadata": null,
    "argumentDefinitions": v0,
    "selections": v1
  },
  "operation": {
    "kind": "Operation",
    "name": "FormMutation",
    "argumentDefinitions": v0,
    "selections": v1
  }
};
})();
// prettier-ignore
(node/*: any*/).hash = '897afa21e4947eae035715ac3871e930';
module.exports = node;
