/*
 * ga.cpp
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


#include "ga.h"

int random_binary() {
    return dis_int(gen);
}

int random_int(int minimum, int maximum) {
    uniform_int_distribution<> dis(minimum, maximum);
    return dis(gen);
}

double random_double() {
    return dis_real(gen);
}

Individual::Individual() {
    // Needed because vector<Individual> would not initialize otherwise.
}

Individual::Individual(const vector<int> &g, const double &f) {
    genes = g;
    fitness = f;
}

bool Individual::operator<(const Individual &other) const {
    return fitness > other.fitness;
}

GA::GA(Knapsack &k, int n_inds, int n_gens, double cr, double mr, double er) {
    knapsack = k;
    n_individuals = n_inds;
    n_genes = k.weights.size();
    n_generations = n_gens;
    crossover_rate = cr;
    mutation_rate = mr;
    elitism_rate = er;
}

Individual GA::generate_individual() const {
    vector<int> g(n_genes);
    for (int i = 0; i < n_genes; i++) {
        g[i] = random_binary();
    }
    return Individual(g, knapsack.objective(g));
}

vector<Individual> GA::generate_population() const {
    vector<Individual> p(n_individuals);
    for (int i = 0; i < n_individuals; i++) {
        Individual ind = generate_individual();
        p[i] = ind;
    }
    sort(p.begin(), p.end());
    return p;
}

vector<Individual> GA::roulette_selection(const vector<Individual> &p) const {
    int skip = -1;
    vector<Individual> selected(2);
    for (int i = 0; i < 2; i++) {
        double tf = 0;
        for (int j = 0; j < n_individuals; j++) {
            if (j == skip) continue;
            tf += p[j].fitness;
        }
        double cf = 0;
        double r = random_double();
        for (int j = 0; j < n_individuals; j++) {
            if (j == skip) continue;
            if (tf == 0) {
                cf += 1.0 / (p.size() - i);
            } else {
                cf += p[j].fitness / tf;
            }
            if (r < cf) {
                skip = j;
                selected[i] = p[j];
                break;
            }
        }
    }

    return selected;
}

void GA::single_point_crossover(vector<Individual> &s) {
    int crossover_point = random_int(1, n_genes - 1);
    for (int i = 0; i < crossover_point; i++) {
        int temp = s[0].genes[i];
        s[0].genes[i] = s[1].genes[i];
        s[1].genes[i] = temp;
    }
}

vector<Individual> GA::recombination(vector<Individual> &p) {
    double worst = p[n_individuals - 1].fitness;
    for (int i = 0; i < n_individuals; i++) {
        p[i].fitness -= worst;
    }
    vector<Individual> new_p(n_individuals);
    for (int i = 0; i < n_individuals; i += 2) {
        vector<Individual> selected = roulette_selection(p);
        double r = random_double();
        if (r < crossover_rate) {
            single_point_crossover(selected);
        }
        for (int j = 0; j < 2; j++) {
            if (n_individuals % 2 == 1 && i == n_individuals - 1 && j == 1) {
                break;
            }
            new_p[i + j] = selected[j];
        }
    }
    return new_p;
}

void GA::mutation(vector<Individual> &p) {
    for (int i = 0; i < n_individuals; i++) {
        for (int j = 0; j < n_genes; j++) {
            double r = random_double();
            if (r < mutation_rate) {
                if (p[i].genes[j] == 0) {
                    p[i].genes[j] = 1;
                } else {
                    p[i].genes[j] = 0;
                }
            }
        }
    }
}

void GA::elitism(vector<Individual> &p, vector<Individual> &new_p) {
    int n_elites = ceil(elitism_rate * n_individuals);
    for (int i = n_elites; i < n_individuals; i++) {
        p[i] = new_p[i - n_elites];
    }
}

void GA::update_fitness(vector<Individual> &p) {
    for (int i = 0; i < n_individuals; i++) {
        p[i].fitness = knapsack.objective(p[i].genes);
    }
    sort(p.begin(), p.end());
}

Individual GA::run() {
    vector<Individual> p = generate_population();
    for (int i = 1; i < n_generations + 1; i++) {
        vector<Individual> new_p = recombination(p);
        mutation(new_p);
        update_fitness(new_p);
        elitism(p, new_p);
        update_fitness(p);
    }
    return p[0];
}

