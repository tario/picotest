module Picotest
  class Fail < Exception
  end

  class Fixture
    def initialize(fxtdata)
      @fxtdata=fxtdata
    end

    def test(m)
      @fxtdata.each do |i,o|
        o.call(m,*i)
      end
    end
  end
  class << self
    def fixt(*args)
      fxtdata = args[1]
      Fixture.new(fxtdata)
    end

    def _raise(expected)
      lambda{|m,*i|
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
