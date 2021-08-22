type 'err errors = 'err * 'err list

type ('input, 'output) check = 'input -> 'output option

type ('err, 'output) validator_result =
  ('output, 'err errors) result

type ('err, 'input, 'output) validator_builder =
  'err -> 'input -> ('err, 'output) validator_result

type ('err, 'input, 'output) validator =
  'input -> ('err, 'output) validator_result

let custom
    (check : ('i, 'o) check)
    (error : 'e)
    (input : 'i) =
    match check input with
    | Some output ->
        Ok output
    | None ->
        Error (error, [ error ])
