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
module Picotest
fixt("fixture should accept :test method", [] => lambda{|x| x.respond_to? :test}).test(method(:fixt))

fixt("raise Fail when tested method raises Fail", 
  [1] => _raise(Fail) ).test(lambda{|x|raise Fail})

failing_fixt = fixt("always fails", [] => lambda{|x| false})
fixt("test should raise Fail when condition returns false", 
  [lambda{}] => _raise(Fail) ).test(failing_fixt.method(:test))

fixt("message of Fail should be 'Test fail: always fails' when expectation title is 'always fails'", 
  [lambda{}] => _raise(Fail, "Test fail: always fails") ).test(failing_fixt.method(:test))

failing_fixt = fixt("unexpected message", [] => lambda{|x| false})
message_fixture = fixt("Should raise Fail with expected message", [lambda{}] => _raise(Fail, "Test fail: expected message") )

fixt("wrong fail message should raise fail", [failing_fixt.method(:test)] => _raise(Fail)).test message_fixture.method(:test) 

failing_fixt = fixt("always always fails", [] => lambda{|x| false})
fixt("message of Fail should be 'Test fail: always always fails' when expectation title is 'always always fails'", 
  [lambda{}] => _raise(Fail, "Test fail: always always fails") ).test(failing_fixt.method(:test))

failing_fixt = fixt([]=>lambda{|x|false})
fixt("failing fixt with lambda{|x|false} and without fail message should fail", [lambda{}]=>_raise(Fail)).
  test(failing_fixt.method(:test))

passing_fixt = fixt("should not raise",[]=>lambda{|x|true})
fixt("passing fixt with lambda{|x|true} should not fail", [lambda{}]=>_not_raise).
  test(passing_fixt.method(:test))

passing_fixt = fixt([]=>lambda{|x|true})
fixt("passing fixt with lambda{|x|true} and without fail message should not fail", [lambda{}]=>_not_raise).
  test(passing_fixt.method(:test))

end

