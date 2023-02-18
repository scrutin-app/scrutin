// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../../X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Context from "../../state/Context.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactNativePaper from "react-native-paper";

function ElectionList$ElectionLink(Props) {
  var election = Props.election;
  var match = Context.use(undefined);
  var dispatch = match[1];
  var uuid = Belt_Option.getExn(election.uuid);
  return React.createElement(ReactNativePaper.List.Item, {
              onPress: (function (param) {
                  Curry._1(dispatch, {
                        TAG: /* Navigate */12,
                        _0: {
                          TAG: /* ElectionShow */0,
                          _0: uuid
                        }
                      });
                }),
              title: election.name,
              left: (function (param) {
                  return React.createElement(ReactNativePaper.List.Icon, {
                              icon: "vote"
                            });
                }),
              right: (function (param) {
                  return React.createElement(ReactNativePaper.Text, {
                              children: uuid
                            });
                })
            });
}

var ElectionLink = {
  make: ElectionList$ElectionLink
};

function ElectionList(Props) {
  var title = Props.title;
  var elections = Props.elections;
  var loadingOpt = Props.loading;
  var loading = loadingOpt !== undefined ? loadingOpt : false;
  if (loading) {
    return React.createElement(ReactNativePaper.ActivityIndicator, {});
  } else {
    return React.createElement(ReactNativePaper.List.Section, {
                title: title,
                children: Belt_Array.map(elections, (function (election) {
                        return React.createElement(ElectionList$ElectionLink, {
                                    election: election,
                                    key: Belt_Option.getWithDefault(election.uuid, "")
                                  });
                      })),
                style: X.styles["margin-x"]
              });
  }
}

var make = ElectionList;

export {
  ElectionLink ,
  make ,
}
/* X Not a pure module */
