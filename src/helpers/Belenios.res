module Credentials = {
  @module("./belenios_jslib2") @scope("belenios") @val external create: (string, int) => (array<string>, array<string>) = "makeCredentials"

  @module("./belenios_jslib2") @scope("belenios") @val external derive: (~uuid: string, ~privateCredential: string) => (string) = "derive"

  type t = array<string>
  external parse: (string) => t = "JSON.parse"
  external stringify: (t) => string = "JSON.stringify"
}

module Trustees = {

  module Privkey = {
    type t

    external of_str: string => t = "%identity"
    external to_str: t => string = "%identity"
  }

  type t

  @module("./belenios_jslib2") @scope("belenios") @val external create: () => (Privkey.t, t) = "genTrustee"

  let pubkey : (t) => string = %raw(`
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
  type t

  external of_str: string => t = "%identity"
  external to_str: t => string = "%identity"
}

module PartialDecryption = {
  type t1
  type t2
}

module Election = {
  type question_t = {
    question: string,
    max: int,
    min: int,
    blank: bool,
    answers: array<string>
  }

  type t = {
    version: string,
    uuid: string,
    name: string,
    description: string,
    group: string,
    public_key: string,
    questions: array<question_t>
  }

  external parse: (string) => t = "JSON.parse"
  external stringify: (t) => string = "JSON.stringify"

  @module("./belenios_jslib2") @scope("belenios") @val external _create: (~name: string, ~description: string, ~choices: array<string>, ~trustees: Trustees.t) => string = "makeElection"
  @module("./belenios_jslib2") @scope("belenios") @val external _vote: (string, ~cred: string, ~selections: array<array<int>>, ~trustees: Trustees.t) => Ballot.t = "encryptBallot"
  @module("./belenios_jslib2") @scope("belenios") @val external _decrypt: (string, array<Ballot.t>, Trustees.t, array<string>, Trustees.Privkey.t) => (PartialDecryption.t1, PartialDecryption.t2) = "decrypt"
  @module("./belenios_jslib2") @scope("belenios") @val external _result: (string, array<Ballot.t>, Trustees.t, array<string>, PartialDecryption.t1, PartialDecryption.t2) => (string) = "result"

  let create = (~name, ~description, ~choices, ~trustees) => parse(_create(~name, ~description, ~choices, ~trustees))
  let vote    = (o) => _vote(stringify(o))
  let decrypt = (o) => _decrypt(stringify(o))
  let result  = (o) => _result(stringify(o))

  let answers = (params) =>
    Array.getExn(params.questions, 0).answers
}