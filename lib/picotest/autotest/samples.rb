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
module Picotest

if ENV['PICOTEST_AUTOTEST'] == '1'
# normal test (as you could do the test)
suite("squared 1,2,3,4", [1] => 1, [2] => 4, [3] => 9, [4] => 16).test lambda{|x| x*x}
suite("negative number elevated to 2",_set([1],[-1]) => 1, _set([2],[-2]) => 4, _set([3],[-3]) => 9, _set([4],[-4]) => 16).test lambda{|x| x*x}

suite("sqrt of 1,4,9,16",[1] => 1, [4] => 2, [9] => 3, [16] => 4).test Math.method(:sqrt)

suite("sqrt of pf 1,4,9,16,25", _set(1,4,9,16,25) => lambda{|y,x| y**2==x}).test Math.method(:sqrt)
suite("sqrt of 1 to 20 elevated to 2", lambda{|x| x**2} => _set(*(1..20))).test Math.method(:sqrt)

suite("sqrt of 1 to 100",_set(*(1..100)) => lambda{|y,x| (y**2 - x.to_f).abs < 0.000000005}).test Math.method(:sqrt)

# all last four togheter

suite("sqrt", [1] => 1, [4] => 2, [9] => 3, [16] => 4,
      _set(1,4,9,16,25) => lambda{|y,x| y**2==x}, 
      lambda{|x| x**2} => _set(*(1..20)),
      _set(*(1..100)) => lambda{|y,x| y**2 - x.to_f < 0.000000005} ).test(Math.method(:sqrt))

# picotest testing the test
suite(
  [lambda{|x|x*x}] => _not_raise,
  [lambda{|x|x**2}] => _not_raise,
  [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 16; end}] => _not_raise,
  [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 15; end}] => _raise(Fail)
  ).test(
    suite([1] => 1, [2] => 4, [3] => 9, [4] => 16).method(:test)
  )

# same as the previous but using another syntax
suite(
  _set(
    [lambda{|x|x*x}],[lambda{|x|x**2}], [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 16; end}]) => _not_raise,
  [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 15; end}] => _raise(Fail)
  ).test(
    suite([1] => 1, [2] => 4, [3] => 9, [4] => 16).method(:test)
  )

end
end

