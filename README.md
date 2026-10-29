<p align="center">
  <a href="https://github.com/altruby/picoruby-jail">
    <img src="daemon.png" width="200" height="200" border="0" alt="picoruby-jail">
  </a>
</p>
<p align="center">
  <strong>htest</strong>
</p>

## About

This project is built with
[picoruby](https://picoruby.org/)
and it exists to provide a 
binary that links against
picoruby's test framework
and other libraries that can
be used to test hardenedBSD
features. The binary is 
dynamically linked but 
otherwise standalone.

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
    $ ./tmp/htest test_fork.rb

## Quick start

##### Write a test

> picoruby test_fork.rb

```ruby
class Test < Picotest::Test
  def test_fork
    Process.wait Process.fork { exit 0 }
    assert_equal true, $?.success?
  end
end
```
