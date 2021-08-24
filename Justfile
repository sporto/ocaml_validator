create_switch: ## Create an opam switch without any dependency
	opam switch create . --no-install -y

# Create an opam switch and install development dependencies
switch:
	opam install . --deps-only --with-doc --with-test
	opam install -y dune-release ocamlformat utop ocaml-lsp-server

# Build the project, including non installable libraries and executables
build:
	opam exec -- dune build --root .

test: ## Run the unit tests
	opam exec -- dune runtest --root .

# Generate odoc documentation
doc:
	opam exec -- dune build --root . @doc