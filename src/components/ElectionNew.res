@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let (name, setName) = React.useState(_ => "")
  let (desc, setDesc) = React.useState(_ => "")
  let (choices, setChoices) = React.useState(_ => ["", ""])

  let electionCreate = _ => {
    let choices = Array.mapWithIndex(choices, (i, choice) => {
      switch choice {
      | "" => "Choice " ++ Int.toString(i+1)
      | _  => choice
      }
    })
    Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  }

  <>
    <Header title={t(. "election.new.header")} />
    <S.Section title={t(. "election.new.title")} />
    <S.TextInput
      testID="election-title" value=name onChangeText={text => setName(_ => text)}
    />
    <S.Section title={t(. "election.new.question")} />
    <S.TextInput
      testID="election-desc" value=desc onChangeText={text => setDesc(_ => text)}
    />
    <ElectionNewChoiceList choices setChoices />
    <S.Button onPress=electionCreate title={t(. "election.new.next")} />
  </>
}
