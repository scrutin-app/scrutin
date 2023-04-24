// The state of the application.

type t = {
  // See [[Event]].
  // We use this to populate elections and ballots
  events: array<Event_.t>,
  // If we are syncing events
  fetchingEvents: bool,
  // The controlled identities (as voter or election organizer)
  // See [[Identity]]
  ids: array<Account.t>,
  // The controlled election private key (for tallying)
  // See [[Trustee]]
  trustees: array<Trustee.t>,
  // Contacts, to keep track on who is associated with which public key
  invitations: array<Invitation.t>,
  // The current route (still waiting for a decent rescript router
  // that works on web and native)
  route: list<string>,
  // elections and ballot (from parsed events)
  elections: Map.String.t<Election.t>,
  // opposite of election.previousId (TODO: remove)
  electionNextIds: Map.String.t<string>,
  ballots: Map.String.t<Ballot.t>,
  // opposite of ballot.previousId (TODO: rename nextIds)
  ballotNextIds: Map.String.t<string>,
}

// The initial state of the application
let initial = {
  route: list{""},
  events: [],
  fetchingEvents: true,
  ids: [],
  trustees: [],
  invitations: [],
  elections: Map.String.empty,
  electionNextIds: Map.String.empty,
  ballots: Map.String.empty,
  ballotNextIds: Map.String.empty,
}

let getBallot = (state, id) => Map.String.get(state.ballots, id)
let getBallotExn = (state, id) => Map.String.getExn(state.ballots, id)

let getElection = (state, id) => Map.String.get(state.elections, id)
let getElectionExn = (state, id) => Map.String.getExn(state.elections, id)

let getAccount = (state, publicKey) => Array.getBy(state.ids, id => publicKey == id.hexPublicKey)
let getAccountExn = (state, publicKey) => getAccount(state, publicKey)->Option.getExn

let rec getBallotOriginalId = (state, ballotId) => {
  let ballot = state->getBallotExn(ballotId)
  switch ballot.previousId {
  | Some(previousId) => state->getBallotOriginalId(previousId)
  | None => ballotId
  }
}

let getElectionValidBallots = (state, electionId) => {
  Map.String.toArray(state.ballots)
  ->Array.keep(((_id, ballot)) => ballot.electionId == electionId)
  ->Array.keep(((id, _ballot)) => {
    Map.String.get(state.ballotNextIds, id)->Option.isNone
  })
  ->Array.keep(((_id, ballot)) => {
    Option.isSome(ballot.ciphertext)
  })
  ->Js.Array2.map(((id, ballot)) => {
    (state->getBallotOriginalId(id), ballot)
  })
  ->Js.Dict.fromArray
  ->Js.Dict.values
}

let getBallotNext = (state: t, ballotId) => {
  switch Map.String.get(state.ballotNextIds, ballotId) {
  | Some(nextBallotId) => state->getBallot(nextBallotId)
  | None => None
  }
}
