// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Js_exn from "rescript/lib/es6/js_exn.js";
import * as Identity from "./Identity.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Transaction from "./Transaction.bs.js";

function identities_fetch(dispatch) {
  Identity.fetch_all(undefined).then(function (ids) {
        return Belt_Array.map(ids, (function (id) {
                      return Curry._1(dispatch, {
                                  TAG: /* Identity_Add */1,
                                  _0: id
                                });
                    }));
      });
}

function identities_store(ids, _dispatch) {
  Identity.store_all(ids);
}

function identities_clear(_dispatch) {
  Identity.clear(undefined);
}

function transactions_fetch(dispatch) {
  Transaction.fetch_all(undefined).then(function (txs) {
        return Belt_Array.map(txs, (function (tx) {
                      return Curry._1(dispatch, {
                                  TAG: /* Transaction_Add */2,
                                  _0: tx
                                });
                    }));
      });
}

function transactions_store(txs, _dispatch) {
  Transaction.store_all(txs);
}

function transactions_clear(_dispatch) {
  Transaction.clear(undefined);
}

function cache_update(tx, dispatch) {
  var match = tx.eventType;
  switch (match) {
    case "ballot" :
        return Curry._1(dispatch, {
                    TAG: /* Cache_Ballot_Add */4,
                    _0: tx.eventHash,
                    _1: Transaction.SignedBallot.unwrap(tx)
                  });
    case "election" :
        return Curry._1(dispatch, {
                    TAG: /* Cache_Election_Add */3,
                    _0: tx.eventHash,
                    _1: Transaction.SignedElection.unwrap(tx)
                  });
    default:
      return Js_exn.raiseError("Unknown transaction type");
  }
}

export {
  identities_fetch ,
  identities_store ,
  identities_clear ,
  transactions_fetch ,
  transactions_store ,
  transactions_clear ,
  cache_update ,
}
/* Identity Not a pure module */