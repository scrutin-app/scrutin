let main = () =>  {
  let state = State.initial
  let trustee  = Trustee.make()
  let identity = Identity.make()
  
  let name = "My Election"
  let desc = ""
  let choices = []
  let election = Election.make(name, desc, choices,
    identity.hexPublicKey, trustee)
}

let main2 = () => {
  Belenios.Credentials.create("ashdjfakdslfa", 10)
}
