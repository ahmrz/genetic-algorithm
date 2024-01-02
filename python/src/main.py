# main.py
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


from time import time
from knapsack import Knapsack, get_knapsack
from ga import Individual, GA


def mean_best_worst(results: list[float]) -> tuple[float]:
    total: float = 0
    best: float = results[0]
    worst: float = results[0]
    for r in results:
        total += r
        if best < r:
            best = r
        if worst > r:
            worst = r
    return total / len(results), best, worst


def main():
    n_individuals: int = 20
    n_generations: int = 1000
    crossover_rate: float = 0.85
    mutation_rate: float = 0.03
    elitism_rate: float = 0.05

    n_datasets: int = 15
    n_runs: int = 30

    for i in range(1, n_datasets + 1):
        k: Knapsack = get_knapsack(i)
        ga: GA = GA(k, n_individuals, n_generations, crossover_rate, mutation_rate, elitism_rate)
        results: list[float] = [0] * n_runs
        for j in range(n_runs):
            b: Individual = ga.run()
            results[j] = b.fitness
        mean, best, worst = mean_best_worst(results)
        print('Dataset:', i, 'Optimum:', k.optimum, 'Mean:', mean, 'Best:', best, 'Worst:', worst)


# Run main function.
start: float = time()
main()
end: float = time()
print('This took', end - start, 's')