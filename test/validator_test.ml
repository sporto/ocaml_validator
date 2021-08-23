open Alcotest

let validator_result_printer out =
    result out (pair string (list string))


let int_max_test max input expected () =
    let actual = Validator.int_max max "Fail" input in
    check (validator_result_printer int) "" actual expected


let int_max =
    [
      ( "Returns the string when not empty",
        `Quick,
        int_max_test 6 4 (Ok 4) );
      ( "Returns the string when not empty",
        `Quick,
        int_max_test 6 8 (Error ("Fail", [ "Fail" ])) );
    ]


let int_min_test min input expected () =
    let actual = Validator.int_min min "Fail" input in
    check (validator_result_printer int) "" actual expected


let int_min =
    [
      ( "Returns the string when not empty",
        `Quick,
        int_min_test 2 4 (Ok 4) );
      ( "Returns the string when not empty",
        `Quick,
        int_min_test 6 4 (Error ("Fail", [ "Fail" ])) );
    ]


let list_has_max_length_test len input expected () =
    let actual =
        Validator.list_has_max_length len "Fail" input
    in
    check
      (validator_result_printer (list int))
      "" actual expected


let list_has_max_length =
    [
      ( "Returns the the list when not empty",
        `Quick,
        list_has_max_length_test 2 [ 1; 2 ] (Ok [ 1; 2 ]) );
      ( "Returns error",
        `Quick,
        list_has_max_length_test 2 [ 1; 2; 3 ]
          (Error ("Fail", [ "Fail" ])) );
    ]


let list_has_min_length_test len input expected () =
    let actual =
        Validator.list_has_min_length len "Fail" input
    in
    check
      (validator_result_printer (list int))
      "" actual expected


let list_has_min_length =
    [
      ( "Returns the the list when not empty",
        `Quick,
        list_has_min_length_test 2 [ 1; 2 ] (Ok [ 1; 2 ]) );
      ( "Returns error",
        `Quick,
        list_has_min_length_test 3 [ 1; 2 ]
          (Error ("Fail", [ "Fail" ])) );
    ]


let list_is_not_empty_test input expected () =
    let actual = Validator.list_is_not_empty "Fail" input in
    check
      (validator_result_printer (list int))
      "" actual expected


let list_is_not_empty =
    [
      ( "Returns the the list when not empty",
        `Quick,
        list_is_not_empty_test [ 1 ] (Ok [ 1 ]) );
      ( "Returns error when empty",
        `Quick,
        list_is_not_empty_test []
          (Error ("Fail", [ "Fail" ])) );
    ]


let list_every_test validator input expected () =
    let actual = Validator.list_every validator input in
    check
      (validator_result_printer (list int))
      "" actual expected


let list_every =
    [
      ( "Returns the list when all pass",
        `Quick,
        list_every_test
          (Validator.int_max 5 "Fail")
          [ 1; 2; 3 ]
          (Ok [ 1; 2; 3 ]) );
      ( "Returns an error when one fails",
        `Quick,
        list_every_test
          (Validator.int_max 2 "Fail")
          [ 1; 2; 3 ]
          (Error ("Fail", [ "Fail" ])) );
      ( "Returns multiple errors when many fail",
        `Quick,
        list_every_test
          (Validator.int_max 1 "Fail")
          [ 1; 2; 3 ]
          (Error ("Fail", [ "Fail"; "Fail" ])) );
    ]


let option_is_some_test input expected () =
    let actual = Validator.option_is_some "Fail" input in
    check
      (validator_result_printer string)
      "" actual expected


let option_is_some =
    [
      ( "Returns the value when Some",
        `Quick,
        option_is_some_test (Some "Hello") (Ok "Hello") );
      ( "Returns the error when None",
        `Quick,
        option_is_some_test None
          (Error ("Fail", [ "Fail" ])) );
    ]


let string_is_not_empty_test input expected () =
    let actual =
        Validator.string_is_not_empty "Fail" input
    in
    check
      (validator_result_printer string)
      "" actual expected


let string_is_not_empty =
    [
      ( "Returns the string when not empty",
        `Quick,
        string_is_not_empty_test "Hello" (Ok "Hello") );
      ( "Returns the error when empty",
        `Quick,
        string_is_not_empty_test ""
          (Error ("Fail", [ "Fail" ])) );
    ]


let string_is_int_test input expected () =
    let actual = Validator.string_is_int "Fail" input in
    check (validator_result_printer int) "" actual expected


let string_is_int =
    [
      ( "Returns the int",
        `Quick,
        string_is_int_test "1" (Ok 1) );
      ( "Fails when not int",
        `Quick,
        string_is_int_test "a" (Error ("Fail", [ "Fail" ]))
      );
    ]


let string_has_min_length_test input len expected () =
    let actual =
        Validator.string_has_min_length len "Fail" input
    in
    check
      (validator_result_printer string)
      "" actual expected


let string_has_min_length =
    [
      ( "Returns the string when ok",
        `Quick,
        string_has_min_length_test "Hello" 2 (Ok "Hello") );
      ( "Returns the errors",
        `Quick,
        string_has_min_length_test "Hello" 8
          (Error ("Fail", [ "Fail" ])) );
    ]


let string_has_max_length_test input len expected () =
    let actual =
        Validator.string_has_max_length len "Fail" input
    in
    check
      (validator_result_printer string)
      "" actual expected


let string_has_max_length =
    [
      ( "Returns the string when ok",
        `Quick,
        string_has_max_length_test "Hello" 5 (Ok "Hello") );
      ( "Returns the errors",
        `Quick,
        string_has_max_length_test "Hello" 2
          (Error ("Fail", [ "Fail" ])) );
    ]


let string_is_email_test input expected () =
    let actual = Validator.string_is_email "Fail" input in
    check
      (validator_result_printer string)
      "" actual expected


let string_is_email =
    let error = Error ("Fail", [ "Fail" ]) in
    [
      ( "Is email",
        `Quick,
        string_is_email_test "sam@sample.com"
          (Ok "sam@sample.com") );
      ( "Two @",
        `Quick,
        string_is_email_test "sam@@sample.com" error );
      ( "Start with @",
        `Quick,
        string_is_email_test "@sample.com" error );
      ( "End with @",
        `Quick,
        string_is_email_test "sam@" error );
      ( "Extra chars",
        `Quick,
        string_is_email_test "young-sam@sample_biz.com"
          (Ok "young-sam@sample_biz.com") );
      ( "Not email",
        `Quick,
        string_is_email_test "Hello" error );
    ]


(* Complete validators *)

type person_input = { name : string }

type person_valid = { name : string }

let person_pp ppf (person : person_valid) =
    Fmt.pf ppf "%s" person.name


let person_equal (a : person_valid) (b : person_valid) =
    a.name = b.name


let person_printer = testable person_pp person_equal

let build_person_valid name : person_valid = { name }

let validator_test
    (validator : ('e, 'i, 'o) Validator.validator)
    (input : 'i)
    (expected : ('e, 'o) Validator.validator_result)
    () =
    let actual = validator input in
    check
      (validator_result_printer person_printer)
      "" actual expected


let person_validator (input : person_input) :
    (string, person_valid) Validator.validator_result =
    Validator.build build_person_valid
    |> Validator.validate input.name
         Validator.string_is_not_empty "Empty"


let validators =
    [
      ( "Validates a person",
        `Quick,
        validator_test person_validator { name = "Sam" }
          (Ok { name = "Sam" }) );
      ( "Returns errors for person",
        `Quick,
        validator_test person_validator { name = "" }
          (Error ("Empty", [ "Empty" ])) );
    ]


let () =
    Alcotest.run "Validator"
      [
        ("int_max", int_max);
        ("int_min", int_min);
        ("list_is_not_empty", list_is_not_empty);
        ("list_has_max_length", list_has_max_length);
        ("list_has_min_length", list_has_min_length);
        ("list_every", list_every);
        ("option_is_some", option_is_some);
        ("string_has_max_length", string_has_max_length);
        ("string_has_min_length", string_has_min_length);
        ("string_is_email", string_is_email);
        ("string_is_int", string_is_int);
        ("string_is_not_empty", string_is_not_empty);
        ("validators", validators);
      ]
