/*
 * main.go
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

package main

import (
	"fmt"
	"math/rand"
	"time"
)

func meanBestWorst(x []float64) (float64, float64, float64) {
	var total float64 = 0
	var best float64 = x[0]
	var worst float64 = x[len(x)-1]
	for i := 0; i < len(x); i++ {
		total += x[i]
		if best < x[i] {
			best = x[i]
		}
		if worst > x[i] {
			worst = x[i]
		}
	}
	return total / float64(len(x)), best, worst
}

func main() {
	// Start time count.
	start := time.Now()

	// Set random seed.
	rand.Seed(time.Now().UnixNano())

	var nIndividuals int = 20
	var nGenerations int = 1000
	var crossoverRate float64 = 0.85
	var mutationRate float64 = 0.03
	var elitismRate float64 = 0.05

	var nDatasets int = 15
	var nRuns int = 30

	for i := 1; i < nDatasets+1; i++ {
		var knapsack Knapsack = GetKnapsack(i)
		var nGenes int = len(knapsack.weights)

		var ga GA = GA{knapsack, nIndividuals, nGenes, nGenerations,
			crossoverRate, mutationRate, elitismRate}

		var results []float64 = make([]float64, nRuns)

		for j := 0; j < nRuns; j++ {
			var b Individual = ga.Run()
			results[j] = b.fitness
		}
		var mean, best, worst = meanBestWorst(results)
		fmt.Println("Dataset:", i, "Optimum:", knapsack.optimum,
			"Mean:", mean, "Best:", best, "Worst:", worst)
	}

	// Calculate elapsed time for the program.
	elapsed := time.Since(start)
	fmt.Printf("This took %s\n", elapsed)
}
