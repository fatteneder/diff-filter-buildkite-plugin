# Generate a random integer between 1 and 100
random_number = rand(1:100)

# Create a function to calculate factorial
function factorial(n)
    if n == 0
        return 1
    else
        return n * factorial(n - 1)
    end
end

# Calculate the factorial of the random number
result = factorial(random_number)

# Print the result
println("Factorial of $random_number is $result")

# Create a matrix
matrix = rand(3, 3)

# Print the matrix
println(matrix)

# Calculate the determinant of the matrix
det = det(matrix)

# Print the determinant
println("Determinant of the matrix is $det")
