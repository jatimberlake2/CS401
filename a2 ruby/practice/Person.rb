class Person
    @@no_of_customers=0
    def initialize(name, age, gender)
        @name = name
        @age = age
        @gender = gender
        @@no_of_customers += 1
    end

    def print_info()
        puts "#{@name} is a #{@gender} of #{@age} years of age."
    end
    
end

if __FILE__ == $0
    person = Person.new("John Doe", 23, "Male")
    person.print_info
end

puts "This gets executed anyway..."