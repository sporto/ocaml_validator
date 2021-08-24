(** Create a record validator via composable sub-validators *)

type 'err errors = 'err * 'err list

type ('out, 'err) validator_result =
  ('out, 'err errors) result

type ('input, 'output, 'err) validator =
  'input -> ('output, 'err) validator_result

type ('input, 'output, 'err) validator_builder =
  'err -> ('input, 'output, 'err) validator

val int_min : int -> (int, int, 'err) validator_builder
(** Validate min permitted integeger *)

val int_max : int -> (int, int, 'err) validator_builder
(** Validate max permitted integeger *)

(* Validate that a list is not empty *)
val list_is_not_empty :
  ('a list, 'a list, 'err) validator_builder

val list_has_max_length :
  int -> ('a list, 'a list, 'err) validator_builder

val list_has_min_length :
  int -> ('a list, 'a list, 'err) validator_builder

(* Validate a list of items. Run the given validator for each item returning all the errors. *)
val list_every :
  ('i, 'o, 'err) validator ->
  ('i list, 'o list, 'err) validator

(* Validate that a value is not None.
   Returns the value if Some. *)
val option_is_some : ('a option, 'a, 'err) validator_builder

val string_is_not_empty :
  (string, string, 'err) validator_builder
(** Validate if a string is not empty *)

val string_is_int : (string, int, 'err) validator_builder
(* Validate if a string parses to an Int. Returns the Int if so *)

(* Validate the min length of a string *)
val string_has_min_length :
  int -> (string, string, 'err) validator_builder

(* Validate the max length of a string *)
val string_has_max_length :
  int -> (string, string, 'err) validator_builder

(* Validate if a string is an email.
   This checks if a string follows a simple pattern `_@_`. *)
val string_is_email :
  (string, string, 'err) validator_builder

(* Validate an optional value.
   Run the validator only if the value is Some.
   If the value is None then just return None back. *)
val optional :
  ('i, 'o, 'err) validator ->
  'i option ->
  ('i option, 'err errors) result

(* Keep a value as is. *)
val keep :
  'a ->
  ('a -> 'next_acc, 'e errors) result ->
  ('next_acc, 'e errors) result

val build :
  ('a -> 'final) -> ('a -> 'final, 'e errors) result

val validate :
  'input ->
  ('input, 'output, 'err) validator ->
  ('output -> 'next_acc, 'err errors) result ->
  ('next_acc, 'err errors) result

(* Compose validators
   Run the first validator and if successful then the second.
   Only returns the first error. *)
val compose :
  ('mid, 'o, 'err) validator ->
  ('i, 'mid, 'err) validator ->
  ('i, 'o, 'err) validator

(* Validate a value using a list of validators.
   This runs all the validators in the list.

   The initial input is passed to all validators.
   All these validators must have the same input and output types.

   Returns Ok when all validators pass.
   Returns Error when any validator fails. Error will have all failures. *)
val all :
  ('io, 'io, 'err) validator list ->
  ('io, 'io, 'err) validator

(* Validate a structure as a whole.

   Sometimes we need to validate a property in relation to another. *)
val whole :
  ('whole -> ('whole, 'err) result) ->
  ('whole, 'err) validator_result ->
  ('whole, 'err) validator_result
