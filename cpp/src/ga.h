/*
 * ga.h
 *
 * Copyright (C) 2021 Sharaz Ali
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#ifndef GA_H
#define GA_H

#include <iostream>
#include <vector>
#include <random>
#include <algorithm>
#include <math.h>
#include "knapsack.h"

using namespace std;

// Random number generator.
static random_device rd;
static mt19937 gen(rd());
static uniform_int_distribution<> dis_int(0, 1);
static uniform_real_distribution<> dis_real(0.0, 1.0);
int random_binary();
int random_int(int minimum, int maximum);
double random_double();


class Individual {

public:
    vector<int> genes;
    double fitness;
    
    Individual();
    Individual(const vector<int> &g, const double &f);
    bool operator<(const Individual &other) const;
};

class GA {

private:
    Individual generate_individual() const;
    vector<Individual> generate_population() const;
    vector<Individual> roulette_selection(const vector<Individual> &p) const;
    void single_point_crossover(vector<Individual> &s);
    vector<Individual> recombination(vector<Individual> &p);
    void mutation(vector<Individual> &p);
    void elitism(vector<Individual> &p, vector<Individual> &new_p);
    void update_fitness(vector<Individual> &p);

public:
    Knapsack knapsack;
    int n_individuals;
    int n_genes;
    int n_generations;
    double crossover_rate;
    double mutation_rate;
    double elitism_rate;

    GA(Knapsack &k, int n_inds, int n_gens, double cr, double mr, double er);
    Individual run();
};

#endif