// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Json_Decode$JsonCombinators from "rescript-json-combinators/src/Json_Decode.bs.js";
import * as Json_Encode$JsonCombinators from "rescript-json-combinators/src/Json_Encode.bs.js";

var from_json = Json_Decode$JsonCombinators.object(function (field) {
      return {
              electionUuid: field.required("election_uuid", Json_Decode$JsonCombinators.option(Json_Decode$JsonCombinators.string)),
              ciphertext: field.required("ciphertext", Json_Decode$JsonCombinators.option(Json_Decode$JsonCombinators.string)),
              privateCredential: Belt_Option.getWithDefault(field.optional("private_credential", Json_Decode$JsonCombinators.string), ""),
              publicCredential: field.required("public_credential", Json_Decode$JsonCombinators.string)
            };
    });

function to_json(r) {
  return {
          election_uuid: Json_Encode$JsonCombinators.option((function (prim) {
                  return prim;
                }), r.electionUuid),
          ciphertext: Json_Encode$JsonCombinators.option((function (prim) {
                  return prim;
                }), r.ciphertext),
          public_credential: r.publicCredential,
          private_credential: r.privateCredential
        };
}

var initial = {
  electionUuid: undefined,
  ciphertext: undefined,
  privateCredential: "",
  publicCredential: ""
};

export {
  initial ,
  from_json ,
  to_json ,
}
/* from_json Not a pure module */
