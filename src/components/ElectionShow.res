@react.component
let make = (~electionData: ElectionData.t) => {
  let (_state, dispatch) = StateContext.use()
  let { setup } = electionData
  let election = setup.election

  React.useEffect1(() => {
    let uuid = setup.election.uuid

    dispatch(StateMsg.Election_Fetch(uuid))
    let intervalId = Js.Global.setInterval(() => {
      dispatch(StateMsg.Election_Fetch(uuid))
    }, 5000)

    Some(() => Js.Global.clearInterval(intervalId))
  }, [])

  <>
    <Header title="Résultats de l'élection" />

    <S.Container>
      <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />

      <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~lineHeight=40.0, ~fontWeight=Style.FontWeight._900, ())>
        { `${election.name}`->React.string }
      </Title>

      <View style=Style.viewStyle(~margin=20.0->Style.dp, ())>
        <Text>
          { `${election.description}`->React.string }
        </Text>
      </View>

      <View style=Style.viewStyle(~margin=20.0->Style.dp, ())>
        {
          switch electionData.result {
          | None =>
            <Chip icon=Paper.Icon.name("information") mode=#outlined>
              { `Statut: En cours`->React.string }
            </Chip>
          | Some(_result) =>
            <Chip icon=Paper.Icon.name("information") mode=#outlined>
              { `Statut: Finished`->React.string }
            </Chip>
          }
        }
      </View>

      <Text style=Style.textStyle(~color=Color.black, ~fontWeight=Style.FontWeight.bold, ())>
      {
        let dateToString = switch election.startDate {
        | Some(startDate) => Js.Date.toLocaleString(startDate)
        | None => "Non définie"
        }
        `Date de début: ${dateToString}`->React.string
      }
      </Text>

      <Text style=Style.textStyle(~color=Color.black, ~fontWeight=Style.FontWeight.bold, ())>
      {
        let dateToString = switch election.endDate {
        | Some(startDate) => Js.Date.toLocaleString(startDate)
        | None => "Non définie"
        }
        `Date de fin: ${dateToString}`->React.string
      }
      </Text>

      <Text>
        {
          let nCredentials = Int.toString(Array.length(setup.credentials))
          `Nombre de votants invités par email: ${nCredentials}`->React.string
        }
      </Text>

      <Text>
        {

          let ballots = electionData.ballots
            ->Array.map(b => (b.credential, b))
            ->Js.Dict.fromArray
            ->Js.Dict.values
          let nBallots = Int.toString(Array.length(ballots))
          `Nombre de votes enregistrés: ${nBallots}`->React.string
        }
      </Text>

      { switch electionData.result {
      | None => <></>
      | Some(_result) =>
        <S.Button
          title="Voir les résultats"
          onPress={_ => {
            dispatch(Navigate(list{"elections", election.uuid, "result"}))
          }}
        />
      }}

      { switch electionData.result {
      | Some(_result) => <></>
      | None =>
        <>
          { switch election.access {
          | Some(#"open") =>
            <S.Button
              title="Partager un lien d'accès"
              onPress={_ => {
                dispatch(Navigate(list{"elections", election.uuid, "share"}))
              }}
            />
          | _ => <></>
          } }
          <S.Button
            title="Administation: Dépouillement"
            mode=#outlined
            titleStyle=Style.textStyle(~color=Color.black, ())
            onPress={_ => {
              dispatch(Navigate(list{"elections", election.uuid, "tally"}))
            }} />
        </>
      }}

      <View style={Style.viewStyle(~height=30.0->Style.dp, ())} />
    </S.Container>
  </>
}
