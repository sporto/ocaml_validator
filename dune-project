(lang dune 2.0)

(name validator)





(license ISC)

(authors
  "Sebastian Porto")

(maintainers
  "Sebastian Porto")

(generate_opam_files true)

(package
 (name validator)
 (synopsis "Create a record validator via composable sub-validators")
 (description "Create a record validator via composable sub-validators")
 (depends
  (ocaml (>= 4.08.0))
  dune
  (alcotest :with-test)
  (odoc :with-doc)))
