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

# normal test (as you could do the test)
fixt([1] => 1, [2] => 4, [3] => 9, [4] => 16).test lambda{|x| x*x}
fixt([1] => 1, [4] => 2, [9] => 3, [16] => 4).test Math.method(:sqrt)

fixt(_set([1],[-1]) => 1, _set([2],[-2]) => 4, _set([3],[-3]) => 9, _set([4],[-4]) => 16).test lambda{|x| x*x}

fixt( _set(1,4,9,16,25) => lambda{|y,x| y**2==x}).test Math.method(:sqrt)

# picotest testing the test
fixt(
  [lambda{|x|x*x}] => _not_raise,
  [lambda{|x|x**2}] => _not_raise,
  [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 16; end}] => _not_raise,
  [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 15; end}] => _raise(Fail)
  ).test(
    fixt([1] => 1, [2] => 4, [3] => 9, [4] => 16).method(:test)
  )

# same as the previous but using another syntax
fixt(
  _set(
    [lambda{|x|x*x}],[lambda{|x|x**2}], [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 16; end}]) => _not_raise,
  [lambda{|x| case x; when 1; 1; when 2; 4; when 3; 9; when 4; 15; end}] => _raise(Fail)
  ).test(
    fixt([1] => 1, [2] => 4, [3] => 9, [4] => 16).method(:test)
  )

end

