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
class Undo
  def initialize(*data,&blk)
    @blk = blk
    @data = data
  end

  def undo
    @blk.call(*@data)
  end
end

class Method
  def mock(options = {})
    lambda{|*x|
      undo = Array.new

      begin

        options.each do |k,v|
          case k.to_s
            when /^\@/
              undo << Undo.new(receiver.instance_variable_get(k)) {|x| receiver.instance_variable_set(k,x) } 
              receiver.instance_variable_set(k,v)
            when /^\$/
              undo << Undo.new(eval(k.to_s)) {|x| eval("#{k.to_s} = x") } 
              eval("#{k.to_s} = v")
            else
              undo << Undo.new {
                eval "
                  class << receiver
                    remove_method :#{k}
                  end
                "
              }

              if v.respond_to? :call
                receiver.define_singleton_method(k) do |*x|
                  v.call(*x)
                end
              else
                receiver.define_singleton_method(k) do |*x|
                  v
                end
              end
          end
        end

        call(*x)

      ensure
        undo.each &:undo
      end
    }
  end
end

class Class
  def new_mock(options = {})
    mock(self,options)
  end
end

def mock(*args)
  options = args.select{|x| Hash === x }.inject{|x,y| x.merge(y) } || {}
  klass = args.find{|x| Class === x} || Object
  o = klass.new
  options.each do |k,v|
    case k.to_s
      when /^\@/
        o.instance_variable_set(k,v)
      else
        if v.respond_to? :call
          o.define_singleton_method(k) do |*x|
            v.call(*x)
          end
        else
          o.define_singleton_method(k) do |*x|
            v
          end
        end
    end
  end

  o
end

