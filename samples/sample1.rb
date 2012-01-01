require "picotest"

suite( "a b" => ["a","b"]).test :split
suite( lambda{|x|x.join " "} => _set(["a","b"], ["x","y","z","1"], ["aaa","bbb"]) ).test :split

class X
  def foo(data)
    data.split(";")[2].to_f
  end
end

suite( "aaa;xxx;1.0;999" => 1.0, ";;3.2" => 3.2,
        lambda{|x| ";;#{x}"} => _set(*(1..20).map(&:to_f)),
        lambda{|x| "aaa;xxx;#{x};111"} => _set(*(1..20).map(&:to_f))
        ).test X.new.method(:foo)

