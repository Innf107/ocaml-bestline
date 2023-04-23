#include "bestline.h"

#include "caml/memory.h"
#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/threads.h>

#include <string.h>
#include <errno.h>


// Not all versions of the OCaml runtime define Val_none and caml_alloc_some.
// These were introduced in the same version so we can safely group them together.
#ifndef Val_none
#define Val_none Int_val(0)
CAMLexport value caml_alloc_some(value v)
{
    CAMLparam1(v);
    value some = caml_alloc_small(1, 0);
    Store_field(some, 0, v);
    CAMLreturn(some);
}
#endif

CAMLprim value bestline_stub(value prompt){
    // We have to copy the string, since we cannot access
    // any OCaml data while running without the master lock.
    char* prompt_string = strdup(String_val(prompt));

    // bestline blocks (obviously), so we release the OCaml master lock.
    // This means, we *cannot* use any OCaml runtime functions between 
    // these two calls.
    caml_release_runtime_system();
    char* result_str = bestline(prompt_string);
    free(prompt_string);
    caml_acquire_runtime_system();

    if (result_str == NULL){
        return Val_none;
    } else {
        value result = caml_copy_string(result_str);
        bestlineFree(result_str);
        return caml_alloc_some(result);
    }
}

CAMLprim value bestline_raw_stub(value prompt, value infd, value outfd){
    // We have to copy the string, since we cannot access
    // any OCaml data while running without the master lock.
    char* prompt_string = strdup(String_val(prompt));

    // We abuse the fact that Unix.file_descr is just represented
    // as an int internally, even though in the OCaml interface
    // it is abstract.
    int infd_int = Int_val(infd);
    int outfd_int = Int_val(outfd);

    // bestline blocks (obviously), so we release the OCaml master lock.
    // This means, we *cannot* use any OCaml runtime functions between 
    // these two calls.
    caml_release_runtime_system();
    char* result_str = bestlineRaw(prompt_string, infd_int, outfd_int);
    free(prompt_string);
    caml_acquire_runtime_system();

    if (result_str == NULL){
        return Val_none;
    } else {
        value result = caml_copy_string(result_str);
        bestlineFree(result_str);
        return caml_alloc_some(result);
    }
}

CAMLprim value bestline_with_history_stub(value prompt, value prog){
    // We have to copy the strings, since we cannot access
    // any OCaml data while running without the master lock.
    char* prompt_string = strdup(String_val(prompt));
    char* prog_string = strdup(String_val(prog));

    // bestline blocks (obviously), so we release the OCaml master lock.
    // This means, we *cannot* use any OCaml runtime functions between 
    // these two calls.
    caml_release_runtime_system();
    char* result_str = bestlineWithHistory(prompt_string, prog_string);
    free(prompt_string);
    free(prog_string);
    caml_acquire_runtime_system();

    if (result_str == NULL){
        return Val_none;
    } else {
        value result = caml_copy_string(result_str);
        bestlineFree(result_str);
        return caml_alloc_some(result);
    }
}

CAMLprim value bestline_history_add_stub(value line){
    // We *don't* need to copy line, since we
    // are not going to release the master lock
    int result = bestlineHistoryAdd(String_val(line));

    if (result == 0) {
        return Val_false;
    } else {
        return Val_true;
    }
}

CAMLprim value bestline_history_save_stub(value filename){
    int result = bestlineHistorySave(String_val(filename));

    if (result == 0){
        return Val_none;
    } else {
        return caml_alloc_some(Val_int(errno));
    }
}

CAMLprim value bestline_history_load_stub(value filename){
    int result = bestlineHistoryLoad(String_val(filename));

    if (result == 0){
        return Val_none;
    } else {
        return caml_alloc_some(Val_int(errno));
    }
}

CAMLprim value bestline_history_free_stub(value _unit){
    bestlineHistoryFree();
    return Val_unit;
}

CAMLprim value bestline_clear_screen_stub(value fd){
    bestlineClearScreen(Int_val(fd));
    return Val_unit;
}

CAMLprim value bestline_mask_mode_enable_stub(value _unit){
    bestlineMaskModeEnable();
    return Val_unit;
}

CAMLprim value bestline_mask_mode_disable_stub(value _unit){
    bestlineMaskModeDisable();
    return Val_unit;
}

CAMLprim value bestline_disable_raw_mode_stub(value _unit){
    bestlineMaskModeDisable();
    return Val_unit;
}

CAMLprim value bestline_is_separator_stub(value chr){
    if (bestlineIsSeparator(Int_val(chr)) == 0) {
        return Val_false;
    } else {
        return Val_true;
    }
}

CAMLprim value bestline_not_separator_stub(value chr){
    if (bestlineNotSeparator(Int_val(chr)) == 0) {
        return Val_false;
    } else {
        return Val_true;
    }
}

CAMLprim value bestline_is_xeparator_stub(value chr){
    if (bestlineIsXeparator(Int_val(chr)) == 0) {
        return Val_false;
    } else {
        return Val_true;
    }
}

CAMLprim value bestline_uppercase_stub(value chr){
    return Val_int (bestlineUppercase(Int_val(chr)));
}

CAMLprim value bestline_lowercase_stub(value chr){
    return Val_int (bestlineLowercase(Int_val(chr)));
}
