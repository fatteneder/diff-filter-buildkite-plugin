# Generate a random matrix of size 5x5
random_matrix = rand(5, 5)

# Calculate the eigenvalues and eigenvectors
eigenvalues, eigenvectors = eig(random_matrix)

# Print the eigenvalues
println("Eigenvalues:")
println(eigenvalues)

# Print the eigenvectors
println("Eigenvectors:")
println(eigenvectors)

# Define a function to calculate the factorial recursively
function factorial(n)
    if n == 0
        return 1
    else
        return n * factorial(n - 1)
    end
end

# Calculate the factorial of 10
result = factorial(10)

# Print the result
println("Factorial of 10 is $result")

# Create a plot of a sine and cosine function
using Plots
x = 0:0.1:2π
y1 = sin.(x)
y2 = cos.(x)
plot(x, y1, label="sin(x)")
plot!(x, y2, label="cos(x)")
