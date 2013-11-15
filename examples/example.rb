require 'ratex'
include Ratex

puts generate{ V == R * I }
puts generate{ f(x, y) == x * y }
puts generate{ f(x, y, t) == 2 * sin(pi / 4 * sqrt(x ** 2 + y ** 2) - pi / 2 * t) }
puts generate{ n! == n * fact(n - 1) }
puts generate{ f[n] == f[n - 2] + f[n - 1] }
puts generate{ e ** (i * theta) == cos(theta) + i * sin(theta) }
puts generate{ F(x, y) == sum(i == -1, h, A_i(x, y) * G_i(x, y)) }