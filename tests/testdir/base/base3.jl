# Generate a random array of 1000 normally distributed numbers
data = randn(1000)

# Calculate the mean and standard deviation
mean_value = mean(data)
std_dev = std(data)

# Create a histogram of the data
histogram(data, bins=20, label="Random Data")

# Fit a normal distribution to the data
x = range(-4, 4, length=100)
y = pdf.(Normal(mean_value, std_dev), x)
plot!(x, y, label="Normal Fit")

# Create a DataFrame
df = DataFrame(
    A = 1:10,
    B = rand(10),
    C = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
)

# Sort the DataFrame by column B
sort!(df, :B)

# Group the DataFrame by column C and calculate the mean of column A for each group
grouped_df = groupby(df, :C)
means = combine(grouped_df, :A => mean)

# Print the grouped DataFrame
println(means)
