/**
 * @flow
 * @relayHash 3af294548582bbc1f0bd49ae3b474857
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
type FormSession$ref = any;
export type FormSignUpMutationVariables = {|
  email: string,
  password: string,
|};
export type FormSignUpMutationResponse = {|
  +signUp: ?{|
    +$fragmentRefs: FormSession$ref
  |}
|};
*/


/*
mutation FormSignUpMutation(
  $email: String!
  $password: String!
) {
  signUp(email: $email, password: $password) {
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
  "name": "FormSignUpMutation",
  "id": null,
  "text": "mutation FormSignUpMutation(\n  $email: String!\n  $password: String!\n) {\n  signUp(email: $email, password: $password) {\n    ...FormSession\n  }\n}\n\nfragment FormSession on SessionResult {\n  session {\n    user {\n      id\n      name\n      email\n    }\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "FormSignUpMutation",
    "type": "RootMutationType",
    "metadata": null,
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "signUp",
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
    "name": "FormSignUpMutation",
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "signUp",
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
(node/*: any*/).hash = '6798bb6c4239818629da2edca12fd7be';
module.exports = node;
