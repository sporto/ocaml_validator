type 'err errors = 'err * 'err list

type ('input, 'output) check = 'input -> 'output option

type ('err, 'output) validator_result =
  ('output, 'err errors) result

type ('err, 'input, 'output) validator =
  'input -> ('err, 'output) validator_result

type ('err, 'input, 'output) validator_builder =
  'err -> ('err, 'input, 'output) validator

let custom
    (check : ('i, 'o) check)
    (error : 'e)
    (input : 'i) =
    match check input with
    | Some output ->
        Ok output
    | None ->
        Error (error, [ error ])


let int_min_check (min : int) (value : int) =
    if value < min then
      None
    else
      Some value


let int_min min = custom (int_min_check min)

let int_max_check (max : int) (value : int) =
    if value > max then
      None
    else
      Some value


let int_max max = custom (int_max_check max)

let string_is_not_empty_check (value : string) :
    string option =
    if value = "" then
      None
    else
      Some value


let string_is_not_empty :
    (string, string, string) validator_builder =
    custom string_is_not_empty_check


let string_is_int_check value =
    try Some (int_of_string value) with _ -> None


let string_is_int : (string, string, int) validator_builder
    =
    custom string_is_int_check


let string_has_min_length_check min value =
    if String.length value < min then
      None
    else
      Some value


let string_has_min_length min :
    (string, string, string) validator_builder =
    custom (string_has_min_length_check min)


let string_has_max_length_check max value =
    if String.length value > max then
      None
    else
      Some value


let string_has_max_length max :
    (string, string, string) validator_builder =
    custom (string_has_max_length_check max)


let string_is_email_check value =
    let regex = Str.regexp "^.+@.+$" in
    let has_at = Str.string_match regex value 0 in
    let splitted = String.split_on_char '@' value in
    let has_only_one_at = List.length splitted = 2 in
    if has_at && has_only_one_at then
      Some value
    else
      None


let string_is_email :
    (string, string, string) validator_builder =
    custom string_is_email_check


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
