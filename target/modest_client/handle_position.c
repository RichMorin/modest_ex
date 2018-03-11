#include "erl_interface.h"
#include "ei.h"

#include "modest_position.h"

ETERM *handle_position(ErlMessage* emsg, ETERM *response){
  if(response == NULL){
    ETERM *pattern = erl_format("{position, Html, Selector, Delimiter}");
    
    if (erl_match(pattern, emsg->msg))
    {
      ETERM *html = erl_var_content(pattern, "Html");
      ETERM *selector = erl_var_content(pattern, "Selector");
      ETERM *delimiter = erl_var_content(pattern, "Delimiter");
      char* html_string = (char*)ERL_BIN_PTR(html);
      char* selector_string = (char*)ERL_BIN_PTR(selector);
      char* delimiter_string = (char*)ERL_BIN_PTR(delimiter);

      const char* result_string = modest_selected_position(html_string, selector_string, delimiter_string);
      ETERM* result_bin = erl_mk_binary(result_string, strlen(result_string));
      response = erl_format("{position, ~w}", result_bin);

      // free allocated resources
      erl_free_term(html);
      erl_free_term(selector);
      erl_free_term(delimiter);
    }

    erl_free_term(pattern);
  }
  return response;
}