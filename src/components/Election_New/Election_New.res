@react.component
let make = () => {
  let (state, setState) = React.useState(_ => Election_New_State.empty)

  switch (state.step) {
  | Step0 => <Election_New_Step0 state setState />
  | Step1 => <Election_New_Step1 state setState />
  | Step2 =>
    switch state.votingMethod {
    | Some(#uninominal) => <Election_New_Step2_Uninominal state setState />
    | Some(#majorityJudgement) => <Election_New_Step2_MajorityJudgement state setState />
    | None => Js.Exn.raiseError("Voting method not set")
    }
  | Step3 => <Election_New_Step3 state setState />
  | Step4 => <Election_New_Step4 state setState />
  | Step5 => <Election_New_Step5 state setState />
  }
}
