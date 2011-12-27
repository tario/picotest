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
    def initialize(fxtdata)
      @fxtdata=fxtdata
    end

    def test(m)
      @fxtdata.each do |i,o|
        raise Picotest::Fail,"Test fail: always fails" unless o.to_test_proc.call(m,*i)
      end
    end
  end
  class << self
    def fixt(*args)
      fxtdata = args[1]
      Fixture.new(fxtdata)
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
