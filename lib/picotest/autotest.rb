=begin

This file is part of the picotest project, http://github.com/tario/picotest

Copyright (c) 2011 Roberto Dario Seminara <robertodarioseminara@gmail.com>

picotest is free software: you can redistribute it and/or modify
it under the terms of the gnu general public license as published by
the free software foundation, either version 3 of the license, or
(at your option) any later version.

picotest is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  see the
gnu general public license for more details.

you should have received a copy of the gnu general public license
along with picotest.  if not, see <http://www.gnu.org/licenses/>.

=end
# pico test testing himself
require "picotest/autotest/samples"

module Picotest
suite("suiteure should accept :test method", [] => lambda{|x| x.respond_to? :test}).test(method(:suite))

suite("raise Fail when tested method raises Fail", 
  [1] => _raise(Fail) ).test(lambda{|x|raise Fail})

failing_suite = suite("always fails", [] => lambda{|x| false})
suite("test should raise Fail when condition returns false", 
  [lambda{}] => _raise(Fail) ).test(failing_suite.method(:test))

suite("message of Fail should be 'Test fail: always fails' when expectation title is 'always fails'", 
  [lambda{}] => _raise(Fail, "Test fail: always fails") ).test(failing_suite.method(:test))

failing_suite = suite("unexpected message", [] => lambda{|x| false})
message_suiteure = suite("Should raise Fail with expected message", [lambda{}] => _raise(Fail, "Test fail: expected message") )

suite("wrong fail message should raise fail", [failing_suite.method(:test)] => _raise(Fail)).test message_suiteure.method(:test) 

failing_suite = suite("always always fails", [] => lambda{|x| false})
suite("message of Fail should be 'Test fail: always always fails' when expectation title is 'always always fails'", 
  [lambda{}] => _raise(Fail, "Test fail: always always fails") ).test(failing_suite.method(:test))

failing_suite = suite([]=>lambda{|x|false})
suite("failing suite with lambda{|x|false} and without fail message should fail", [lambda{}]=>_raise(Fail)).
  test(failing_suite.method(:test))

passing_suite = suite("should not raise",[]=>lambda{|x|true})
suite("passing suite with lambda{|x|true} should not fail", [lambda{}]=>_not_raise).
  test(passing_suite.method(:test))

passing_suite = suite([]=>lambda{|x|true})
suite("passing suite with lambda{|x|true} and without fail message should not fail", [lambda{}]=>_not_raise).
  test(passing_suite.method(:test))

suite("numeric assert should not fail", 
  [lambda{|x|x}] => _not_raise,
  [lambda{|x|1}] => _not_raise,
  [lambda{|x|0}] => _raise(Fail)).test(
  suite([1] => 1).method(:test)
  ) 

suite("_set([1],[2],[3]) should pass with lambda{|x| [1,2,3].include? x}", 
  [ lambda{|x| [1,2,3].include?(x) ? 4: nil} ] => _not_raise
).test( suite(_set([1],[2],[3]) => 4).method(:test) )

suite("_set([1],[2],[3]) should pass with lambda{|x| [1,2,3].include? x}", 
  [ lambda{|x| [1,2,3].include?(x) ? 4: nil} ] => _not_raise
).test( suite(_set(1,2,3) => 4).method(:test) )

end

