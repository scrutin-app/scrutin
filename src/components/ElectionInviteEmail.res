@react.component
let make = (~election, ~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (email, setEmail) = React.useState(_ => "")
  let (_contact:option<Contact.t>, setContact) = React.useState(_ => None)
  let (showModal, setshowModal) = React.useState(_ => false);

  let election = State.getElectionExn(state, electionId)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  }) -> Option.getExn

  let onChangeText = text => {
    setEmail(_ => text)
    let contact = Array.getBy(state.contacts, (contact) => {
      Option.getWithDefault(contact.email, "") == text
    })
    setContact(_ => contact)
  }

  let onSubmit = _ => {
    let voterId = Account.make() // Only use if no contact found

    // NOTE: This is to disable the "Use existing contact feature"
    let contact:option<Contact.t> = None

    if Option.isNone(contact) {
      let contact : Contact.t = {
        hexPublicKey: voterId.hexPublicKey,
        email: Some(email),
        phoneNumber: None
      }

      dispatch(Contact_Add(contact))
    }

    let voterPublicKey = switch (contact) {
    | Some(contact) => contact.hexPublicKey
    | None => voterId.hexPublicKey
    }

    let ballot : Ballot.t = {
      electionId,
      previousId: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey
    }

    let tx = Event_.SignedBallot.create(ballot, orgId)
    dispatch(Event_Add_With_Broadcast(tx))

    if Option.isNone(contact) {
      let ballotId = tx.contentHash
      if X.env == #dev {
        // For cypress tests
        let () = %raw(`window.hexSecretKey = voterId.hexSecretKey`)
        let () = %raw(`window.ballotId = ballotId`)
        let () = %raw(`window.electionId = electionId`)
        // For manual tests
        Js.log(`http://localhost:19006/ballots/${ballotId}#${Option.getExn(voterId.hexSecretKey)}`)
      } else {
        Mailer.send(ballotId, orgId, voterId, email)
      }
    }

    setEmail(_ => "")
    setshowModal(_ => false)
  }

  <>
    <ElectionHeader election section=#inviteMail />

    <S.Title>
      { t(."election.show.addByEmail.modal.title")  -> React.string }
    </S.Title>

    <TextInput
      mode=#flat
      label=t(."election.show.addByEmail.modal.email")
      testID="voter-email"
      value=email
      onChangeText
      autoFocus=true
      onSubmitEditing=onSubmit
    />

    <S.Row>
      <S.Col>
        <Button onPress={_ => { setEmail(_ => ""); setshowModal(_ => false)} }>
          { t(."election.show.addByEmail.modal.back") -> React.string }
        </Button>
      </S.Col>
      <S.Col>
        <Button mode=#outlined onPress=onSubmit>
          { /*if Option.isSome(contact) {
            "Utiliser le contact existant" -> React.string
          } else */{
            { t(."election.show.addByEmail.modal.sendInvite") -> React.string }
          } }
        </Button>
      </S.Col>
    </S.Row>

    <S.Button onPress=onSubmit title="Invite" />
  </>
}