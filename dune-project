(lang dune 3.1)

(name bestline)

(generate_opam_files true)

(source
 (github Innf107/ocaml-bestline))

(authors "Finn Schneider")

(maintainers "Finn Schneider")

(license MIT)

(documentation https://github.com/Innf107/ocaml-bestline)

(package
 (name bestline)
 (synopsis "OCaml bindings for the bestline C library")
 (description "OCaml bindings for the bestline C library")
 (depends ocaml dune unix)
 )

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
