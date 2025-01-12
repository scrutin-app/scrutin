@react.component
let make = (~state: ElectionNewState.t, ~dispatch) => {
  switch state.access {
  | Some(#"open") => <Election_New_Step4_Open state dispatch />
  | Some(#closed) => <Election_New_Step4_Closed state dispatch />
  | _ => Js.Exn.raiseError("Error: access is not set")
  }
}
