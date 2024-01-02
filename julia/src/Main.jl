# Main.jl
#
# Copyright (C) 2021 Sharaz Ali
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.


include("./Knapsacks.jl")
include("./GeneticAlgorithm.jl")

using Statistics: mean, maximum, minimum

using .Knapsacks
using .GeneticAlgorithm

function main()

    n_individuals::Int64 = 20 # Number of individuals.
    n_generations::Int64 = 1000 # Number of generations.
    crossover_rate::Float64 = 0.85 # Crossover rate.
    mutation_rate::Float64 = 0.03 # Mutation rate.
    elitism_rate::Float64 = 0.05 # Elitism rate.

    n_datasets::Int64 = 15 # Knapsack datasets from 1 to 15.
    n_runs::Int64 = 30 # Number of times each dataset is evaluated.

    # Run genetic algorithm.
    for i in 1:n_datasets
        k::Knapsack = Knapsack(i)
        best::Vector{Float64} = Vector{Float64}(undef, n_runs)
        ga::GA = GA(k, n_individuals, n_generations, crossover_rate,
        mutation_rate, elitism_rate)
        for j in 1:n_runs
            b = start(ga)
            best[j] = b.fitness
        end
        println("Dataset ", i, ", Optimum: ", k.optimum, ", Mean: ", mean(best), 
            ", Best: ", maximum(best), ", Worst: ", minimum(best))
    end
end

# Run and time the main function.
@time begin
    main()
end

