/**
 * @flow
 * @relayHash 3397bfcd2157679e3915a28b4cc7825a
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
type FormSession$ref = any;
export type FormSignInMutationVariables = {|
  email: string,
  password: string,
|};
export type FormSignInMutationResponse = {|
  +signIn: ?{|
    +$fragmentRefs: FormSession$ref
  |}
|};
*/


/*
mutation FormSignInMutation(
  $email: String!
  $password: String!
) {
  signIn(email: $email, password: $password) {
    ...FormSession
  }
}

fragment FormSession on SessionResult {
  session {
    user {
      id
      name
      email
    }
  }
}
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "email",
    "type": "String!",
    "defaultValue": null
  },
  {
    "kind": "LocalArgument",
    "name": "password",
    "type": "String!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "email",
    "variableName": "email",
    "type": "String!"
  },
  {
    "kind": "Variable",
    "name": "password",
    "variableName": "password",
    "type": "String!"
  }
];
return {
  "kind": "Request",
  "operationKind": "mutation",
  "name": "FormSignInMutation",
  "id": null,
  "text": "mutation FormSignInMutation(\n  $email: String!\n  $password: String!\n) {\n  signIn(email: $email, password: $password) {\n    ...FormSession\n  }\n}\n\nfragment FormSession on SessionResult {\n  session {\n    user {\n      id\n      name\n      email\n    }\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "FormSignInMutation",
    "type": "RootMutationType",
    "metadata": null,
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "signIn",
        "storageKey": null,
        "args": v1,
        "concreteType": "SessionResult",
        "plural": false,
        "selections": [
          {
            "kind": "FragmentSpread",
            "name": "FormSession",
            "args": null
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "FormSignInMutation",
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "signIn",
        "storageKey": null,
        "args": v1,
        "concreteType": "SessionResult",
        "plural": false,
        "selections": [
          {
            "kind": "LinkedField",
            "alias": null,
            "name": "session",
            "storageKey": null,
            "args": null,
            "concreteType": "Session",
            "plural": false,
            "selections": [
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "user",
                "storageKey": null,
                "args": null,
                "concreteType": "User",
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
        ]
      }
    ]
  }
};
})();
// prettier-ignore
(node/*: any*/).hash = '59fc9a3caa00257a8e8434d4cbbfa0d3';
module.exports = node;
