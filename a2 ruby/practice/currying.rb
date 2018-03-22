add = -> (a, b) { a + b }
plus_two = add.curry[2]
plus_two[4] # => 6
plus_two[5] # => 7