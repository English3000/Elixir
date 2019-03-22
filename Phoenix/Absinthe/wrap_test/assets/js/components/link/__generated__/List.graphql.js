/**
 * @flow
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteFragment } from 'relay-runtime';
type Link$ref = any;
import type { FragmentReference } from "relay-runtime";
declare export opaque type List$ref: FragmentReference;
export type List = {|
  +allLinks: $ReadOnlyArray<{|
    +$fragmentRefs: Link$ref
  |}>,
  +$refType: List$ref,
|};
*/


const node/*: ConcreteFragment*/ = {
  "kind": "Fragment",
  "name": "List",
  "type": "RootQueryType",
  "metadata": null,
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
          "kind": "FragmentSpread",
          "name": "Link",
          "args": null
        }
      ]
    }
  ]
};
// prettier-ignore
(node/*: any*/).hash = '395b6712ca15e80c1aa06a950b6fae43';
module.exports = node;
