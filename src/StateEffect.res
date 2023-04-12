// ## Cache management

let cache_update = (ev : Event_.t) =>
  (dispatch) => {
    switch ev.type_ {
    | #"election.create" =>
      dispatch(StateMsg.Cache_Election_Add(ev.contentHash,
      Event_.SignedElection.unwrap(ev)))
    | #"election.update" =>
      dispatch(StateMsg.Cache_Election_Add(ev.contentHash,
      Event_.SignedElection.unwrap(ev)))
    | #"ballot.create" =>
      dispatch(StateMsg.Cache_Ballot_Add(ev.contentHash,
      Event_.SignedBallot.unwrap(ev)))
    | #"ballot.update" =>
      dispatch(StateMsg.Cache_Ballot_Add(ev.contentHash,
      Event_.SignedBallot.unwrap(ev)))
    }
  }

// ## LocalStorage - Store

let identities_store = (ids) => (_dispatch) => Account.store_all(ids)
let events_store = (evs) => (_dispatch) => Event_.store_all(evs)
let trustees_store = (trustees) => (_dispatch) => Trustee.store_all(trustees)
let contacts_store = (contacts) => (_dispatch) => Contact.store_all(contacts)
let language_store = (language) =>
  (_dispatch) =>
    ReactNativeAsyncStorage.setItem("config.language", language) -> ignore

// ## LocalStorage - Fetch

let identities_fetch = (dispatch) => {
  Account.fetch_all()
  -> Promise.thenResolve((ids) => {
    Array.map(ids, (id) => dispatch(StateMsg.Identity_Add(id)))
    // FIX: Identity_Add call identites_store as an effect...
  }) -> ignore
}

let events_fetch = (dispatch) => {
  Event_.fetch_all()
  -> Promise.thenResolve((evs) => {
    Array.map(evs, (ev) => dispatch(StateMsg.Event_Add(ev)))
  }) -> ignore
}

let trustees_fetch = (dispatch) => {
  Trustee.fetch_all()
  -> Promise.thenResolve((os) => {
    Array.map(os, (o) => dispatch(StateMsg.Trustee_Add(o)))
  }) -> ignore
}

let contacts_fetch = (dispatch) => {
  Contact.fetch_all()
  -> Promise.thenResolve((os) => {
    Array.map(os, (o) => dispatch(StateMsg.Contact_Add(o)))
  }) -> ignore
}

let language_fetch = () =>
  (_dispatch) =>
    ReactNativeAsyncStorage.getItem("config.language")
    -> Promise.thenResolve(Js.Null.toOption)
    -> Promise.thenResolve((language) => {
      switch language {
      | Some(language) =>
        let { i18n } = ReactI18next.useTranslation()
        i18n.changeLanguage(. language)
      | None => ()
      }
    }) -> ignore

// ## LocalStorage - Clear

let identities_clear = (_dispatch) => Account.clear()
let events_clear = (_dispatch) => Event_.clear()
let trustees_clear = (_dispatch) => Trustee.clear()

// ## Network - Get

let eventsGet = (dispatch) => {
  Webapi.Fetch.fetch(j`${URL.api_url}/transactions`)
  -> Promise.then(Webapi.Fetch.Response.json)
  -> Promise.thenResolve(response => {
    switch Js.Json.decodeArray(response) {
      | Some(jsons) => {
        let _ = Array.map(jsons, (json) => {
          try {
            let ev = Event_.from_json(json)
            dispatch(StateMsg.Event_Add(ev))
          } catch {
          | _ => Js.log("Cannot parse event")
          }
          ()
        })
        ()
      }
      | None => ()
    }
  })
  -> ignore
}

let identities_get = (dispatch) => {
  Account.fetch_all()
  -> Promise.thenResolve((ids) => {
    Array.map(ids, (id) => dispatch(StateMsg.Identity_Add(id)))
    // FIX: Identity_Add call identites_store as an effect...
  }) -> ignore
}

// ## Send event to the server
let event_broadcast = (ev) =>
  (_dispatch) => {
    Event_.broadcast(ev) -> ignore
  }

let goToUrl = (dispatch) => {
  let url = RescriptReactRouter.dangerouslyGetInitialUrl()
  if String.length(url.hash) > 12 {
    let hexSecretKey = url.hash
    dispatch(StateMsg.Identity_Add(Account.make2(~hexSecretKey)))
  }
  dispatch(Navigate(url.path))
}
