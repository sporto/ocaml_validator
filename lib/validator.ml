type 'err errors = 'err Common.errors

type ('err, 'out) validator_result =
  ('err, 'out) Common.validator_result

type ('err, 'input, 'out) validator =
  ('err, 'input, 'out) Common.validator

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


let string_is_int_check value =
    try Some (int_of_string value) with _ -> None


let string_is_int : (string, string, int) validator =
    Common.custom string_is_int_check