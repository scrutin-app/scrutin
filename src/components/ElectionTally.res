@react.component
let make = (~electionData: ElectionData.t) => {
  let { setup, ballots } = electionData
  let { credentials, election } = setup
  let (_state, dispatch) = StateContext.use()
  let (passphrase, setPassphrase) = React.useState(_ => "")

  let verifyPrivkey = (privkey, electionTrustee: Trustee.PublicKey.t) => {
    let (_privkey, trustee) = Trustee.generateFromPriv(privkey)
    let (_a, b) = Trustee.parse(trustee)
    Point.serialize(electionTrustee.public_key) == Point.serialize(b.public_key)
  }

  React.useEffect0(() => {
    let fetchPassword = async _ => {
      let res = await ReactNativeAsyncStorage.getItem(election.uuid)
      switch (Js.Null.toOption(res)) {
      | None => ()
      | Some(pass) => setPassphrase(_ => pass)
      }
    }
    fetchPassword()->ignore
    None
  })

  let tally = async _ => {
    let privkey = Mnemonic.toPrivkey(passphrase)
    let (_type, trustee) = Array.getExn(electionData.setup.trustees, 0)
    if (!verifyPrivkey(privkey, trustee)) {
      Window.alert("Bad password")
    }

    let credentials = if setup.election.access == Some(#"open") {
      // Add any credential to setup. Make sure they are uniques
      Array.map(ballots, (b) => b.credential)
        ->Array.map(c => (c, c))
        ->Js.Dict.fromArray
        ->Js.Dict.values
    } else {
      // Keep original credentials
      setup.credentials
    }

    let setup = {...setup, credentials }

    let et = EncryptedTally.generate(setup, ballots)
    let pd = PartialDecryption.generate(setup, et, 1, privkey);
    let pds = [pd]
    let result = Result_.generate(setup, et, pds)

    let obj : Js.Json.t = Obj.magic({
      "encryptedTally": EncryptedTally.serialize(et, election),
      "partialDecryptions": pds,
      "result": result
    })

    let _response = await HTTP.put(`${Config.server_url}/${election.uuid}/result`, obj)

    dispatch(Navigate(list{"elections", election.uuid}))
  }

  <>
    <Header title="Dépouillement de l'élection" />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <S.P style=Style.viewStyle(~margin=20.0->Style.dp, ())>
    { 
      let nBallot = Int.toString(Array.length(ballots))
      `${nBallot} bulletin(s) dans l'urne.` -> React.string
    }
    </S.P>

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    { 
      Array.map(ballots, (ballot) => {
        let color = if Array.some(credentials, (c) => c == ballot.credential) {
          Color.green
        } else {
          Color.orange
        }
        <>
          // NOTE: Arf name are not stored, cause not on ballots...
          //{ if ballot.name != "" {
          //  <Text style=Style.textStyle(~color=Color.black, ~fontWeight=Style.FontWeight.bold, ())>
          //    { `Name: ${ballot.name}`->React.string }
          //  </Text>
          //}
          <Text style=Style.textStyle(~color, ~fontWeight=Style.FontWeight.bold, ())>
            { `Credential: ${ballot.credential}`->React.string }
          </Text>

          <Text style=Style.textStyle(~color=Color.black, ~fontWeight=Style.FontWeight.bold, ())>
            { `Condensat: ${ballot.signature.hash}`->React.string }
          </Text>
          <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />
        </>
      }) -> React.array
    }

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <Title>
      { "Entrez votre clé de gardien" -> React.string }
    </Title>

    <S.TextInput
      value=passphrase
      onChangeText={text => setPassphrase(_ => text)}
    />

    <S.Button
      title="Dépouiller"
      disabled=(passphrase == "")
      onPress= (_ => {
        tally()->ignore
      })
    />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <S.Button
      title="Retour"
      onPress={_ =>
        dispatch(Navigate(list{"elections", election.uuid}))
      }
    />
  </>
}
