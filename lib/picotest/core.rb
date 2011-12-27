module Picotest
  class Fixture
    def test(m)
    end
  end
  class << self
    def fixt(*args)
      Fixture.new
    end
  end
end
