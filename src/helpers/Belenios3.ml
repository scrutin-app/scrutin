module P = struct
  let group = "BELENIOS-2048"
  let version = 1
end

module Random = Belenios_tool_common.Random

let generate_token () =
  let module X = Belenios_core.Common.MakeGenerateToken (Random) in
  X.generate_token ~length:14 ()

let generate_trustee () =
  Belenios_tool_common.Tool_tkeygen.(
    let module R = Make (P) (Random) () in
    let kp = R.trustee_keygen () in
    let my_trustee_key = trustee_public_key_of_string Yojson.Safe.read_json kp.R.pub in
    let my_trustee : 'a Serializable_t.trustee_kind = `Single(my_trustee_key) in
    kp.R.priv, (string_of_trustees Yojson.Safe.write_json [my_trustee])
  )

(* Params: Answers, Name, Description *)
let make_election () =
  let questions = 
    let question_body: Belenios_core.Question_h_t.question = {
      q_answers = [|"yes"; "no"; "groot"|];
      q_blank = Some(false);
      q_min = 0;
      q_max = 1;
      q_question = "Best";
    } in
    let question = Belenios_core.Question.Homomorphic(question_body) in
    [|
      question
    |]
  in

  let template : Belenios_core.Serializable_t.template = {
    t_name = "A name";
    t_description = "A description";
    t_questions = questions;
    t_administrator = None;
    t_credential_authority = None;
  } in

  template
  (*

  let module P = struct
    let version = 1
    let group = "BELENIOS-2048"
    let uuid = generate_token ()
    let template = template |> string_of_template
    let get_trustees () = trustees
  end in

  Belenios_tool_common.Tool_mkelection.(
    let module R = (val make (module P : PARAMS) : S) in
    let params = R.mkelection () in
    params
  )

  *)
