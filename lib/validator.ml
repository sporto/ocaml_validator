type 'err errors = 'err Common.errors

type ('err, 'out) validator_result =
  ('err, 'out) Common.validator_result

type ('err, 'input, 'out) validator =
  ('err, 'input, 'out) Common.validator

let greet name = "Hello " ^ name ^ "!"

(* let validate field validator =
   1 *)

let string_is_not_empty_check (value : string) :
    string option =
    if value = "" then
      None
    else
      Some value


let string_is_not_empty : (string, string, string) validator
    =
    Common.custom string_is_not_empty_check
