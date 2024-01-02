# GeneticAlgorithm.jl
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


module GeneticAlgorithm

using Random: bitrand, rand

using ..Knapsacks

export Individual, GA, start


mutable struct Individual
    genes::BitVector
    fitness::Float64
end


struct GA
    knapsack::Knapsack
    n_individuals::Int64
    n_genes::Int64
    n_generations::Int64
    crossover_rate::Float64
    mutation_rate::Float64
    elitism_rate::Float64


    function GA(knapsack::Knapsack, n_individuals::Int64,
        n_generations::Int64, crossover_rate::Float64,
        mutation_rate::Float64, elitism_rate::Float64)

        n_genes::Int64 = length(knapsack.weights)
        
        return new(knapsack, n_individuals, n_genes, n_generations,
        crossover_rate, mutation_rate, elitism_rate)
    end
end


function generate_individual(self::GA)::Individual
    c::BitVector = bitrand(self.n_genes)
    f::Float64 = objective(self.knapsack, c)
    return Individual(c, f)
end


function generate_population(self::GA)::Vector{Individual}
    p::Vector{Individual} = Vector{Individual}(undef, self.n_individuals)
    tf::Float64 = 0
    for i in 1:self.n_individuals
        ind::Individual = generate_individual(self)
        tf += ind.fitness
        p[i] = ind
    end
    # Sort individuals according to their fitness (descending order).
    sort!(p, by = ind -> ind.fitness, rev = true)
    return p
end


function roulette_selection(self::GA, p::Vector{Individual})::Vector{Individual}
    skip::Int64 = -1
    selected::Vector{Individual} = Vector{Individual}(undef, 2)
    for i in 1:2
        tf::Float64 = 0
        for j in 1:self.n_individuals
            if j == skip
                continue
            end
            tf += p[j].fitness
        end
        r::Float64 = rand()
        cf::Float64 = 0
        for j in 1:self.n_individuals
            if j == skip
                continue
            end
            if tf == 0
                # To prevent dividing by zero, increment by equal parts.
                cf += 1 / (length(p) - i - 1)
            else
                cf += p[j].fitness / tf
            end
            if r < cf
                selected[i] = deepcopy(p[j])
                skip = j
                break
            end
        end
    end
    return selected
end


function single_point_crossover!(self::GA, selected::Vector{Individual})
    crossover_point::Int64 = rand(1:self.n_genes - 1)
    for i in 1:crossover_point
        temp::Bool = selected[1].genes[i]
        selected[1].genes[i] = selected[2].genes[i]
        selected[2].genes[i] = temp
    end
end


function recombination(self::GA, p::Vector{Individual})::Vector{Individual}
    # Shift all fitness values by worst fitness.
    worst::Float64 = last(p).fitness
    for ind in p
        ind.fitness -= worst
    end

    new_p::Vector{Individual} = Vector{Individual}(undef, self.n_individuals)

    for i in 1:2:self.n_individuals
        selected::Vector{Individual} = roulette_selection(self, p)
        r = rand()
        if r < self.crossover_rate
            single_point_crossover!(self, selected)
        end
        for j in 1:2
            # In case of odd number of individuals, ignore the last selected.
            if self.n_individuals % 2 == 1 && i == self.n_individuals && j == 2
                break
            end
            new_p[i + j - 1] = selected[j]
        end
    end
    return new_p
end


function mutation!(self::GA, p::Vector{Individual})
    for i in 1:self.n_individuals
        for j in 1:self.n_genes
            r = rand()
            if r < self.mutation_rate
                # In case of mutation, flip the gene.
                p[i].genes[j] = !p[i].genes[j]
            end
        end
    end
end


function update_fitness!(self::GA, p::Vector{Individual})
    for i in 1:self.n_individuals
        p[i].fitness = objective(self.knapsack, p[i].genes)
    end
    # Sort individuals according to their fitness (descending order).
    sort!(p, by = ind -> ind.fitness, rev = true)
end


function elitism!(self::GA, p::Vector{Individual}, new_p::Vector{Individual})
    n_elites = ceil(Int64, self.n_individuals * self.elitism_rate)
    for i in n_elites + 1:self.n_individuals
        p[i] = new_p[i - n_elites]
    end
end


function start(self::GA)
    # Initialize population.
    p::Vector{Individual} = generate_population(self)
    for i in 1:self.n_generations
        # Recombination.
        new_p::Vector{Individual} = recombination(self, p)
        # Mutation.
        mutation!(self, new_p)
        # Update fitness.
        update_fitness!(self, new_p)
        # Elitism.
        elitism!(self, p, new_p)
        # Update fitness.
        update_fitness!(self, p)
    end
    return first(p)
end

end