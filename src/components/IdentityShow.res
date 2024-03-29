@react.component
let make = (~publicKey) => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let identity = Array.getBy(state.accounts, id => {
    id.userId == publicKey
  })
  let secretKey = switch identity {
  | Some(identity) => identity.secret
  | None => ""
  }

  let _ballots =
    state.ballots
    ->Array.keep((ballot) => ballot.voterId == publicKey)

  let elections = []
  //  state.elections
  //  ->Map.String.keep((_eventHash, election) => election.ownerPublicKey == publicKey)
  //  ->Map.String.toArray

  <>
    <List.Section title={t(. "identity.show.title")}>
      <List.Item title={t(. "identity.show.publicKey")} description=publicKey />
      <List.Item title={t(. "identity.show.secretKey")} description=secretKey />
      <List.Accordion title={t(. "identity.show.elections")}>
        {Array.map(elections, ((eventHash, _election)) => {
          <List.Item
            title=eventHash
            key=eventHash
            onPress={_ => dispatch(Navigate(list{"elections", eventHash}))}
          />
        })->React.array}
      </List.Accordion>
      //<List.Accordion title={t(. "identity.show.ballots")}>
      //  {Array.map(ballots, ((eventHash, _ballot)) => {
      //    <List.Item
      //      title=eventHash
      //      key=eventHash
      //      onPress={_ => dispatch(Navigate(list{"ballots", eventHash}))}
      //    />
      //  })->React.array}
      //</List.Accordion>
    </List.Section>
  </>
}
