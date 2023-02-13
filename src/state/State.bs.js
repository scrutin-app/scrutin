// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Effect from "./Effect.bs.js";
import * as Belenios from "../Belenios.bs.js";
import * as Election from "./Election.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

var initial_elections = [];

var initial_trustees = [];

var initial_tokens = [];

var initial = {
  election: Election.initial,
  elections: initial_elections,
  elections_loading: false,
  user: undefined,
  loading: false,
  voting_in_progress: false,
  route: /* Home */0,
  trustees: initial_trustees,
  tokens: initial_tokens
};

function reducer(state, action) {
  if (typeof action === "number") {
    switch (action) {
      case /* Init */0 :
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: true,
                    user: state.user,
                    loading: state.loading,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  [
                    Effect.goToUrl,
                    Effect.loadElections,
                    Effect.Store.User.get,
                    Effect.Store.Trustees.get,
                    Effect.Store.Tokens.get,
                    (function (param) {
                        Belenios.Random.generate(undefined);
                      })
                  ]
                ];
      case /* Election_Post */1 :
          var partial_arg = Belt_Option.getExn(state.user);
          var partial_arg$1 = state.election;
          return [
                  state,
                  [(function (param) {
                        return Effect.createElection(partial_arg$1, partial_arg, param);
                      })]
                ];
      case /* Ballot_Create_End */2 :
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: state.user,
                    loading: state.loading,
                    voting_in_progress: false,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  []
                ];
      case /* User_Logout */3 :
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: undefined,
                    loading: state.loading,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  [Effect.Store.User.clean]
                ];
      
    }
  } else {
    switch (action.TAG | 0) {
      case /* Election_PublishResult */0 :
          var result = action._0;
          var partial_arg$2 = state.election;
          return [
                  state,
                  [(function (param) {
                        return Effect.publishElectionResult(partial_arg$2, result, param);
                      })]
                ];
      case /* Election_Fetch */7 :
          var id = action._0;
          return [
                  {
                    election: {
                      id: id,
                      name: Election.initial.name,
                      voters: Election.initial.voters,
                      choices: Election.initial.choices,
                      ballots: Election.initial.ballots,
                      uuid: Election.initial.uuid,
                      params: Election.initial.params,
                      trustees: Election.initial.trustees,
                      creds: Election.initial.creds,
                      result: Election.initial.result,
                      administrator_id: Election.initial.administrator_id
                    },
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: state.user,
                    loading: true,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  [(function (param) {
                        return Effect.loadElection(id, param);
                      })]
                ];
      case /* Election_Load */8 :
          return [
                  {
                    election: Election.from_json(action._0),
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: state.user,
                    loading: false,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  []
                ];
      case /* Election_LoadAll */9 :
          return [
                  {
                    election: state.election,
                    elections: Belt_Array.reverse(Belt_Array.map(action._0, Election.from_json)),
                    elections_loading: false,
                    user: state.user,
                    loading: state.loading,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  []
                ];
      case /* Ballot_Create_Start */10 :
          var selection = action._1;
          var token = action._0;
          var partial_arg$3 = state.election;
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: state.user,
                    loading: state.loading,
                    voting_in_progress: true,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  [(function (param) {
                        return Effect.ballotCreate(partial_arg$3, token, selection, param);
                      })]
                ];
      case /* Navigate */11 :
          var route = action._0;
          if (typeof route === "number") {
            switch (route) {
              case /* Home */0 :
                  X.setUrlPathname("/");
                  break;
              case /* ElectionNew */1 :
                  break;
              case /* Profile */2 :
                  X.setUrlPathname("/profile");
                  break;
              
            }
          } else {
            X.setUrlPathname("/elections/" + String(route._0) + "");
          }
          var effects;
          if (typeof route === "number") {
            effects = [];
          } else {
            var id$1 = route._0;
            effects = [(function (param) {
                  return Effect.loadElection(id$1, param);
                })];
          }
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: state.user,
                    loading: state.loading,
                    voting_in_progress: state.voting_in_progress,
                    route: route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  effects
                ];
      case /* User_Login */12 :
          var user = action._0;
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: user,
                    loading: state.loading,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: state.tokens
                  },
                  [Curry._1(Effect.Store.User.set, user)]
                ];
      case /* Trustees_Set */13 :
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: state.user,
                    loading: state.loading,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: action._0,
                    tokens: state.tokens
                  },
                  []
                ];
      case /* Tokens_Set */14 :
          return [
                  {
                    election: state.election,
                    elections: state.elections,
                    elections_loading: state.elections_loading,
                    user: state.user,
                    loading: state.loading,
                    voting_in_progress: state.voting_in_progress,
                    route: state.route,
                    trustees: state.trustees,
                    tokens: action._0
                  },
                  []
                ];
      default:
        return [
                {
                  election: Election.reducer(state.election, action),
                  elections: state.elections,
                  elections_loading: state.elections_loading,
                  user: state.user,
                  loading: state.loading,
                  voting_in_progress: state.voting_in_progress,
                  route: state.route,
                  trustees: state.trustees,
                  tokens: state.tokens
                },
                []
              ];
    }
  }
}

export {
  initial ,
  reducer ,
}
/* X Not a pure module */
