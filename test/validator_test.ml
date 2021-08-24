open Alcotest

let validator_result_printer out =
    result out (pair string (list string))


let int_max_test max input expected () =
    let actual = Validator.int_max max "Fail" input in
    check (validator_result_printer int) "" expected actual


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
    check (validator_result_printer int) "" expected actual


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
      "" expected actual


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
      "" expected actual


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
      "" expected actual


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
      "" expected actual


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
      "" expected actual


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
      "" expected actual


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
    check (validator_result_printer int) "" expected actual


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
      "" expected actual


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
      "" expected actual


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
      "" expected actual


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


let optional_test validator input expected () =
    let actual = Validator.optional validator input in
    check
      (validator_result_printer (option string))
      "" expected actual


let optional =
    let validator =
        Validator.string_is_email "Not an email"
    in
    [
      ( "Is doesn't run the validator when None",
        `Quick,
        optional_test validator None (Ok None) );
      ( "Is runs the validator when Some",
        `Quick,
        optional_test validator (Some "sam@sample.com")
          (Ok (Some "sam@sample.com")) );
      ( "Is can fail the validator when Some",
        `Quick,
        optional_test validator (Some "sample.com")
          (Error ("Not an email", [ "Not an email" ])) );
    ]


(* Complete validators *)

let validator_test
    printer
    (validator : ('e, 'i, 'o) Validator.validator)
    (input : 'i)
    (expected : ('e, 'o) Validator.validator_result)
    () =
    let actual = validator input in
    check
      (validator_result_printer printer)
      "" expected actual


module PersonInput = struct
  type t = { name : string }
end

module PersonValid = struct
  type t = { name : string }

  let pp ppf (person : t) = Fmt.pf ppf "%s" person.name

  let equal (a : t) (b : t) = a.name = b.name

  let printer = testable pp equal

  let build name : t = { name }
end

let person_validator (input : PersonInput.t) :
    (string, PersonValid.t) Validator.validator_result =
    let open PersonInput in
    Validator.build PersonValid.build
    |> Validator.validate input.name
         (Validator.string_is_not_empty "Empty")


module FormInput = struct
  type t = {
    name : string;
    email : string option;
    age : int;
    username : string option;
    hobbies : string list;
  }
end

module FormValid = struct
  type t = {
    name : string;
    email : string;
    age : int;
    username : string option;
    hobbies : string list;
  }
  [@@deriving show, eq]

  let build name email age username hobbies =
      { name; email; age; username; hobbies }


  let printer =
      testable (fun ppf t -> Fmt.pf ppf "%s" (show t)) equal
end

let form_validator (input : FormInput.t) :
    (string, FormValid.t) Validator.validator_result =
    let open FormInput in
    let open Validator in
    let validator_name =
        string_is_not_empty "Empty"
        |> compose
             (string_has_min_length 3 "Name is too short")
    in
    let validator_email =
        option_is_some "Missing email"
        |> compose (string_is_email "Not an email")
    in
    build FormValid.build
    |> validate input.name validator_name
    |> validate input.email validator_email
    |> validate input.age (int_min 13 "Must be 13")
    |> validate input.username
         (optional
            (string_is_not_empty "Username is empty"))
    |> validate input.hobbies
         (list_every (string_is_not_empty "Invalid hobby"))


let validators =
    [
      ( "Validates a person",
        `Quick,
        validator_test PersonValid.printer person_validator
          { PersonInput.name = "Sam" }
          (Ok { PersonValid.name = "Sam" }) );
      ( "Returns errors for person",
        `Quick,
        validator_test PersonValid.printer person_validator
          { PersonInput.name = "" }
          (Error ("Empty", [ "Empty" ])) );
      ( "Validates a form",
        `Quick,
        validator_test FormValid.printer form_validator
          {
            FormInput.name = "Sam";
            FormInput.email = Some "sam@sample.com";
            FormInput.age = 14;
            FormInput.username = None;
            FormInput.hobbies = [ "art" ];
          }
          (Ok
             {
               FormValid.name = "Sam";
               FormValid.email = "sam@sample.com";
               FormValid.age = 14;
               FormValid.username = None;
               FormValid.hobbies = [ "art" ];
             }) );
      ( "Fails when name is too short",
        `Quick,
        validator_test FormValid.printer form_validator
          {
            FormInput.name = "S";
            FormInput.email = Some "sam@sample.com";
            FormInput.age = 14;
            FormInput.username = None;
            FormInput.hobbies = [ "art" ];
          }
          (Error
             ("Name is too short", [ "Name is too short" ]))
      );
      ( "Fails when email is none",
        `Quick,
        validator_test FormValid.printer form_validator
          {
            FormInput.name = "Sam";
            FormInput.email = None;
            FormInput.age = 14;
            FormInput.username = None;
            FormInput.hobbies = [ "art" ];
          }
          (Error ("Missing email", [ "Missing email" ])) );
      ( "Fails when not an email",
        `Quick,
        validator_test FormValid.printer form_validator
          {
            FormInput.name = "Sam";
            FormInput.email = Some "@sample.com";
            FormInput.age = 14;
            FormInput.username = None;
            FormInput.hobbies = [ "art" ];
          }
          (Error ("Not an email", [ "Not an email" ])) );
      ( "Runs the optional validator",
        `Quick,
        validator_test FormValid.printer form_validator
          {
            FormInput.name = "Sam";
            FormInput.email = Some "sam@sample.com";
            FormInput.age = 14;
            FormInput.username = Some "";
            FormInput.hobbies = [ "art" ];
          }
          (Error
             ("Username is empty", [ "Username is empty" ]))
      );
      ( "Returns all the errors",
        `Quick,
        validator_test FormValid.printer form_validator
          {
            FormInput.name = "S";
            FormInput.email = Some "@sample.com";
            FormInput.age = 1;
            FormInput.username = Some "";
            FormInput.hobbies = [ "art"; "" ];
          }
          (Error
             ( "Name is too short",
               [
                 "Name is too short";
                 "Not an email";
                 "Must be 13";
                 "Username is empty";
                 "Invalid hobby";
               ] )) );
    ]


(* TODO test form validator *)

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
        ("optional", optional);
        ("validators", validators);
      ]
