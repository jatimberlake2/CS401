if ARGV.length == 0
    put "Usage ./#{$0} arg1 arg2 .... argn"
    Process.exit(1)
end

count = 0
ARGV.each do [arg]
    puts "Arg #{count}: #{arg}"
    count += 1
end

puts "Alternatively"
count = 0
for arg in ARGV
    puts "Arg #{count}: #{arg}"
    count += 1
end