(** Create a record validator via composable sub-validators *)

type 'err errors = 'err * 'err list

type ('err, 'out) validator_result =
  ('out, 'err errors) result

type ('err, 'input, 'output) validator =
  'input -> ('err, 'output) validator_result

type ('err, 'input, 'output) validator_builder =
  'err -> ('err, 'input, 'output) validator

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

val build1 :
  ('a -> 'final) -> ('a -> 'final, 'e errors) result

val validate :
  'input ->
  ('err, 'input, 'output) validator_builder ->
  'err ->
  ('output -> 'next_acc, 'err errors) result ->
  ('next_acc, 'err errors) result