(** Create a record validator via composable sub-validators *)

type 'err errors = 'err * 'err list

type ('err, 'out) validator_result =
  ('out, 'err errors) result

type ('err, 'input, 'output) validator_builder =
  'err -> 'input -> ('err, 'output) validator_result

type ('err, 'input, 'output) validator =
  'input -> ('err, 'output) validator_result

val string_is_not_empty :
  (string, string, string) validator_builder
(** Validate if a string is not empty *)

val string_is_int : (string, string, int) validator_builder
(* Validate if a string parses to an Int. Returns the Int if so *)

val build1 :
  ('a -> 'final) -> ('a -> 'final, 'e errors) result

val validate :
  'input ->
  ('err, 'input, 'output) validator_builder ->
  'err ->
  ('output -> 'next_acc, 'err errors) result ->
  ('next_acc, 'err errors) result