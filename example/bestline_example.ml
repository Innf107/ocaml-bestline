
let () = 
  begin match Bestline.bestline "bestline> " with
  | None -> print_endline "NONE"
  | Some x -> print_endline ("Input: "^ x)
  end;
  begin match Bestline.bestline_raw "bestline_raw> " Unix.stdin Unix.stdout with
  | None -> print_endline "None"
  | Some x -> print_endline ("Input: "^ x)
  end;
  let _ = Bestline.history_add "This was not your input" in
  begin match Bestline.bestline "with history> " with
  | None -> print_endline "None"
  | Some x -> print_endline ("Input: " ^ x)
  end;
  Bestline.history_free ();
  begin match Bestline.bestline "history freed> " with
  | None -> print_endline "None"
  | Some x -> print_endline ("Input: " ^ x)
  end;
  Bestline.mask_mode_enable ();
  begin match Bestline.bestline "password> " with
  | None -> print_endline "None"
  | Some x -> print_endline ("Input: " ^ x)
  end;
  Bestline.mask_mode_disable ()
  