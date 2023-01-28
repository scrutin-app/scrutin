module Credentials = {
  @module("./belenios_jslib2") @scope("belenios") @val external create: (string, int) => (array<string>, array<string>) = "makeCredentials"
}

module Trustees = {
  type t
  module Privkey = { type t }
  @module("./belenios_jslib2") @scope("belenios") @val external create: () => (Privkey.t, t) = "genTrustee"
}

module Ballot = {
  type t
}

module PartialDecryption = {
  type t1
  type t2
}

module Election = {
  type t

  @module("./belenios_jslib2") @scope("belenios") @val external create: (string, string, array<string>, Trustees.t) => t = "makeElection"
  @module("./belenios_jslib2") @scope("belenios") @val external vote: (t, string, array<array<int>>, Trustees.t) => Ballot.t = "encryptBallot"

  @module("./belenios_jslib2") @scope("belenios") @val external decrypt: (t, array<Ballot.t>, Trustees.t, array<string>, Trustees.Privkey.t) => (PartialDecryption.t1, PartialDecryption.t2) = "decrypt"
  @module("./belenios_jslib2") @scope("belenios") @val external result: (t, array<Ballot.t>, Trustees.t, array<string>, PartialDecryption.t1, PartialDecryption.t2) => (string) = "result"

  let uuid : (t) => string = %raw(`
    function(e) {
      return JSON.parse(e)["uuid"];
    }
  `)
}