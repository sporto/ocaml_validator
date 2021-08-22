type 'err errors = 'err Common.errors

type ('err, 'out) validator_result =
  ('err, 'out) Common.validator_result

type ('err, 'input, 'out) validator_builder =
  ('err, 'input, 'out) Common.validator_builder

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


let string_is_not_empty :
    (string, string, string) validator_builder =
    Common.custom string_is_not_empty_check


let string_is_int_check value =
    try Some (int_of_string value) with _ -> None


let string_is_int : (string, string, int) validator_builder
    =
    Common.custom string_is_int_check


let validate
    (input : 'i)
    (validator : ('e, 'i, 'o) validator_builder)
    (error : 'e)
    (accumulator : ('o -> 'next_acc, 'e errors) result) :
    ('next_acc, 'e errors) result =
    match validator error input with
    | Ok valid_value ->
        accumulator
        |> Result.map (fun acc -> acc valid_value)
    | Error (e, errors) -> (
        match accumulator with
        | Ok _ ->
            Error (e, errors)
        | Error (first_error, previous_errors) ->
            Error
              ( first_error,
                [ previous_errors; errors ] |> List.flatten
              ))


let build1 fn = Ok fn
