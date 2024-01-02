clc;
clear;

% Start timer.
st = cputime;

knapsack.optimum = 295;
knapsack.capacity = 269;
knapsack.weights = [95, 4, 60, 32, 23, 72, 80, 62, 65, 46];
knapsack.values = [55, 10, 47, 5, 4, 50, 8, 61, 85, 87];

n_individuals = 4;
n_generations = 1000;
crossover_rate = 0.5;
mutation_rate = 0.03;
elitism_rate = 0.05;

n_datasets = 15;
n_runs = 30;

for i = 1 : n_datasets
	knapsack = knapsack_datasets(i);
	results = [];
	for j = 1 : n_runs
		best = GA(knapsack, n_individuals, n_generations, crossover_rate, mutation_rate, elitism_rate);
		results(j) = best.fitness;
	end
	disp(['Dataset: ', num2str(i), ' Optimum: ', num2str(knapsack.optimum), ' Mean: ', num2str(mean(results)), ' Best: ', num2str(max(results)), ' Worst: ', num2str(min(results))]);
end

% End timer.
ed = cputime;
timep = ed - st;
disp(['Time taken: ', num2str(timep), ' s']);
