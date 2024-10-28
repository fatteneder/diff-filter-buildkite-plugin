using DifferentialEquations, Plots

# Define a simple ODE
function lorenz!(du,u,p,t)
    du[1] = 10.0*(u[2]-u[1])
    du[2] = u[1]*(28.0-u[3))-u[2]
    du[3] = u[1]*u[2] - (8/3)*u[3]
end

# Set initial conditions
u0 = [1.0, 1.0, 1.0]
tspan = (0.0, 100.0)

# Solve the ODE
prob = ODEProblem(lorenz!,u0,tspan)
sol = solve(prob,Tsit5())

# Plot the solution
plot(sol, vars=(1,2,3), title="Lorenz Attractor")
