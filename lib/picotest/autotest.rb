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

end

