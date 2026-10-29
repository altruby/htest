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

##### Requirements

Requires the hardened/15-stable/pledge branch to
be installed or it won't build.

##### ruby

PicoRuby requires (ruby|gcc|rake) to be installed
so it can bootstrap itself: 

    for package in gcc rubygem ruby; do
      pkg install ${package}
    done

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

##### What's available?

The htest program is linked against
a number of different libraries that
are always available to your tests.
Those include (but not limited to):

* picoruby-picotest
* [picoruby-jail](https://github.com/altruby/picoruby-jail)
* [picoruby-pledge](https://github.com/altruby/picoruby-pledge)

For example:

```ruby

class Test < Picotest::Test
  def setup
    @jail = Jail.create(
      name: "test",
      path: "/tmp/base",
      persist: true
    )
  end

  def teardown
    @jail.remove
  end

  def test_jail_attach
    pid = Process.fork do
      @jail.attach
      exit 1
    end
    Process.wait(pid)
    assert_equal 1, $?.exitstatus
  end
end
```

##### Write a test

> touch fork_test.rb  
> htest

```ruby
class Test < Picotest::Test
  def test_fork
    Process.wait Process.fork { exit 0 }
    assert_equal 0, $?.exitstatus
  end
end
```
