require 'ratex'
include Ratex

puts calc{ f(x, y) == x * y }
puts calc{ f(x, y, t) == 2 * sin(pi / 4 * sqrt(x ** 2 + y ** 2) - pi / 2 * t) }
puts calc{ n! == n * fact(n - 1) }
puts calc{ f[n] == f[n - 2] + f[n - 1] }
puts calc{ e ** (i * theta) == cos(theta) + i * sin(theta) }
puts calc{ f(x, y) == sum(i == -1, h, a_i(x, y) * g_i(x, y)) }