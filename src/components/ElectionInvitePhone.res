@react.component
let make = (~election: Election.t, ~electionId) => {
  //let { t } = ReactI18next.useTranslation()
  let (state, dispatch) = StateContext.use()
  let (phoneNumbers, setPhoneNumbers) = React.useState(_ => ["", ""])
  let admin = state->State.getElectionAdminExn(election)
  let (sendInvite, setSendInvite) = React.useState(_ => true)

  let onSubmit = _ => {
    phoneNumbers
    ->Array.keep(phoneNumber => phoneNumber != "")
    ->Array.forEach(phoneNumber => {

      let data = {
        let dict = Js.Dict.empty()
        Js.Dict.set(dict, "phoneNumber", Js.Json.string(phoneNumber))
        Js.Dict.set(dict, "electionId", Js.Json.string(electionId))
        Js.Dict.set(dict, "sendInvite", Js.Json.boolean(sendInvite))
        Js.Json.object_(dict)
      }

      X.post(`${URL.server_auth_email}/users`, data)
      ->Promise.then(Webapi.Fetch.Response.json)
      ->Promise.then(json => {
        switch Js.Json.classify(json) {
        | Js.Json.JSONObject(value) =>
          let optionalManagerId = value
          ->Js.Dict.get("managerId")
          ->Option.flatMap(Js.Json.decodeString)
          Promise.resolve(optionalManagerId)
        | _ => failwith("Expected an object")
        }
      })
      ->Promise.thenResolve((optionalManagerId) => {
        switch (optionalManagerId) {
        | Some(managerId) =>
          let invitation: Invitation.t = {
            userId: managerId,
            email: None,
            phoneNumber: Some(phoneNumber)
          }
          dispatch(Invitation_Add(invitation))
          let ev = Event_.ElectionVoter.create({
            electionId,
            voterId: managerId,
          }, admin)
          dispatch(Event_Add_With_Broadcast(ev))
          dispatch(Navigate(list{"elections", electionId}))
        | None => Js.log("No managerId found...")
        }
      })->ignore
    })

  }

  let onRemove = i => {
    setPhoneNumbers(Array.keepWithIndex(_, (_, index) => index != i))
  }

  let onUpdate = (i, newPhoneNumber) => {
    setPhoneNumbers(phoneNumbers =>
      Array.mapWithIndex(phoneNumbers, (index, oldPhoneNumber) => {
        index == i ? newPhoneNumber : oldPhoneNumber
      })
    )
  }

  <>
    <ElectionHeader election section=#invitePhone />
    {Array.mapWithIndex(phoneNumbers, (i, email) => {
      <ElectionInviteEmailItem
        email
        index={i + 1}
        key={Int.toString(i)}
        onRemove={_ => onRemove(i)}
        onUpdate={email => onUpdate(i, email)}
      />
    })->React.array}
    <S.Button
      style={Style.viewStyle(~width=100.0->Style.dp, ())}
      title="+"
      onPress={_ => setPhoneNumbers(phoneNumbers => Array.concat(phoneNumbers, [""]))}
    />
    <List.Item
      title="Envoyer une invitation"
      description="Tous les participants recevront un SMS"
      onPress={_ => setSendInvite(b => !b)}
      right={_ => <Switch value=sendInvite />}
    />
    <S.Button onPress=onSubmit title="Inviter" />
  </>
}
