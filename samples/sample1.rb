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

suite(_set(-2,2) => 4).test lambda{|x|x*x}
suite(lambda{|x|x*x} => 2).test Math.method(:sqrt)
suite(4 => lambda{|y,x| y*y == x}).test Math.method(:sqrt)
suite(_set(1,2,3,4,5) => lambda{|y,x| (y*y - x).abs<0.00001}).test Math.method(:sqrt)
suite(_set(*(1..100) ) => lambda{|y,x| (y*y - x).abs<0.00001}).test Math.method(:sqrt)

class X
  def sum(*x)
    x.inject{|a,b| a+b}
  end
end

suite( 1 => 1, [1,2] => 3, [1,2,3] => 6 ).test X.new.method(:sum)
suite( _set(6,[1,5],[2,4],[3,3],[4,2],[5,1]) => 6 ).test X.new.method(:sum)
suite(_set(*(1..100)) => lambda{|y,x| y == x},
      _set([1,2],[3,4],[4,6],[5,6]) => lambda{|y,x1,x2| y == x1+x2},
      _set([1,2,3],[3,4,5],[4,6,7],[5,6,7]) => lambda{|y,x1,x2,x3| y == x1+x2+x3}
      ).test X.new.method(:sum)


