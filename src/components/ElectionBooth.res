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

module BoothClassic = {
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

module BoothMajorityJudgement = {
  @react.component
  let make = (~election, ~electionId, ~account) => {
    let candidates = Election.questions(election)
    let nCandidates = Array.length(candidates)
    let (state, dispatch) = StateContext.use()
    let {t} = ReactI18next.useTranslation()
    let (choices, setChoices) = React.useState(_ => Array.make(nCandidates, None))
    let question = switch Election.description(election) {
    | "" => t(. "election.new.question")
    | question => question
    }


    let submitStyle = if Array.every(choices, Option.isSome) {
      Style.viewStyle(())
    } else {
      Style.viewStyle(~backgroundColor=Color.gray, ())
    }

    <>
      <S.Section title=question />
      {Array.mapWithIndex(candidates, (i, candidateName) => {
        <View style=S.questionBox>
          <S.Section title=candidateName />
          {Array.mapWithIndex([ "Excellent", "Very good", "Good",
            "Passable", "Inadequate", "Mediocre" ], (r, choiceName) => {
            let selected = Array.getExn(choices, i) == Some(r)

            <Choice
              name=choiceName selected key={Int.toString(i)}
              onSelect={_ => setChoices(_ => choices->Array.mapWithIndex(
                (idx, e) => if idx == i { Some(r) } else { e }))}
            />
          })->React.array}
        </View>
      })->React.array}

      <S.Button
        title="Voter"
        style=submitStyle
        onPress={_ => {
          if Array.every(choices, Option.isSome) {
            let choices = choices->Array.map((o) => o->Option.getWithDefault(0))
            Core.Ballot.voteMJ(~electionId, ~voter=account, ~choices)(state, dispatch)
          } else {
            Js.log("You need to make a choice for every candidate")
          }
        }}
      />
    </>
  }
}

@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, _dispatch) = StateContext.use()

  let oAccount = Array.getBy(state.accounts, (account) => {
    Array.getBy(election.voterIds, userId => userId == account.userId)
    ->Option.isSome
  })

  let oBallot = switch oAccount {
  | None => None
  | Some(account) => Array.getBy(state.ballots, (ballot) => {
      ballot.electionId == electionId && ballot.voterId == account.userId
    })
  }

  <>
    <ElectionHeader election />

    { switch oAccount {
    | None =>
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
        {"Vous n'avez pas de clés de vote"->React.string}
      </Text>
    | Some(account) =>
      switch oBallot {
      | None => <BoothMajorityJudgement election electionId account />
      | Some(_ballot) => <BoothAfterVote electionId />
      }
    } }
  </>
}
