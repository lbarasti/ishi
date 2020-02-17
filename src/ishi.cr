# Graph plotting package with a small API powered by gnuplot.
#
# See `Base` for documentation on supported methods.
#
module Ishi
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  class Base
    # :nodoc:
    def initialize(*args)
      @gnuplot = Gnuplot.new(["set term qt persist"])
    end

    # Plots a mathematical expression.
    #
    #     plot("sin(x) * cos(x)")
    #     plot("3.5 * x + 1.5")
    #
    # For information on gnuplot mathematical expressions, see:
    # [Expressions](http://www.gnuplot.info/docs_5.2/Gnuplot_5.2.pdf#section*.27).
    #
    # *title* is the title of the plot. *style* is the drawing
    # style. Supported values include `:lines` and `:points`.
    #
    def plot(expression : String, title : String? = nil, style : Symbol? = nil)
      @gnuplot.plot(expression, title, style)
      self
    end

    # Plots `y` using `x` ranging from `0` to `N-1`.
    #
    # *title* is the title of the plot. *style* is the drawing
    # style. Supported values include `:boxes`, `:lines` and
    # `:points`.
    #
    def plot(ydata : Indexable(Y), title : String? = nil, style : Symbol = :lines) forall Y
      @gnuplot.plot(ydata, title, style)
      self
    end

    # Plots `x` and `y`.
    #
    # *title* is the title of the plot. *style* is the drawing
    # style. Supported values include `:boxes`, `:lines` and
    # `:points`.
    #
    def plot(xdata : Indexable(X), ydata : Indexable(Y), title : String? = nil, style : Symbol = :lines) forall X, Y
      @gnuplot.plot(xdata, ydata, title, style)
      self
    end

    # Plots `x`, `y` and `z`.
    #
    # *title* is the title of the plot. *style* is the drawing
    # style. Supported values include `:boxes`, `:lines` and
    # `:points`.
    #
    def plot(xdata : Indexable(X), ydata : Indexable(Y), zdata : Indexable(Z), title : String? = nil, style : Symbol = :points) forall X, Y, Z
      @gnuplot.plot(xdata, ydata, zdata, title, style)
      self
    end

    # Sets the label of the `x` axis.
    #
    def xlabel(xlabel : String)
      @gnuplot.xlabel(xlabel)
      self
    end

    # Sets the label of the `y` axis.
    #
    def ylabel(ylabel : String)
      @gnuplot.ylabel(ylabel)
      self
    end

    # Sets the label of the `z` axis.
    #
    def zlabel(zlabel : String)
      @gnuplot.zlabel(zlabel)
      self
    end

    # Sets the range of the `x` axis.
    #
    def xrange(xrange : Range(Float64, Float64) | Range(Int32, Int32))
      @gnuplot.xrange(xrange)
      self
    end

    # Sets the range of the `y` axis.
    #
    def yrange(yrange : Range(Float64, Float64) | Range(Int32, Int32))
      @gnuplot.yrange(yrange)
      self
    end

    # Sets the range of the `z` axis.
    #
    def zrange(zrange : Range(Float64, Float64) | Range(Int32, Int32))
      @gnuplot.zrange(zrange)
      self
    end

    # Shows the chart.
    #
    def show(**options)
      @gnuplot.show(**options)
    end
  end

  @@default = Base

  # Creates a new instance.
  #
  # ```
  # ishi = Ishi.new
  # ishi.plot([1, 2, 3, 4])
  # ishi.show
  # ```
  #
  def self.new(*args)
    @@default.new(*args)
  end

  # Creates a new instance.
  #
  # Yields to the supplied block with the new instance as the implicit
  # receiver. Automatically invokes `#show` before returning.  Any
  # *options* are passed to `#show`.
  #
  # ```
  # Ishi.new do
  #   plot([1, 2, 3, 4])
  # end
  # ```
  #
  def self.new(*args, **options)
    @@default.new(*args).tap do |instance|
      with instance yield
      instance.show(**options)
    end
  end
end

require "./ishi/gnuplot"