require "picotest"
# mocking sample

class X
  def foo(data)
    data.split(";")[@fieldno].to_f
  end
end

s = suite( "aaa;xxx;1.0;999" => 1.0, ";;3.2" => 3.2,
        lambda{|x| ";;#{x}"} => _set(*(1..20).map(&:to_f)),
        lambda{|x| "aaa;xxx;#{x};111"} => _set(*(1..20).map(&:to_f)) )

# to mock instance variable use mock method with a hash
s.test X.new.method(:foo).mock(:@fieldno => 2)

class X
  attr_accessor :fieldno
  def foo(data)
    data.split(";")[fieldno].to_f
  end
end

# it also can be use to mock method on the object owner of the method being tested
s.test X.new.method(:foo).mock(:fieldno => 2)


class X
  attr_accessor :another_object
  def foo(data)
    data.split(";")[another_object.fieldno].to_f
  end
end

# you can return mock objects using mock method again
s.test X.new.method(:foo).mock(:another_object => mock(:fieldno => 2) )

class X
  attr_accessor :another_object
  def foo(data)
    another_object.invented_here_split(data,";")[@fieldno].to_f
  end
end

# you can specify the implementatioin of methods using lambdas
s.test X.new.method(:foo).mock(
  :another_object => mock(:invented_here_split => lambda{|str,sep| str.split(sep) }), 
  :@fieldno => 2 )

# Since :split.to_proc is equivalent to lambda{|str,sep| str.split(sep) }, you can also use:
s.test X.new.method(:foo).mock(
  :another_object => mock(:invented_here_split => :split.to_proc), 
  :@fieldno => 2 )


