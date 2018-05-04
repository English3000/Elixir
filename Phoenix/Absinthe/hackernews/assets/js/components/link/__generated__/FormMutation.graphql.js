/**
 * @flow
 * @relayHash 79b7e6540ff7da037fde0de0923c52eb
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
export type LinkInput = {
  description?: ?string,
  url: string,
  userId: string,
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
    |}
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
      }
    ]
  }
];
return {
  "kind": "Request",
  "operationKind": "mutation",
  "name": "FormMutation",
  "id": null,
  "text": "mutation FormMutation(\n  $input: LinkInput!\n) {\n  createLink(input: $input) {\n    link {\n      id\n      description\n      url\n    }\n  }\n}\n",
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
(node/*: any*/).hash = '373fb9e8a98264f020851417f145da17';
module.exports = node;
