type 'err errors = 'err * 'err list

type ('err, 'output) validator_result =
  ('output, 'err errors) result

type ('err, 'input, 'output) validator =
  'err -> 'input -> ('err, 'output) validator_result

type ('input, 'output) check = 'input -> 'output option

let custom
    (check : ('i, 'o) check)
    (error : 'e)
    (input : 'i) =
    match check input with
    | Some output ->
        Ok output
    | None ->
        Error (error, [ error ])
