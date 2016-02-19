# coding: utf-8
require "fn/version"

module Fn
  module_function

  # coding: utf-8
  module Callable
    def to_proc
      method(:call).to_proc
    end
  end

  module Composable
    # Functional composition, f · g
    def comp(g)
      Fn { |*a, &b|
        call(g.call(*a, &b))
      }
    end
    alias * comp
    alias + comp

    def pipe(g)
      Fn { |*a, &b|
        g.call(call(*a, &b))
      }
    end
    alias | pipe

    # Bind (partially apply) parameters from the left
    def lapply(*l)
      Fn { |r, &b|
        call(*l, *r, &b)
      }
    end
    alias << lapply

    # Bind (partially apply) parameters from the right
    def rapply(*r)
      Fn { |*l, &b|
        call(*l, *r, &b)
      }
    end
    alias >> rapply
  end

  class Fn
    include Callable
    include Composable

    def initialize(&body)
      @body = body
    end

    def call(*args, &blk)
      @body.call(*args, &blk)
    end
  end

  # class Maybe
  #   def initialize(val)
  #     @val = val
  #   end

  #   def bind(g)
  #     if @val
  #       Fn { |*args, &blk|  }
  #     end
  #   end

  #   def then(resolve, _reject = nil)
  #     resolve.call(@val)
  #   end
  # end

  # class Nothing
  #   def self.then(_resolve, reject = nil)
  #     reject.call
  #   end
  # end

  # Function pseudo-constructor
  #
  # Like Symbol#to_proc
  #
  #     Fn(:upcase).call('xxx') #=> 'XXX'
  #
  # But the resulting Fn can take extra args besides `self`
  #
  #     Fn(:ljust).call('xxx', 5) #=> '  XXX'
  #
  # Can be used to coerce/convert an existing Proc (compare Integer(), Array())
  #
  #    Fn(->{ |x| x.length }).call('xxx') #=> 3
  #
  # Or called with a block directly
  #
  #    Fn { |x| x.length }.call('xxx') #=> 3
  #
  def Fn(prc = nil, *rargs, &blk)
    if Symbol === prc
      Fn { |*args| args.first.send(prc, *rargs, *args.drop(1)) }
    else
      Fn.new(&(prc || blk))
    end
  end
  alias fn Fn

  # I = fn { |x| x }

  # def maybe(*fns)
  #   if fns.empty?
  #     I
  #   else
  #     fn { |arg, &blk|
  #       if arg.nil?
  #         nil
  #       else
  #         maybe(*fns.drop(1)).call(fns.first.(arg, &blk))
  #       end
  #     }
  #   end
  # end

  # # Juxtapose, put function applications side by side
  # juxt = fn { |*fns|
  #   fn { |*args|
  #     fns.map(&fn(:call).rapply(*args))
  #   }
  # }


  # map_hsh = fn { |hsh, blk| hsh.map(&blk).to_h }

  # map_values = fn { |hsh, blk|
  #   map_hsh.(
  #     hsh,
  #     juxt.(
  #       fn(:first),
  #       blk * fn(:last)
  #     )
  #   )
  # }

  # map_keys = fn { |hsh, blk|
  #   map_hsh.(
  #     hsh,
  #     juxt.(
  #       blk * fn(:first),
  #       fn(:last)
  #     )
  #   )
  # }

  # symbolize_keys = map_keys >> fn(:to_sym) # bind the right arg, i.e. the function to map with
  # stringize_keys = map_keys >> fn(:to_s)

end
