exception BestlineError of string * int

(**
Reads line intelligently.

The high level function that is the main API of the bestline library.
This function checks if the terminal has basic capabilities, just checking
for a blacklist of inarticulate terminals, and later either calls the line
editing function or uses dummy fgets() so that you will be able to type
something even in the most desperate of the conditions.

@param prompt is printed before asking for input if we have a term
    and this may be set to empty to disable and prompt may
    contain ansi escape sequences, color, utf8, etc.
@return chomped allocated string of read line or None on eof/error
*)
external bestline : string -> string option = "bestline_stub"

(**
 Reads line interactively.

 This function can be used instead of bestline() in cases where we
 know for certain we're dealing with a terminal, which means we can
 avoid linking any stdio code.

 @return chomped allocated string of read line or None on eof/error
 *)
external bestline_raw : string -> Unix.file_descr -> Unix.file_descr -> string option = "bestline_raw_stub"


(**
 Reads line intelligently w/ history, e.g.

    (* see ~/.foo_history *)
    let () =
      let go () =
        match bestline_with_history("In> ", "foo") with
        | None -> ()
        | Some line ->
          Printf.printf "OUT> %s\n" line;
          go ()
      go ()

 @param prompt is printed before asking for input if we have a term
     and this may be set to empty to disable and prompt may
     contain ansi escape sequences, color, utf8, etc.
 @param prog is name of your app, used to generate history filename
     however if it contains a slash / dot then we'll assume prog is
     the history filename which as determined by the caller
 @return chomped allocated string of read line or None on eof/error
 *)
external bestline_with_history : string -> string -> string option = "bestline_with_history_stub"

external history_add : string -> bool = "bestline_history_add_stub"

external history_save_raw : string -> int option = "bestline_history_save_stub"

let history_save : string -> unit =
  fun filename ->
    match history_save_raw filename with
    | None  -> ()
    | Some err -> raise (BestlineError ("history_save", err))

external history_load_raw : string -> int option = "bestline_history_load_stub"

let history_load : string -> unit =
  fun filename ->
    match history_load_raw filename with
    | None  -> ()
    | Some err -> raise (BestlineError ("history_load", err))

external history_free : unit -> unit = "bestline_history_free_stub"

(** Clear the screen. Used to handle ctrl+l *)
external clear_screen : Unix.file_descr -> unit = "bestline_clear_screen_stub"

(**
  Enables "mask mode".
 
  When it is enabled, instead of the input that the user is typing, the
  terminal will just display a corresponding number of asterisks, like
  "****". This is useful for passwords and other secrets that should
  not be displayed.
 
  @see bestlineMaskModeDisable()
 *)
external mask_mode_enable : unit -> unit = "bestline_mask_mode_enable_stub"

external mask_mode_disable : unit -> unit = "bestline_mask_mode_disable_stub"

external disable_raw_mode : unit -> unit = "bestline_disable_raw_mode_stub"

external is_separator : char -> bool = "bestline_is_separator_stub"
external not_separator : char -> bool = "bestline_not_separator_stub"

external is_xeparator : char -> bool = "bestline_is_xeparator_stub"

external uppercase : char -> char = "bestline_uppercase_stub"
external lowercase : char -> char = "bestline_lowercase_stub"
