// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as State from "../state/State.bs.js";
import * as React from "react";
import * as Belenios from "../Belenios.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactNative from "react-native";
import * as ReactNativePaper from "react-native-paper";
import * as AsyncStorage from "@react-native-async-storage/async-storage";

function ElectionShow(Props) {
  var match = State.useContexts(undefined);
  var dispatch = match[1];
  var state = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setPrivkey = match$1[1];
  var privkey = match$1[0];
  var match$2 = React.useState(function () {
        return false;
      });
  var setShowSnackbar = match$2[1];
  var nb_ballots = String(state.election.ballots.length);
  var nb_votes = String(Belt_Array.keep(state.election.ballots, (function (ballot) {
              return ballot.ciphertext !== "";
            })).length);
  React.useEffect((function () {
          if (state.election.trustees !== "") {
            var pubkey = Belenios.Trustees.pubkey(state.election.trustees);
            AsyncStorage.default.getItem(pubkey).then(function (res) {
                  Curry._1(setPrivkey, (function (param) {
                          if (res === null) {
                            return ;
                          } else {
                            return Caml_option.some(res);
                          }
                        }));
                });
          }
          
        }), [state.election.trustees]);
  var tally = function (param) {
    if (privkey !== undefined) {
      var params = state.election.params;
      var ballots = Belt_Array.map(state.election.ballots, (function (ballot) {
              return ballot.ciphertext;
            }));
      var trustees = state.election.trustees;
      console.log(state.election.creds);
      var pubcreds = (JSON.parse(state.election.creds));
      var match = Belenios.Election.decrypt(params, ballots, trustees, pubcreds, privkey);
      var res = Belenios.Election.result(params, ballots, trustees, pubcreds, match[0], match[1]);
      Curry._1(dispatch, {
            TAG: /* Election_PublishResult */0,
            _0: res
          });
    } else {
      Curry._1(setShowSnackbar, (function (param) {
              return true;
            }));
    }
    console.log(privkey);
  };
  return React.createElement(ReactNative.View, {
              children: null
            }, React.createElement(ReactNativePaper.Title, {
                  style: X.styles.title,
                  children: state.election.name
                }), React.createElement(ReactNativePaper.Title, {
                  style: X.styles.subtitle,
                  children: "" + nb_votes + "/" + nb_ballots + " voted"
                }), React.createElement(ReactNative.View, {
                  style: X.styles.separator
                }), React.createElement(X.Row.make, {
                  children: null
                }, React.createElement(X.Col.make, {
                      children: React.createElement(ReactNativePaper.Button, {
                            onPress: (function (param) {
                                Curry._1(dispatch, {
                                      TAG: /* Navigate */13,
                                      _0: {
                                        TAG: /* ElectionBooth */1,
                                        _0: state.election.id
                                      }
                                    });
                              }),
                            children: "Vote"
                          })
                    }), React.createElement(X.Col.make, {
                      children: React.createElement(ReactNativePaper.Button, {
                            onPress: tally,
                            children: "Tally"
                          })
                    }), React.createElement(X.Col.make, {
                      children: React.createElement(ReactNativePaper.Button, {
                            onPress: (function (param) {
                                Curry._1(dispatch, {
                                      TAG: /* Navigate */13,
                                      _0: {
                                        TAG: /* ElectionResult */2,
                                        _0: state.election.id
                                      }
                                    });
                              }),
                            children: "Results"
                          })
                    })), React.createElement(ReactNativePaper.Portal, {
                  children: React.createElement(ReactNativePaper.Snackbar, {
                        onDismiss: (function (param) {
                            Curry._1(setShowSnackbar, (function (param) {
                                    return false;
                                  }));
                          }),
                        visible: match$2[0],
                        children: "You don't have the election private key"
                      })
                }));
}

var make = ElectionShow;

export {
  make ,
}
/* X Not a pure module */
