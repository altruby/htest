<p align="center">
  <a href="https://github.com/altruby/picoruby-jail">
    <img src="daemon.png" width="200" height="200" border="0" alt="picoruby-jail">
  </a>
</p>
<p align="center">
  <strong>htest</strong>
</p>

## About


The htest project provides a binary
that is linked against [picoruby](https://picoruby.org),
its test unit library, [picoruby-jail](https://github.com/altruby/picoruby-jail),
and other libraries that are useful
when testing [hardenedBSD](https://hardenedbsd.org)
features. The htest program can be included
in a [Kyuafile(5)](https://man.freebsd.org/kyuafile)
that can be executed by `kyua test`. The
program will run all test files found in
the current working directory that have 
the `_test.rb` suffix. 

## Install

##### ruby

The picoruby build process requires
the ruby34 package to be installed
in order to bootstrap itself.

    pkg install ruby34

##### make

A copy of the 
[picoruby](https://picoruby.org)
source code is required and it 
will be used at build time to 
produce a binary that is linked
against a unit test framework and
other libraries that are useful when
writing tests.

    $ git clone --recurse-submodules https://github.com/picoruby/picoruby picoruby
    $ git clone https://github.com/altruby/htest
    $ cd htest
    $ make build
    $ touch fork_test.rb
    $ ./tmp/htest

## Quick start

##### Write a test

> touch fork_test.rb
> htest

```ruby
class Test < Picotest::Test
  def test_fork
    Process.wait Process.fork { exit 0 }
    assert_equal true, $?.success?
  end
end
```
