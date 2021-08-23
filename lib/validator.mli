(** Create a record validator via composable sub-validators *)

type 'err errors = 'err * 'err list

type ('err, 'out) validator_result =
  ('out, 'err errors) result

type ('err, 'input, 'output) validator =
  'input -> ('err, 'output) validator_result

type ('err, 'input, 'output) validator_builder =
  'err -> ('err, 'input, 'output) validator

val int_min : int -> (string, int, int) validator_builder
(** Validate min permitted integeger *)

val int_max : int -> (string, int, int) validator_builder
(** Validate max permitted integeger *)

(* Validate that a list is not empty *)
val list_is_not_empty :
  (string, 'a list, 'a list) validator_builder

val list_has_max_length :
  int -> (string, 'a list, 'a list) validator_builder

val list_has_min_length :
  int -> (string, 'a list, 'a list) validator_builder

(* Validate a list of items. Run the given validator for each item returning all the errors. *)
val list_every :
  (string, 'i, 'o) validator ->
  (string, 'i list, 'o list) validator

(* Validate that a value is not None.
   Returns the value if Some. *)
val option_is_some :
  (string, 'a option, 'a) validator_builder

val string_is_not_empty :
  (string, string, string) validator_builder
(** Validate if a string is not empty *)

val string_is_int : (string, string, int) validator_builder
(* Validate if a string parses to an Int. Returns the Int if so *)

(* Validate the min length of a string *)
val string_has_min_length :
  int -> (string, string, string) validator_builder

(* Validate the max length of a string *)
val string_has_max_length :
  int -> (string, string, string) validator_builder

(* Validate if a string is an email.
   This checks if a string follows a simple pattern `_@_`. *)
val string_is_email :
  (string, string, string) validator_builder

val build :
  ('a -> 'final) -> ('a -> 'final, 'e errors) result

val validate :
  'input ->
  ('err, 'input, 'output) validator_builder ->
  'err ->
  ('output -> 'next_acc, 'err errors) result ->
  ('next_acc, 'err errors) result