@react.component
let make = () => {
  let (state, _dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  <Paper.List.Section title={t(. "trustees.title")}>
    {Array.map(state.trustees, trustee => {
      let privkey = BeleniosWrapper.Trustees.Privkey.to_str(trustee.privkey)
      let pubkey = BeleniosWrapper.Trustees.pubkey(trustee.trustees)
      <Paper.List.Item title=pubkey description=privkey key=pubkey />
    })->React.array}
    <Paper.Button mode=#outlined onPress={_ => Trustee.clear()}>
      {t(. "trustees.clear")->React.string}
    </Paper.Button>
  </Paper.List.Section>
}
