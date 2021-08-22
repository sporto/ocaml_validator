open Alcotest

let validator_result_printer out =
    result out (pair string (list string))


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
    Validator.build1 build_person_valid
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
        ("string_is_not_empty", string_is_not_empty);
        ("string_is_int", string_is_int);
        ("validators", validators);
      ]
