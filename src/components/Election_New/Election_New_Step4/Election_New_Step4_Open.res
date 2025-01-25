@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  // let { t } = ReactI18next.useTranslation()

  let next = _ => setState(_ => { ...state, step: Step5, })
  let previous = _ => setState(_ => { ...state, step: Step3, })

  <>
    <Header title="Nouvelle élection" subtitle="4/5" />

    <S.Container>
      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <Text>{ "Cette election est ouverte." -> React.string }</Text>

      <Text>{ "Vous pourrez partager un lien permettant de voter" -> React.string }</Text>
    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}
