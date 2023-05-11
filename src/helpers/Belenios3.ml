(*open Belenios_core.Common*)
open Belenios_core
open Serializable_j
open Belenios_platform
(*open Belenios_js.Common*)

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
    let my_trustee_key = trustee_public_key_of_string Platform.read_json kp.R.pub in
    let my_trustee : 'a Serializable_t.trustee_kind = `Single(my_trustee_key) in
    kp.R.priv, (string_of_trustees Platform.write_json [my_trustee])
  )

(* Params: Answers, Name, Description *)
let make_election (name:string) (description:string) (options:string array) (trustees:string) : 'a = 
  let questions = 
    let question_body: Belenios_core.Question_h_t.question = {
      q_answers = options;
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
    t_name = name;
    t_description = description;
    t_questions = questions;
    t_administrator = None;
    t_credential_authority = None;
  } in

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

let make_credentials uuid n =
  let module P = struct
    let version = 1
    let group = "BELENIOS-2048"
    let uuid = uuid
  end in
  Belenios_tool_common.Tool_credgen.(
    let module R = Make (P) (Random) () in
    let ids = generate_ids n in
    let credentials = R.generate ids in
    credentials.public, (List.map credentials.priv (fun (_a, b) -> b))
  )

let derive_credential uuid public_credential =
  let module P = struct
    let version = 1
    let group = "BELENIOS-2048"
    let uuid = uuid
  end in
  Belenios_tool_common.Tool_credgen.(
    let module R = Make (P) (Random) () in
    R.derive public_credential
  )
  (*let module C = Credential.MakeDerive (P) in*)


let encrypt_ballot election cred plaintext trustees =
  Belenios_tool_common.Tool_election.(
    let module PR : PARAMS_RAW = struct
      let raw_election = election
      let trustees = trustees
      let ballots = []
      let public_creds = []
      let pds = []
    end in
    let module X = MakeRaw (PR) () in
    X.vote (Some cred) plaintext
  )

let compute_encrypted_tally election ballots trustees public_creds =
  Belenios_tool_common.Tool_election.(
    let module PR : PARAMS_RAW = struct
      let raw_election = election
      let trustees = trustees
      let ballots = ballots
      let public_creds = public_creds
      let pds = []
    end in
    let module X = MakeRaw (PR) () in
    X.compute_encrypted_tally ()
  )

let decrypt election ballots trustees public_creds priv_key =
  Belenios_tool_common.Tool_election.(
    let module PR : PARAMS_RAW = struct
      let raw_election = election
      let trustees = trustees
      let ballots = ballots
      let public_creds = public_creds
      let pds = []
    end in
    let module X = MakeRaw (PR) () in
    X.decrypt 1 priv_key
  )

let compute_result election ballots trustees public_creds partial_decryptions = 
  Belenios_tool_common.Tool_election.(
    let module PR : PARAMS_RAW = struct
      let raw_election = election
      let trustees = trustees
      let ballots = ballots
      let public_creds = public_creds
      let pds = partial_decryptions
    end in
    let module X = MakeRaw (PR) () in
    X.compute_result ()
  )

(* actual api *)
let genTrustee () =
  let privkey, trustees = generate_trustee () in
  (privkey, trustees)

let makeElection (name:string) (description:string) (options:(string array)) (trustees:string) =
  let election = make_election name description options trustees in
  election

let encryptBallot (election:string) (cred:string) (plaintext:(int array array)) (trustees:string) =
  let ballot = encrypt_ballot election cred plaintext trustees in
  ballot

let makeCredentials (uuid:string) (n:int) =
  let public_creds, private_creds = make_credentials uuid n in
  (List.toArray(public_creds), List.toArray(private_creds))

let derive (uuid:string) (public_credential:string) =
  derive_credential uuid public_credential

let decrypt
  (election:string)
  (ballots:(string array))
  (trustees:string)
  (credentials:(string array))
  (privkey:string)
  =
  let a, b = decrypt election (List.fromArray ballots) trustees (List.fromArray credentials) privkey in
  (a, b)

let result
  (election:string)
  (ballots:(string array))
  (trustees:string)
  (credentials:(string array))
  (a:string)
  (b:string)
  =
  let my_owned_hash = owned_of_string read_hash b in
  let partial_decryptions = [
    (my_owned_hash.owned_payload,my_owned_hash,a)
  ] in
  let res = compute_result election (List.fromArray ballots) trustees (List.fromArray credentials) partial_decryptions in
  res
