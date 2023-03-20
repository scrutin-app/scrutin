// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../helpers/X.bs.js";
import * as Core from "../Core.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../helpers/Config.bs.js";
import * as Mailer from "../helpers/Mailer.bs.js";
import * as Context from "../helpers/Context.bs.js";
import * as Election from "../model/Election.bs.js";
import * as Identity from "../model/Identity.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Transaction from "../model/Transaction.bs.js";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as ReactNativePaper from "react-native-paper";

function Election_Show(Props) {
  var contentHash = Props.contentHash;
  var match = Context.use(undefined);
  var dispatch = match[1];
  var state = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setEmail = match$1[1];
  var email = match$1[0];
  var election = Belt_MapString.getExn(state.cached_elections, contentHash);
  var publicKey = election.ownerPublicKey;
  var ballots = Belt_Array.keep(Belt_Array.keep(state.txs, (function (tx) {
              return tx.type_ === "ballot";
            })), (function (tx) {
          var ballot = Transaction.SignedBallot.unwrap(tx);
          return ballot.electionTx === contentHash;
        }));
  var nbBallots = ballots.length;
  var addBallot = function (param) {
    var voterId = Identity.make(undefined);
    var contact_hexPublicKey = voterId.hexPublicKey;
    var contact_email = email;
    var contact = {
      hexPublicKey: contact_hexPublicKey,
      email: contact_email,
      phoneNumber: undefined
    };
    Curry._1(dispatch, {
          TAG: /* Contact_Add */4,
          _0: contact
        });
    var ballot_electionPublicKey = election.ownerPublicKey;
    var ballot_voterPublicKey = voterId.hexPublicKey;
    var ballot = {
      electionTx: contentHash,
      previousTx: undefined,
      electionPublicKey: ballot_electionPublicKey,
      voterPublicKey: ballot_voterPublicKey,
      ciphertext: undefined,
      pubcred: undefined
    };
    var orgId = Belt_Option.getExn(Belt_Array.getBy(state.ids, (function (id) {
                return id.hexPublicKey === election.ownerPublicKey;
              })));
    var tx = Transaction.SignedBallot.make(ballot, orgId);
    Curry._1(dispatch, {
          TAG: /* Transaction_Add */2,
          _0: tx
        });
    if (Config.env === "dev") {
      var ballotId = tx.contentHash;
      return Mailer.send(ballotId, orgId, voterId, email);
    }
    console.log(voterId.hexSecretKey);
  };
  var onPress = function (param) {
    Curry._1(dispatch, {
          TAG: /* Navigate */0,
          _0: {
            TAG: /* Identity_Show */1,
            _0: publicKey
          }
        });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.List.Section, {
                  title: "Election",
                  children: null
                }, React.createElement(ReactNativePaper.List.Item, {
                      title: "Name",
                      description: Election.name(election)
                    }), React.createElement(ReactNativePaper.List.Item, {
                      title: "Description",
                      description: Election.description(election)
                    }), React.createElement(ReactNativePaper.List.Item, {
                      title: "Event Hash",
                      description: contentHash
                    }), React.createElement(ReactNativePaper.List.Item, {
                      onPress: onPress,
                      title: "Owner Public Key",
                      description: publicKey
                    }), React.createElement(ReactNativePaper.List.Item, {
                      title: "Params",
                      description: election.params
                    }), React.createElement(ReactNativePaper.List.Item, {
                      title: "Trustees",
                      description: election.trustees
                    })), React.createElement(ReactNativePaper.Divider, {}), React.createElement(ReactNativePaper.Title, {
                  style: X.styles.title,
                  children: "Invite someone"
                }), React.createElement(ReactNativePaper.TextInput, {
                  mode: "flat",
                  label: "Email",
                  value: email,
                  onChangeText: (function (text) {
                      Curry._1(setEmail, (function (param) {
                              return text;
                            }));
                    })
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "outlined",
                  onPress: addBallot,
                  children: "Add as voter"
                }), React.createElement(ReactNativePaper.Divider, {}), React.createElement(ReactNativePaper.List.Section, {
                  title: "" + String(nbBallots) + " ballots",
                  children: Belt_Array.map(ballots, (function (tx) {
                          Transaction.SignedBallot.unwrap(tx);
                          return React.createElement(ReactNativePaper.List.Item, {
                                      onPress: (function (param) {
                                          Curry._1(dispatch, {
                                                TAG: /* Navigate */0,
                                                _0: {
                                                  TAG: /* Ballot_Show */2,
                                                  _0: tx.contentHash
                                                }
                                              });
                                        }),
                                      title: "Ballot " + tx.contentHash + "",
                                      key: tx.contentHash
                                    });
                        }))
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "outlined",
                  onPress: (function (param) {
                      Core.Election.tally(contentHash, state, dispatch);
                    }),
                  children: "Tally"
                }));
}

var make = Election_Show;

export {
  make ,
}
/* X Not a pure module */
