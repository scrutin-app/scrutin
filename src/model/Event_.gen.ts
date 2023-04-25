/* TypeScript file generated from Event_.res by genType. */
/* eslint-disable import/first */


// tslint:disable-next-line:interface-over-type-literal
export type event_type_t = "election" | "election.update" | "ballot";

// tslint:disable-next-line:interface-over-type-literal
export type t = {
  readonly type_: event_type_t; 
  readonly content: string; 
  readonly cid: string; 
  readonly publicKey: string; 
  readonly signature: string
};
