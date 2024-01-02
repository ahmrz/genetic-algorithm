% GA.m
%
% Copyright (C) 2021 Sharaz Ali
%
% This program is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with
% this program.  If not, see <http://www.gnu.org/licenses/>.


function [best] = GA(knapsack, n_individuals, n_generations, crossover_rate, mutation_rate, elitism_rate)
	n_genes = size(knapsack.weights, 2);
	population = generate_population(n_individuals, n_genes, knapsack);
%	print_population(population);
	for i = 1 : n_generations
		new_population = recombination(population, n_individuals, n_genes, crossover_rate);
%		print_population(new_population);
		new_population = mutation(new_population, n_individuals, n_genes, mutation_rate);
%		print_population(new_population);
		new_population = update_fitness(new_population, knapsack);
%		print_population(new_population);
		population = elitism(population, new_population, n_individuals, elitism_rate);
%		print_population(population);
		population = update_fitness(population, knapsack);
%		print_population(population);
%		disp(['Current Generation: ', num2str(i), ' Best: ', num2str(population(1).fitness), ' Worst: ', num2str(population(end).fitness)]);
	end
	best = population(1);
end


function [individual] = generate_individual(n_genes, knapsack)
	individual.genes = randi([0, 1], 1, n_genes);
	individual.fitness = knapsack_objective(individual.genes, knapsack);
end


function [population] = generate_population(n_individuals, n_genes, knapsack)
	for i = 1 : n_individuals
		population(i) = generate_individual(n_genes, knapsack);
	end
%	print_population(population);
	[values, order] = sort([population(:).fitness], 'descend');
	population = population(order);
end


function print_individual(individual)
	disp([num2str(individual.genes), '	F: ', num2str(individual.fitness)]);
end


function print_population(population)
	disp('--------------------------------------------------------------------------------')
	for i = 1 : size(population, 2)
		print_individual(population(i));
	end
end


function [selected] = roulette_selection(population, n_individuals)
	skip = -1;
	for i = 1 : 2
		total_fitness = 0;
		for j = 1 : n_individuals
			if j == skip
				continue;
			end
			total_fitness += population(j).fitness;
		end
		r = rand;
		cumulative_fitness = 0;
		for j = 1 : n_individuals
			if j == skip
				continue;
			end
			if total_fitness == 0
				cumulative_fitness += 1 / (n_individuals - i - 1);
			else
				cumulative_fitness += population(j).fitness / total_fitness;
			end
			if r < cumulative_fitness
				skip = j;
				selected(i) = population(j);
				break
			end
		end
	end
end


function [selected] = single_point_crossover(selected, n_genes)
	crossover_point = randi(n_genes) - 1;
	for i = 1 : crossover_point
		temp = selected(1).genes(i);
		selected(1).genes(i) = selected(2).genes(i);
		selected(2).genes(i) = temp;
	end
%	print_population(selected)
end


function [new_population] = recombination(population, n_individuals, n_genes, crossover_rate)
	worst = population(end).fitness;
	for i = 1 : n_individuals
		population(i).fitness -= worst;
	end
	
%	print_population(population)
	
	for i = 1 : 2 : n_individuals
		selected = roulette_selection(population, n_individuals);
		r = rand;
		if r < crossover_rate
			selected = single_point_crossover(selected, n_genes);
		end
%		print_population(selected);
		for j = 1 : 2
			if rem(n_individuals, 2) == 1 && i == n_individuals && j == 2
				break;
			end
			new_population(i + j - 1) = selected(j);
		end
	end
end


function [population] = mutation(population, n_individuals, n_genes, mutation_rate)
	for i = 1 : n_individuals
		for j = 1 : n_genes
			r = rand;
			if r < mutation_rate
				if population(i).genes(j) == 0
					population(i).genes(j) = 1;
				else
					population(i).genes(j) = 0;
				end
			end
		end
	end
end


function [population] = elitism(population, new_population, n_individuals, elitism_rate)
	n_elites = ceil(elitism_rate * n_individuals);
	for i = n_elites + 1 : n_individuals
		population(i) = new_population(i - n_elites);
	end
end


function population = update_fitness(population, knapsack)
	for i = 1 : size(population, 2)
		population(i).fitness = knapsack_objective(population(i).genes, knapsack);
	end
	[values, order] = sort([population(:).fitness], 'descend');
	population = population(order);
end
