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
class Object
  def to_test_proc
    lambda{|m,*i|
      self == m.call(*i)
    }
  end
end

class Proc
  def to_test_proc
    lambda { |m,*i|
      o = m.call(*i)
      self.call(o)
    }
  end
end

module Picotest
  class Fail < Exception
  end

  class RaiseAssert
    def initialize(&blk)
      @blk = blk
    end

    def to_test_proc
      @blk
    end
  end

  class Fixture
    def initialize(fail_message,fxtdata)
      @fxtdata=fxtdata
      @fail_message=fail_message
    end

    def test(m)
      @fxtdata.each do |i,o|
        raise Picotest::Fail,'Test fail: '+@fail_message unless o.to_test_proc.call(m,*i)
      end
    end
  end
  class << self
    def fixt(*args)
      if args.size==1
        Fixture.new("",args.first)
      else
        Fixture.new(args.first,args.last)
      end
    end

    def _not_raise
      RaiseAssert.new {|m,*i|
        begin
          m.call(*i)
          true
        rescue
          false
        end
      }
    end

    def _raise(expected, expected_message = nil)
      RaiseAssert.new {|m,*i|
        begin
          m.call(*i)
          false
        rescue expected => e
          if expected_message
            e.message == expected_message
          else
            true
          end
        end
      }
    end
  end
end
