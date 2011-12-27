# pico test testing himself
module Picotest
fixt("fixture should accept :test method", [] => lambda{|x| x.respond_to? :test}).test(method(:fixt))

fixt("raise Fail when tested method raises Fail", 
  [1] => _raise(Fail) ).test(lambda{|x|raise Fail})

failing_fixt = fixt("always fails", [] => lambda{|x| false})
fixt("test should raise Fail when condition returns false", 
  [lambda{}] => _raise(Fail) ).test(failing_fixt.method(:test))

fixt("test should raise Fail when condition returns false", 
  [lambda{}] => _raise(Fail, "Test fail: always fails") ).test(failing_fixt.method(:test))

end

