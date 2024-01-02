# ga.py
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


from random import random, randrange
from copy import deepcopy
from math import ceil
from knapsack import Knapsack


class Individual:

    def __init__(self, genes: list[bool], fitness: float) -> None:
        self.genes: list[bool] = genes
        self.fitness: float = fitness
    
    def __str__(self) -> str:
        s: str = ''
        for g in self.genes:
            s += str(int(g))
        return s + ' F: ' + str(self.fitness)

class GA:

    def __init__(self, k: Knapsack, n_individuals: int, n_generations: int, 
    crossover_rate: float, mutation_rate:float, elitism_rate: float) -> None:
        self.knapsack: Knapsack = k
        self.n_individuals: int = n_individuals
        self.n_genes: int = len(k.weights)
        self.n_generations: int = n_generations
        self.crossover_rate: float = crossover_rate
        self.mutation_rate: float = mutation_rate
        self.elitism_rate: float = elitism_rate


    def generate_individual(self) -> Individual:
        genes: list[bool] = [0] * self.n_genes
        fitness: float = 0
        for i in range(self.n_genes):
            genes[i] = random() < 0.5
        fitness = self.knapsack.objective(genes)
        return Individual(genes, fitness)


    def generate_population(self) -> list[Individual]:
        p: list[Individual] = [None] * self.n_individuals
        for i in range(self.n_individuals):
            p[i] = self.generate_individual()
        p.sort(key=lambda ind: ind.fitness, reverse=True)
        return p


    def roulette_selection(self, p: list[Individual]) -> list[Individual]:
        skip: int = -1
        selected: list[Individual] = [None] * 2
        for i in range(2):
            tf: float = 0
            for j in range(self.n_individuals):
                if j == skip: continue
                tf += p[j].fitness
            r: float = random()
            cf: float = 0
            for j in range(self.n_individuals):
                if j == skip: continue
                if tf == 0:
                    cf += 1 / (len(p) - i)
                else:
                    cf += p[j].fitness / tf
                if r < cf:
                    skip = j
                    selected[i] = deepcopy(p[j])
                    break
        return selected


    def single_point_crossover(self, s: list[Individual]):
        crossover_point = randrange(1, self.n_genes)
        for i in range(crossover_point):
            s[0].genes[i], s[1].genes[i] = s[1].genes[i], s[0].genes[i]


    def recombination(self, p: list[Individual]) -> list[Individual]:
        # Shift fitness by worst value.
        worst: float = p[-1].fitness
        for i in range(self.n_individuals):
            p[i].fitness -= worst

        new_p: list[Individual] = [None] * self.n_individuals

        for i in range(0, self.n_individuals, 2):
            selected: list[Individual] = self.roulette_selection(p)
            r: float = random()
            if r < self.crossover_rate:
                self.single_point_crossover(selected)
            for j in range(2):
                if self.n_individuals % 2 == 1 and i == self.n_individuals - 1 and j == 1: break
                new_p[i + j] = selected[j]
        return new_p


    def mutation(self, p: list[Individual]):
        for i in range(self.n_individuals):
            for j in range(self.n_genes):
                r: float = random()
                if r < self.mutation_rate:
                    p[i].genes[j] = not p[i].genes[j]


    def elitism(self, p: list[Individual], new_p: list[Individual]):
        n_elites: int = ceil(self.elitism_rate * self.n_individuals)
        for i in range(n_elites, self.n_individuals):
            p[i] = new_p[i - n_elites]


    def update_fitness(self, p: list[Individual]):
        for i in range(self.n_individuals):
            p[i].fitness = self.knapsack.objective(p[i].genes)
        p.sort(key=lambda ind: ind.fitness, reverse=True)


    def run(self) -> Individual:
        # Generate population.
        p: list[Individual] = self.generate_population()
        for i in range(1, self.n_generations + 1):
            # Recombination.
            new_p: list[Individual] = self.recombination(p)
            # Mutation.
            self.mutation(new_p)
            # Update fitness.
            self.update_fitness(new_p)
            # Elitism.
            self.elitism(p, new_p)
            # Update fitness.
            self.update_fitness(p)
        # Return best individual.
        return p[0]

