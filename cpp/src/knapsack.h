/*
 * knapsack.h
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


#ifndef KNAPSACK_H
#define KNAPSACK_H

#include <vector>

using namespace std;

class Knapsack {

public:
    double optimum;
    double capacity;
    vector<double> weights;
    vector<double> values;
    
    Knapsack();
    Knapsack(const int &option);
    double dot(const vector<int> &genes, const vector<double> &x) const;
    double objective(const vector<int> &genes) const;
};

#endif


