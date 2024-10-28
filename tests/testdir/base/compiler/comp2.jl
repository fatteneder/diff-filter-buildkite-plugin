using DataFrames, Plots
# Generate random data with some outliers
data = randn(1000)
append!(data, randn(100) .+ 5)

# Create a box plot to visualize the distribution
boxplot(data, label="Data with Outliers")

# Calculate robust statistics (median and interquartile range)
median(data)
quantile(data, [0.25, 0.75])
