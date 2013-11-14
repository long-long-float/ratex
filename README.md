# Ratex

You can write TeX in Ruby!

## Installation

Add this line to your application's Gemfile:

    gem 'ratex'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ratex

## Usage

```ruby
puts Ratex.calc{ f(x, y, t) == 2 * sin(pi / 4 * sqrt(x ** 2 + y ** 2) - pi / 2 * t) }
```

![enter image description here][1]

```ruby
puts calc{ f[n] == f[n - 2] + f[n - 1] }
```

![enter image description here][2]

```ruby
puts calc{ f(x, y) == sum(i == -1, h, a_i(x, y) * g_i(x, y)) }
```

![enter image description here][3]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


  [1]: fig1.png
  [2]: fig2.png
  [3]: fig3.png