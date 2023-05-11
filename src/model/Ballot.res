type t = {
  electionId: string,
  voterId: string,
  ciphertext: string,
  pubcred: string
}

external parse: string => t = "JSON.parse"
external stringify: t => string = "JSON.stringify"

let make = (~election: Election.t, ~electionId, ~voterId, ~selection: array<int>) => {
  let trustees = BeleniosWrapper.Trustees.of_str(election.trustees)
  let params = BeleniosWrapper.Election.parse(election.params)
  let (pubcreds, privcreds) = BeleniosWrapper.Credentials.create(params.uuid, 1)
  let (pubcred, privcred) = (Array.getExn(pubcreds, 0), Array.getExn(privcreds, 0))

  let ciphertext =
    BeleniosWrapper.Election.vote(
      params,
      ~cred=privcred,
      ~selections=[selection],
      ~trustees,
    )->BeleniosWrapper.Ballot.to_str

  {
    electionId,
    voterId,
    ciphertext,
    pubcred
  }
}
