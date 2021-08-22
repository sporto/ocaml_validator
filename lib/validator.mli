(** Create a record validator via composable sub-validators *)

type 'err errors = 'err * 'err list

type ('err, 'out) validator_result =
  ('out, 'err errors) result

type ('err, 'input, 'output) validator =
  'err -> 'input -> ('err, 'output) validator_result

val string_is_not_empty : (string, string, string) validator
(** Validate if a string is not empty *)

val string_is_int : (string, string, int) validator
(* Validate if a string parses to an Int. Returns the Int if so *)