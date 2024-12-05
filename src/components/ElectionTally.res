@react.component
let make = (~election: Sirona.Election.t, ~electionId) => {
  let (state, dispatch) = StateContext.use()
  let (passphrase, setPassphrase) = React.useState(_ => "")

  let tally = _ => {
    // TODO: Fetch all ballots.
    // (1 point)

    // TODO: Compute encrypted tally
    // (2 points: Extract multiply ballot logic in sirona)

    // TODO: Compute partial decryptions (skip proofs ?)
    // (5 points)

    // TODO: Compute result by bruteforcing decrypted values
    // (5 points)
    ()
  }

  <>
    <ElectionHeader election />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <Title>
      { "Entrer votre clé de gardien" -> React.string }
    </Title>

    <S.TextInput
      value=passphrase
      onChangeText={text => setPassphrase(_ => text)}
    />

    <S.Button
      title="Dépouiller"
      onPress=tally
    />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <S.Button
      title="Retour"
      onPress={_ =>
        dispatch(Navigate(list{"elections", electionId}))
      }
    />
  </>
}
