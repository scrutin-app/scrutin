// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../Config.bs.js";
import * as Context from "../state/Context.bs.js";
import * as EmailValidator from "email-validator";
import * as ReactNativePaper from "react-native-paper";

function User_Register(Props) {
  var match = React.useState(function () {
        return "";
      });
  var setEmail = match[1];
  var email = match[0];
  var match$1 = React.useState(function () {
        return false;
      });
  var setLoading = match$1[1];
  var match$2 = Context.use(undefined);
  var dispatch = match$2[1];
  var match$3 = React.useState(function () {
        return "";
      });
  var setError = match$3[1];
  var error = match$3[0];
  var onSubmit = function (param) {
    if (!EmailValidator.validate(email)) {
      return Curry._1(setError, (function (param) {
                    return "Invalid email";
                  }));
    }
    Curry._1(setLoading, (function (param) {
            return true;
          }));
    var dict = {};
    dict["email"] = email;
    X.post("" + Config.base_url + "/users", dict).then(function (param) {
          Curry._1(dispatch, {
                TAG: /* Navigate */12,
                _0: {
                  TAG: /* User_Register_Confirm */3,
                  _0: undefined
                }
              });
        });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.Title, {
                  style: X.styles.center,
                  children: "Ready to vote ?"
                }), error === "" ? React.createElement(React.Fragment, undefined) : React.createElement(ReactNativePaper.HelperText, {
                    type: "error",
                    children: error
                  }), React.createElement(ReactNativePaper.TextInput, {
                  mode: "flat",
                  label: "Email",
                  value: email,
                  onChangeText: (function (text) {
                      Curry._1(setEmail, (function (param) {
                              return text;
                            }));
                    }),
                  onSubmitEditing: onSubmit,
                  testID: "email-input"
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "contained",
                  onPress: onSubmit,
                  children: match$1[0] ? "Loading..." : "Next"
                }));
}

var make = User_Register;

export {
  make ,
}
/* X Not a pure module */
