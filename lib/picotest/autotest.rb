# pico test testing himself
module Picotest

fixt("fixture should accept :test method", [] => lambda{|x| x.respond_to? :test}).test(method(:fixt))

end

