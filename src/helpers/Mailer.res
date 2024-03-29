let relay_url = `${URL.server_auth_email}/proxy_email`

let send = (ballotId, account: Account.t, voterId: Account.t, email) => {
  let timestamp: int = %raw(`Date.now()`)
  let hexTimestamp = Js.Int.toStringWithRadix(timestamp, ~radix=16)
  let hexSignedTimestamp = Account.signHex(account, hexTimestamp)

  let message = `
    Hello !
    Vous êtes invité à une élection.
    Cliquez ici pour voter :
    https://demo.scrutin.app/ballots/${ballotId}#${voterId.secret}
  `

  let data = {
    let dict = Js.Dict.empty()
    Js.Dict.set(dict, "email", Js.Json.string(email))
    Js.Dict.set(dict, "subject", Js.Json.string("Vous êtes invité à une élection"))
    Js.Dict.set(dict, "text", Js.Json.string(message))
    Js.Dict.set(dict, "userId", Js.Json.string(account.userId))
    Js.Dict.set(dict, "hexTimestamp", Js.Json.string(hexTimestamp))
    Js.Dict.set(dict, "hexSignedTimestamp", Js.Json.string(hexSignedTimestamp))
    Js.Json.object_(dict)
  }

  X.post(relay_url, data)->ignore
}
