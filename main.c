#include <stdlib.h>
#include <stdio.h>
#include <mruby.h>
#include <mruby/array.h>
#include <mruby/dump.h>
#include <mruby/error.h>
#include <mruby/irep.h>
#include <mruby/proc.h>
#include <mruby/string.h>
#include <mruby/variable.h>
#include <task.h>

extern const uint8_t htest_main[];

static void
set_argv(mrb_state *mrb, int argc, char **argv)
{
  mrb_value args = mrb_ary_new_capa(mrb, argc > 1 ? argc - 1 : 0);
  int i;
  for (i = 1; i < argc; i++) {
    mrb_ary_push(mrb, args, mrb_str_new_cstr(mrb, argv[i]));
  }
  mrb_define_global_const(mrb, "ARGV", args);
}

int
main(int argc, char **argv)
{
  mrb_state *mrb = mrb_open();
  mrb_irep *irep;
  struct RProc *proc;
  mrb_value task;
  int status = EXIT_SUCCESS;

  if (!mrb) {
    fputs("invalid mrb_state\n", stderr);
    return EXIT_FAILURE;
  }
  set_argv(mrb, argc, argv);

  irep = mrb_read_irep(mrb, htest_main);
  if (!irep) {
    fputs("failed to load bytecode\n", stderr);
    mrb_close(mrb);
    return EXIT_FAILURE;
  }

  proc = mrb_proc_new(mrb, irep);
  proc->c = NULL;
  task = mrb_create_task(
    mrb,
    proc,
    mrb_str_new_lit(mrb, "main"),
    mrb_nil_value(),
    mrb_obj_value(mrb->top_self)
  );
  mrb_task_run(mrb);

  mrb_value result = mrb_task_value(mrb, task);
  if (mrb_exception_p(result)) {
    mrb->exc = mrb_obj_ptr(result);
  }
  if (mrb->exc) {
    MRB_EXC_CHECK_EXIT(mrb, mrb->exc);
    mrb_print_error(mrb);
    status = EXIT_FAILURE;
  }
  mrb_close(mrb);
  return status;
}
