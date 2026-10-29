#include <mruby.h>
#include <mruby/variable.h>
#include <mruby/value.h>
#include <mruby/numeric.h>
#include <mruby/class.h>
#include <mruby/error.h>
#include <unistd.h>
#include <stdlib.h>

mrb_value
static mrbfork(mrb_state *mrb, mrb_value self)
{
  pid_t pid;
  mrb_value b;
  mrb_get_args(mrb, "&", &b);
  pid = fork();
  if (pid < 0) {
    mrb_sys_fail(mrb, "fork");
  } else if (pid == 0) {
    /* child */
    if(mrb_block_given_p(mrb)) {
      mrb_yield(mrb, b, mrb_nil_value());
      exit(EXIT_SUCCESS);
    }
  } else {
    /* parent */
    return mrb_int64_value(mrb, (int64_t)pid);
  }
}
void
mrb_htest_gem_init(mrb_state *mrb)
{
  mrb_value p;
  p = mrb_const_get(mrb, mrb_obj_value(mrb->object_class), mrb_intern_lit(mrb, "Process"));
  mrb_define_class_method(mrb, mrb_class_ptr(p), "fork", mrbfork, MRB_ARGS_NONE());
}

void
mrb_htest_gem_final(mrb_state *mrb)
{
  (void)mrb;
}
