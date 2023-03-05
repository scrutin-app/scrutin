// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as State from "./state/State.bs.js";
import * as React from "react";
import * as Header from "./Header.bs.js";
import * as Layout from "./Layout.bs.js";
import * as UseTea from "rescript-use-tea/src/UseTea.bs.js";
import * as Navigation from "./Navigation.bs.js";
import * as Election_New from "./components/Election_New.bs.js";
import * as Election_Show from "./components/Election_Show.bs.js";
import * as Identity_Show from "./components/Identity_Show.bs.js";
import * as Home_Elections from "./components/Home_Elections.bs.js";
import * as Home_Identities from "./components/Home_Identities.bs.js";
import * as Home_Transactions from "./components/Home_Transactions.bs.js";

function App(Props) {
  var match = UseTea.useTea(State.reducer, State.initial);
  var dispatch = match[1];
  var state = match[0];
  React.useEffect((function () {
          Curry._1(dispatch, /* Init */0);
        }), []);
  var eventHash = state.route;
  var tmp;
  if (typeof eventHash === "number") {
    switch (eventHash) {
      case /* Home_Elections */0 :
          tmp = React.createElement(Home_Elections.make, {});
          break;
      case /* Home_Identities */1 :
          tmp = React.createElement(Home_Identities.make, {});
          break;
      case /* Home_Transactions */2 :
          tmp = React.createElement(Home_Transactions.make, {});
          break;
      case /* Election_New */3 :
          tmp = React.createElement(Election_New.make, {});
          break;
      
    }
  } else {
    tmp = eventHash.TAG === /* Election_Show */0 ? React.createElement(Election_Show.make, {
            eventHash: eventHash._0
          }) : React.createElement(Identity_Show.make, {
            publicKey: eventHash._0
          });
  }
  return React.createElement(Layout.make, {
              state: state,
              dispatch: dispatch,
              children: null
            }, React.createElement(Header.make, {}), tmp, React.createElement(Navigation.make, {}));
}

var make = App;

export {
  make ,
}
/* State Not a pure module */
