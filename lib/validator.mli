(** Create a record validator via composable sub-validators *)

val greet : string -> string
(** Returns a greeting message.

    {4 Examples}

    {[ print_endline @@ greet "Jane" ]} *)

type 'err errors = 'err * 'err list

type ('err, 'out) validator_result =
  ('out, 'err errors) result

type ('err, 'input, 'output) validator =
  'err -> 'input -> ('err, 'output) validator_result

val string_is_not_empty : (string, string, string) validator
