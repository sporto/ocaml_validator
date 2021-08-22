open Alcotest

let test_hello_with_name name () =
    let greeting = Validator.greet name in
    let expected = "Hello " ^ name ^ "!" in
    check string "same string" greeting expected


let validator_result_printer =
    result string (pair string (list string))


let test_string_is_not_empty input expected () =
    let actual =
        Validator.string_is_not_empty "empty" input
    in
    check validator_result_printer "" actual expected


let suite =
    [
      ("can greet Tom", `Quick, test_hello_with_name "Tom");
      ("can greet John", `Quick, test_hello_with_name "John");
    ]


let string_is_not_empty =
    [
      ( "Returns the string when not empty",
        `Quick,
        test_string_is_not_empty "Hello" (Ok "Hello") );
      ( "Returns the error when empty",
        `Quick,
        test_string_is_not_empty ""
          (Error ("empty", [ "empty" ])) );
    ]


let () =
    Alcotest.run "validator"
      [
        ("Validator", suite);
        ("string_is_not_empty", string_is_not_empty);
      ]
