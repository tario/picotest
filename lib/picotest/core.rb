=begin

This file is part of the picotest project, http://github.com/tario/picotest

Copyright (c) 2012 Roberto Dario Seminara <robertodarioseminara@gmail.com>

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
    Picotest::ConstantTestProc.new(self)
  end

  def to_input_set
    Picotest::InputSet.new([self])
  end
end

class Proc
  def to_test_proc
    Picotest::ProcTestProc.new(self)
  end
end

module Picotest
  class ProcTestProc
    attr_accessor :expectation_text

    def initialize(inner_proc)
      @inner_proc = inner_proc
      @expectation_text = ""
    end

    def call(m,*i)
      o = m.call(*i)

      if i.size+1 == @inner_proc.arity
        @inner_proc.call(o,*i)
      elsif @inner_proc.arity == 1
        @inner_proc.call(o)
      else
        raise RuntimeError, "wrong arity for lambda"
      end
    end
  end

  class ConstantTestProc
    def initialize(const)
      @const = const
    end

    def call(m,*i)
      @const == m.call(*i)
    end

    def expectation_text
      @const.inspect
    end
  end

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
    attr_reader :expectation_text    
    def initialize(ext,&blk)
      @blk = blk
      @expectation_text = ext
    end

    def to_test_proc
      self
    end

    def call(*x)
      @blk.call(*x)
    end
  end

  class Suite
    def initialize(fail_message,fxtdata,position)
      @fxtdata=fxtdata
      @fail_message=fail_message
      @position = position

      @report = ENV["PICOTEST_REPORT"] == "1" ? true : false
      @raise_fail = @report ? false : true
      @run = ENV["PICOTEST_RUN"] == "1" ? true : false
      @emulate_fail = ENV["PICOTEST_FAIL"] == "1" ? true : false
    end

    def test(m)
      return unless @run

      if m.instance_of? Method
        if m.owner == Picotest::Suite
          m.receiver.instance_eval{@raise_fail = true}
          m.receiver.instance_eval{@emulate_fail = false}
        end
      end
      m = m.to_proc

      test_fail = false

      @fxtdata.each do |k,o|
        if k.respond_to? :to_proc
          oracle = k.to_proc
          o.to_input_set.each do|_exp_o|
            i = oracle.call(_exp_o)
            _o = m.call(*i)
            if not _o == _exp_o or @emulate_fail
              test_fail = true

              if @raise_fail
              raise Picotest::Fail,'Test fail: '+@fail_message
              else

              location = if m.respond_to?(:source_location)
                m.source_location
              end

              print "fail #{@fail_message}. Expected output:#{_exp_o} , received:#{_o}
  suite at #{@position}
  test at #{caller[0]}
  #{location ? "method location at "+location.join(":") : "" }
"
              end
            end 
          end
        else
          k.to_input_set.each do|i|
            test_proc = o.to_test_proc
            if not test_proc.call(m,*i) or @emulate_fail
              test_fail = true

              if @raise_fail
              raise Picotest::Fail,'Test fail: '+@fail_message
              else

              location = if m.respond_to?(:source_location)
                m.source_location
              end

              print "fail #{@fail_message}. Input: #{i.inspect}, Expected: #{test_proc.expectation_text}
  suite at #{@position}
  test at #{caller[0]}
  #{location ? "method location at "+location.join(":") : "" }

"
              end
            end
          end
        end
      end

      unless test_fail
        print "Test sucessfull at #{caller[0]}\n" if @report
      end

    end
  end

  module GlobalMethods
    def suite(*args)
      if args.size==1
        Suite.new("",args.first,caller[0])
      else
        Suite.new(args.first,args.last,caller[0])
      end
    end

    def _set(*args)
      InputSet.new(args)
    end

    def _not_raise
      RaiseAssert.new("not raise exception") {|m,*i|
        begin
          m.call(*i)
          true
        rescue
          false
        end
      }
    end

    def _raise(expected, expected_message = nil)
      RaiseAssert.new("raise #{expected}") {|m,*i|
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

class Object
  include Picotest::GlobalMethods
end

