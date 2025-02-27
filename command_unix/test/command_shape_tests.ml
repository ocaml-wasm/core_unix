open Core
open Async
open Expect_test_helpers_async
open Deferred.Let_syntax

let run_scenario instructions =
  run
    "env"
    ((* disable backtraces *)
     "OCAMLRUNPARAM=b=0"
     :: "../test-bin/command_shape_test_parent.exe"
     :: [%of_sexp: string list] (Sexp.of_string instructions))
;;

(* All valid permutations of writing and closing both stdout and stderr. *)
let%expect_test _ =
  let%bind () = run_scenario "(write_stderr write_stdout close_stdout close_stderr)" in
  [%expect {|
    [Command_unix.shape] returned but failed to parse, as expected |}];
  return ()
;;

let%expect_test _ =
  let%bind () = run_scenario "(write_stderr close_stderr write_stdout close_stdout)" in
  [%expect {|
    [Command_unix.shape] returned but failed to parse, as expected |}];
  return ()
;;

let%expect_test _ =
  let%bind () = run_scenario "(write_stdout write_stderr close_stdout close_stderr)" in
  [%expect {|
    [Command_unix.shape] returned but failed to parse, as expected |}];
  return ()
;;

let%expect_test _ =
  let%bind () = run_scenario "(write_stdout write_stderr close_stderr close_stdout)" in
  [%expect {|
    [Command_unix.shape] returned but failed to parse, as expected |}];
  return ()
;;

let%expect_test _ =
  let%bind () = run_scenario "(write_stdout close_stdout write_stderr close_stderr)" in
  [%expect {|
    [Command_unix.shape] returned but failed to parse, as expected |}];
  return ()
;;
