/*
 * main.cpp
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


#include <iostream>
#include <vector>
#include <stdlib.h>
#include <time.h>
#include <chrono>
#include "knapsack.h"
#include "ga.h"

using namespace std;

vector<double> mean_best_worst(const vector<double> &x) {
    int size = x.size();
    double total = 0;
    double best = x[0];
    double worst = x[size - 1];
    for (int i = 0; i < size; i++) {
        total += x[i];
        if (best < x[i]) {
            best = x[i];
        }
        if (worst > x[i]) {
            worst = x[i];
        }
    }
    return {total / size, best, worst};
}

int main() {
    chrono::steady_clock::time_point begin = chrono::steady_clock::now();

    int n_individuals = 20;
    int n_generations = 1000;
    double crossover_rate = 0.85;
    double mutation_rate = 0.03;
    double elitism_rate = 0.05;

    int n_datasets = 15;
    int n_runs = 30;

    for (int i = 1; i < n_datasets + 1; i++) {
        Knapsack k(i);
        GA ga(k, n_individuals, n_generations, crossover_rate, mutation_rate, elitism_rate);
        vector<double> best(n_runs);
        for (int j = 0; j < n_runs; j++) {
            Individual b = ga.run();
            best[j] = b.fitness;
        }
        vector<double> results = mean_best_worst(best);
        cout << "Dataset: " << i << " Optimum: " << k.optimum << " Mean: " <<
        results[0] << " Best: " << results[1] << " Worst: " << results[2] << endl;
    }

    chrono::steady_clock::time_point end = chrono::steady_clock::now();
    cout << "This took " << 
    chrono::duration_cast<chrono::microseconds>(end - begin).count() / 1000000.0 << 
    "s" << std::endl;

    return 0;
}