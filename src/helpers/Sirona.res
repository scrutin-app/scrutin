module Trustee = {
  type t
  type serialized_t

  @module("sirona") @scope("Trustee") @val
  external create: () => (int, serialized_t) = "generate"

  @module("sirona") @scope("Trustee") @val
  external fromJSON: (serialized_t) => t = "fromJSON"

  @module("sirona") @scope("Trustee") @val
  external toJSON: (t) => serialized_t = "toJSON"
}

module QuestionH = {
  type t = {
    answers: array<string>,
    blank?: bool,
    min: int,
    max: int,
    question: string
  };
}

module Election = {
  type t = {
    version: int,
    description: string,
    name: string,
    group: string,
    //public_key: Point.t;
    //questions: Question.t[];
    uuid: string,
    administrator?: string,
    credential_authority?: string
  }

  @module("sirona") @scope("Election") @val
  external create: (string, string, array<Trustee.t>, array<QuestionH.t>) => t = "create"
}