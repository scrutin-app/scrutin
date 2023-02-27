// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Home from "./components/Home.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as State from "./state/State.bs.js";
import * as React from "react";
import * as Header from "./Header.bs.js";
import * as Layout from "./Layout.bs.js";
import * as UseTea from "rescript-use-tea/src/UseTea.bs.js";
import * as Navigation from "./Navigation.bs.js";

function App(Props) {
  var match = UseTea.useTea(State.reducer, State.initial);
  var dispatch = match[1];
  React.useEffect((function () {
          Curry._1(dispatch, /* Init */0);
        }), []);
  return React.createElement(Layout.make, {
              state: match[0],
              dispatch: dispatch,
              children: null
            }, React.createElement(Header.make, {}), React.createElement(Home.make, {}), React.createElement(Navigation.make, {}));
}

var make = App;

export {
  make ,
}
/* Home Not a pure module */
