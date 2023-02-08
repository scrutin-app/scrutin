// Generated by ReScript, PLEASE EDIT WITH CARE

import * as $$URL from "../helpers/URL.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Store from "./Store.bs.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belenios from "../Belenios.bs.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Election from "./Election.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function loadElections(dispatch) {
  Election.getAll(undefined).then(function (res) {
        var json_array = Js_json.decodeArray(res);
        if (json_array !== undefined) {
          return Curry._1(dispatch, {
                      TAG: /* Election_LoadAll */9,
                      _0: json_array
                    });
        } else {
          return Curry._1(dispatch, {
                      TAG: /* Election_LoadAll */9,
                      _0: []
                    });
        }
      });
}

function loadElection(id, dispatch) {
  Election.get(id).then(function (o) {
        return Curry._1(dispatch, {
                    TAG: /* Election_Load */8,
                    _0: o
                  });
      });
}

function createElection(election, user, dispatch) {
  var match = Belenios.Trustees.create(undefined);
  var trustees = match[1];
  Store.Trustee.add({
        pubkey: Belenios.Trustees.pubkey(trustees),
        privkey: match[0]
      });
  var params = Belenios.Election.create(election.name, "description", Belt_Array.map(election.choices, (function (o) {
              return o.name;
            })), trustees);
  var match$1 = Belenios.Credentials.create(params.uuid, election.voters.length);
  var pubcreds = match$1[0];
  var creds = Belt_Array.zip(pubcreds, match$1[1]);
  var voters = Belt_Array.map(Belt_Array.zip(election.voters, creds), (function (param) {
          var match = param[1];
          var voterWithoutCred = param[0];
          return {
                  id: voterWithoutCred.id,
                  email: voterWithoutCred.email,
                  privCred: match[1],
                  pubCred: match[0]
                };
        }));
  var election_id = election.id;
  var election_name = election.name;
  var election_choices = election.choices;
  var election_ballots = election.ballots;
  var election_uuid = params.uuid;
  var election_params = params;
  var election_trustees = trustees;
  var election_creds = JSON.stringify(pubcreds);
  var election_result = election.result;
  var election_administrator_id = election.administrator_id;
  var election$1 = {
    id: election_id,
    name: election_name,
    voters: voters,
    choices: election_choices,
    ballots: election_ballots,
    uuid: election_uuid,
    params: election_params,
    trustees: election_trustees,
    creds: election_creds,
    result: election_result,
    administrator_id: election_administrator_id
  };
  Election.post(election$1, user).then(function (prim) {
          return prim.json();
        }).then(function (res) {
        Curry._1(dispatch, {
              TAG: /* Election_Load */8,
              _0: res
            });
        var id = Election.from_json(res).id;
        Curry._1(dispatch, {
              TAG: /* Navigate */11,
              _0: {
                TAG: /* ElectionBooth */1,
                _0: id
              }
            });
      });
}

function ballotCreate(election, token, selection, dispatch) {
  var ballot = Election.createBallot(election, token, selection);
  Election.post_ballot(election, ballot).then(function (res) {
        console.log(res);
      });
}

function publishElectionResult(election, result, dispatch) {
  Election.post_result(election, result).then(function (param) {
        Curry._1(dispatch, {
              TAG: /* Election_SetResult */1,
              _0: result
            });
      });
}

function goToUrl(dispatch) {
  $$URL.getAndThen(function (url) {
        if (!url) {
          return ;
        }
        switch (url.hd) {
          case "elections" :
              var match = url.tl;
              if (!match) {
                return ;
              }
              if (match.tl) {
                return ;
              }
              var nId = Belt_Option.getWithDefault(Belt_Int.fromString(match.hd), 0);
              return Curry._1(dispatch, {
                          TAG: /* Navigate */11,
                          _0: {
                            TAG: /* ElectionBooth */1,
                            _0: nId
                          }
                        });
          case "profile" :
              if (url.tl) {
                return ;
              } else {
                return Curry._1(dispatch, {
                            TAG: /* Navigate */11,
                            _0: /* Profile */2
                          });
              }
          default:
            return ;
        }
      });
}

function get(dispatch) {
  Store.User.get(undefined).then(function (oUser) {
        if (oUser !== undefined) {
          return Curry._1(dispatch, {
                      TAG: /* User_Login */12,
                      _0: oUser
                    });
        }
        
      });
}

function set(user, _dispatch) {
  Store.User.set(user);
}

function clean(_dispatch) {
  Store.User.clean(undefined);
}

var User = {
  get: get,
  set: set,
  clean: clean
};

function get$1(dispatch) {
  Store.Trustee.get(undefined).then(function (trustees) {
        return Curry._1(dispatch, {
                    TAG: /* Trustees_Set */13,
                    _0: trustees
                  });
      });
}

function add(param, _dispatch) {
  Store.Trustee.add({
        pubkey: param.pubkey,
        privkey: param.privkey
      });
}

var Trustees = {
  get: get$1,
  add: add
};

var Store$1 = {
  User: User,
  Trustees: Trustees
};

export {
  loadElections ,
  loadElection ,
  createElection ,
  ballotCreate ,
  publishElectionResult ,
  goToUrl ,
  Store$1 as Store,
}
/* URL Not a pure module */
