# Generate a random string of length 10
random_string = randstring(10)

# Create a dictionary to store information about a person
person = Dict{String, Any}(
    "name" => "Alice",
    "age" => 30,
    "city" => "New York"
)

# Add a new key-value pair to the dictionary
person["hobby"] = "reading"

# Print the dictionary
println(person)

# Define a function to calculate the Fibonacci sequence
function fibonacci(n)
    if n <= 1
        return n
    else
        return fibonacci(n-1) + fibonacci(n-2)
    end
end

# Calculate the 10th Fibonacci number
fib10 = fibonacci(10)

# Print the result
println("The 10th Fibonacci number is $fib10")

# Create a plot of a sine function
using Plots
x = 0:0.1:2π
y = sin.(x)
plot(x, y, label="sin(x)")
