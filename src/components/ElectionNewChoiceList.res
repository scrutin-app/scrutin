@react.component
let make = (~choices, ~setChoices) => {
  let {t} = ReactI18next.useTranslation()

  let onRemove = i => {
    setChoices(choices => Array.keepWithIndex(choices, (_name, index) => index != i))
  }

  let onUpdate = (i, newName) => {
    setChoices(choices =>
      Array.mapWithIndex(choices, (index, oldName) => {
        index == i ? newName : oldName
      })
    )
  }

  <View testID="choice-list">
    <S.Section title={t(. "election.new.choiceList.choices")} />
    {Array.mapWithIndex(choices, (i, name) => {
      <ElectionNewChoiceItem
        name
        index={i + 1}
        key={Int.toString(i)}
        onRemove={_ => onRemove(i)}
        onUpdate={name => onUpdate(i, name)}
      />
    })->React.array}
    <TouchableOpacity
      style=Style.viewStyle(~alignSelf=#center,())
      onPress={_ => setChoices(choices => Array.concat(choices, [""]))}>
      <SIcon.ButtonPlus />
    </TouchableOpacity>
  </View>
}
