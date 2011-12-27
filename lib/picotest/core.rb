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
        raise Picotest::Fail unless o.to_test_proc.call(m,*i)
      end
    end
  end
  class << self
    def fixt(*args)
      fxtdata = args[1]
      Fixture.new(fxtdata)
    end

    def _raise(expected)
      RaiseAssert.new {|m,*i|
        begin
          m.call(*i)
          false
        rescue expected
          true
        end
      }
    end
  end
end
