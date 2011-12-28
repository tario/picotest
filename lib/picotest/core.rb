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

  def to_input_set
    Picotest::InputSet.new([self])
  end
end

class Proc
  def to_test_proc
    lambda { |m,*i|
      o = m.call(*i)

      if i.size+1 == arity
        self.call(o,*i)
      elsif arity == 1
        self.call(o)
      else
        raise RuntimeError, "wrong arity for lambda"
      end
    }
  end
end

module Picotest
  class Fail < Exception
  end

  class InputSet
    def initialize(array); @array = array; end

    def to_input_set
      self
    end

    def each(&blk)
      @array.each(&blk)
    end
  end

  class RaiseAssert
    def initialize(&blk)
      @blk = blk
    end

    def to_test_proc
      @blk
    end
  end

  class Suite
    def initialize(fail_message,fxtdata)
      @fxtdata=fxtdata
      @fail_message=fail_message

      @report = ENV["PICOTEST_REPORT"] == "1" ? true : false
      @raise_fail = @report ? false : true
      @run = ENV["PICOTEST_RUN"] == "1" ? true : false
    end

    def test(m)
      return unless @run

      if m.instance_of? Method
        if m.owner == Picotest::Suite
          m.receiver.instance_eval{@raise_fail = true}
        end
      end

      @fxtdata.each do |k,o|
        if k.respond_to? :to_proc
          oracle = k.to_proc
          o.to_input_set.each do|_exp_o|
            i = oracle.call(_exp_o)
            _o = m.call(*i)
            unless _o == _exp_o
              if @raise_fail
              raise Picotest::Fail,'Test fail: '+@fail_message
              else
              print "fail #{@fail_message}. Expected output:#{_exp_o} , received:#{_o}\n"
              end
            end 
          end
        else
          k.to_input_set.each do|i|
            unless o.to_test_proc.call(m,*i)
              if @raise_fail
              raise Picotest::Fail,'Test fail: '+@fail_message
              else
              print "fail #{@fail_message}. Input: #{i.inspect}\n"
              end
            end
          end
        end
      end
    end
  end
  class << self
    def suite(*args)
      if args.size==1
        Suite.new("",args.first)
      else
        Suite.new(args.first,args.last)
      end
    end

    def _set(*args)
      InputSet.new(args)
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
