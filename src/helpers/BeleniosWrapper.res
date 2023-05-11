module Credentials = {
  let create = Belenios3.makeCredentials
  // TODO: rename privateCredential to publicCredential, like in Belenios jblib
  let derive  = (~uuid: string, ~privateCredential: string) =>
    Belenios3.derive(uuid, privateCredential)

  type t = array<string>
  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"
}

module Trustees = {
  module Privkey = {
    type t = string

    external of_str: string => t = "%identity"
    external to_str: t => string = "%identity"
  }

  type t = string

  let create: unit => (Privkey.t, t) = Belenios3.genTrustee

  let pubkey: t => string = %raw(`
    function(e) {
      var pubkey = JSON.parse(e)[0][1]["public_key"];
      console.log(pubkey);
      return pubkey;
    }
  `)

  external of_str: string => t = "%identity"
  external to_str: t => string = "%identity"
}

module Ballot = {
  type t = string

  external of_str: string => t = "%identity"
  external to_str: t => string = "%identity"

  module Parsed = {
    type t = {credential: string}
    external parse: string => t = "JSON.parse"
    external stringify: t => string = "JSON.stringify"
  }

  let setCredential: (t, string) => t = %raw(`function(t, credential) {
    var o = JSON.parse(t)
    o.credential = credential
    return JSON.stringify(o)
  }`)
}

module PartialDecryption = {
  type t1 = string
  type t2 = string

  external to_s1: t1 => string = "%identity"
  external to_s2: t2 => string = "%identity"
}

module Election = {
  type question_t = {
    question: string,
    max: int,
    min: int,
    blank: bool,
    answers: array<string>,
  }

  type t = {
    version: string,
    uuid: string,
    name: string,
    description: string,
    group: string,
    public_key: string,
    questions: array<question_t>,
  }

  type results_t = {result: array<array<int>>}

  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"

  let _create = (
    ~name: string,
    ~description: string,
    ~choices: array<string>,
    ~trustees: Trustees.t,
  ) =>
    Belenios3.makeElection(name, description, choices, trustees)

  let _vote = (
    election: string,
    ~cred: string,
    ~selections: array<array<int>>,
    ~trustees: Trustees.t,
  ) =>
    Belenios3.encryptBallot(election, cred, selections, trustees)

  let _decrypt = (
    election:string,
    ballots:array<Ballot.t>,
    trustees: Trustees.t,
    credentials: array<string>,
    privkey: Trustees.Privkey.t
  ) =>
    Belenios3.decrypt(election, ballots, trustees, credentials, privkey)

  let _result = (
    election:string,
    ballots:array<Ballot.t>,
    trustees: Trustees.t,
    credentials: array<string>,
    a: PartialDecryption.t1,
    b: PartialDecryption.t2,
  ) => Belenios3.result(election, ballots, trustees, credentials, a, b)

  let create = (~name, ~description, ~choices, ~trustees) =>
    parse(_create(~name, ~description, ~choices, ~trustees))
  let vote = o => _vote(stringify(o))
  let decrypt = o => _decrypt(stringify(o))

  external parseResults: string => results_t = "JSON.parse"
  let result = o => _result(stringify(o))

  let scores: string => array<int> = s => Option.getExn(parseResults(s).result[0])

  let answers = params => Array.getExn(params.questions, 0).answers
}
