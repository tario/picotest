require "picotest"
# mocking sample for especial classes

class X
  def foo(a)
    l = bar
    raise RuntimeError unless l.instance_of? Proc
    l.call(a)+1
  end
end

s = suite(0 => 1, 1 => 3, 2 => 5, 3 => 7)

# to mock a method returning lambda, you should use nested lambdas

s.test X.new.method(:foo).mock(:bar => 
  lambda{ # this lambda represents the mock of bar method
    lambda{|x| # this is the lambda returned by the fake bar
      x*2
    }
  }
 )

