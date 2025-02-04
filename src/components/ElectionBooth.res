module Choice = {
  @react.component
  let make = (~name, ~selected, ~onSelect) => {
    let iconName = selected ? "radiobox-marked" : "radiobox-blank"

    <List.Item
      title=name
      style={Style.viewStyle(~padding=20.0->Style.dp, ~paddingLeft=40.0->Style.dp, ())}
      left={_ => <List.Icon icon={Icon.name(iconName)} />}
      onPress={_ => onSelect()}
    />
  }
}

module BoothAfterVote = {
  @react.component
  let make = (~electionId) => {
    let (_state, dispatch) = StateContext.use()
    <>
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
        {"Merci pour votre vote"->React.string}
      </Text>
      <S.Button
        title="Retour à l'élection"
        onPress={_ => { dispatch(Navigate(list{"elections", electionId})) }}
      />
    </>
  }
}

module Booth = {
  @react.component
  let make = (~election, ~electionId, ~account) => {
    let (state, dispatch) = StateContext.use()
    let {t} = ReactI18next.useTranslation()
    let (choice, setChoice) = React.useState(_ => None)
    let question = switch Election.description(election) {
    | "" => t(. "election.new.question")
    | question => question
    }
    <>
      <View style=S.questionBox>
        <S.Section title=question />
        {Array.mapWithIndex(Election.choices(election), (i, choiceName) => {
          let selected = choice == Some(i)

          <Choice
            name=choiceName selected key={Int.toString(i)} onSelect={_ => setChoice(_ => Some(i))}
          />
        })->React.array}
      </View>
      <S.Button
        title="Voter"
        onPress={_ => {
          let nbChoices = Array.length(Election.choices(election))
          Core.Ballot.vote(~electionId, ~voter=account, ~choice, ~nbChoices)(state, dispatch)
        }}
      />
    </>
  }
}

let getSecret = () => {
  if ReactNative.Platform.os == #web {
    let url = RescriptReactRouter.dangerouslyGetInitialUrl()
    if String.length(url.hash) > 12 {
      Some(url.hash)
    } else {
      None
    }
  } else {
    None
  }
}

@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, _dispatch) = StateContext.use()

  let oSecret = getSecret()

  <>
    <ElectionHeader election />
    { switch oSecret {
    | None =>
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
        {"Vous n'avez pas de clés de vote"->React.string}
      </Text>
    | Some(secret) =>
      let account = Account.make2(~secret)
      // NOTE: Should we save the account for later ?
      //dispatch(StateMsg.Account_Add(account))
      // TODO: Check before if account doesn't yet exist ?

      let oBallot = Array.getBy(state.ballots, (ballot) => {
        ballot.electionId == electionId && ballot.voterId == account.userId
      })

      { switch oBallot {
      | None => <Booth election electionId account />
      | Some(_ballot) => <BoothAfterVote electionId />
      } }
    }}
  </>
}
