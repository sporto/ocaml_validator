open Alcotest

let test_hello_with_name name () =
    let greeting = Validator.greet name in
    let expected = "Hello " ^ name ^ "!" in
    check string "same string" greeting expected


let validator_result_printer =
    result string (pair string (list string))


let test_string_is_not_empty input () =
    check validator_result_printer "whatever"
      (Validator.string_is_not_empty "empty" input)
      (Ok "Hello")


let suite =
    [
      ("can greet Tom", `Quick, test_hello_with_name "Tom");
      ("can greet John", `Quick, test_hello_with_name "John");
      ( "check if empty",
        `Quick,
        test_string_is_not_empty "Hello" );
    ]


let () = Alcotest.run "validator" [ ("Validator", suite) ]
