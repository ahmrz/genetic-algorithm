/*
 * ga.go
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
	"math"
	"math/rand"
	"sort"
	"strings"
)

func toInt(b bool) int8 {
	if b {
		return 1
	} else {
		return 0
	}
}

type Individual struct {
	genes   []bool
	fitness float64
}

func (ind Individual) String() string {
	var sb strings.Builder
	for _, g := range ind.genes {
		sb.WriteString(fmt.Sprint(toInt(g)))
	}
	return fmt.Sprintf("%v F: %v", sb.String(), ind.fitness)
}

func (ind Individual) clone() Individual {
	var new_gs []bool = make([]bool, len(ind.genes))
	copy(new_gs, ind.genes)
	return Individual{new_gs, ind.fitness}
}

type Individuals []Individual

func (p Individuals) Len() int {
	return len(p)
}

func (p Individuals) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func (p Individuals) Less(i, j int) bool {
	return p[i].fitness > p[j].fitness
}

func (p Individuals) String() string {
	var sb strings.Builder
	for i, c := range p {
		sb.WriteString(c.String())
		if i == len(p)-1 {
			break
		}
		sb.WriteString("\n")
	}
	return fmt.Sprintf("%v", sb.String())
}

type GA struct {
	knapsack      Knapsack
	nIndividuals  int
	nGenes        int
	nGenerations  int
	crossoverRate float64
	mutationRate  float64
	elitismRate   float64
}

func (ga *GA) generateIndividual() Individual {
	var genes []bool = make([]bool, ga.nGenes)
	for i := 0; i < ga.nGenes; i++ {
		genes[i] = rand.Intn(2) == 1
	}
	return Individual{genes, ga.knapsack.Objective(genes)}
}

func (ga *GA) generatePopulation() Individuals {
	var p = make(Individuals, ga.nIndividuals)
	var tf float64 = 0
	for i := 0; i < ga.nIndividuals; i++ {
		p[i] = ga.generateIndividual()
		tf += p[i].fitness
	}
	sort.Sort(p)
	return p
}

func (ga *GA) rouletteSelection(p Individuals) (Individual, Individual) {
	var skip int = -1
	var selected = make(Individuals, 2)
	// Loop twice to select two individuals.
	for i := 0; i < 2; i++ {
		// Calculate the total fitness.
		var tf float64 = 0
		for j := range p {
			if j == skip {
				continue
			}
			tf += p[j].fitness
		}
		// Roulette wheel selection.
		var r = rand.Float64()
		var cf float64 = 0
		for j := range p {
			if j == skip {
				continue
			}
			if tf == 0 {
				cf += 1.0 / float64(len(selected)-i)
			} else {
				cf += p[j].fitness / tf
			}
			if r < cf {
				selected[i] = p[j].clone()
				skip = j
				break
			}
		}
	}
	return selected[0], selected[1]
}

func (ga *GA) singlePointCrossover(first Individual, second Individual) {
	var crossoverPoint int = rand.Intn(ga.nGenes-1) + 1
	for i := 0; i < crossoverPoint; i++ {
		first.genes[i], second.genes[i] = second.genes[i], first.genes[i]
	}
}

func (ga *GA) recombination(p Individuals) Individuals {
	// Shift fitness values by worst fitness.
	var worst float64 = p[ga.nIndividuals-1].fitness
	for i := range p {
		p[i].fitness -= worst
	}
	// Create a variable to hold the new individuals.
	var new_p = make(Individuals, ga.nIndividuals)

	for i := 0; i < ga.nIndividuals; i += 2 {
		var first, second = ga.rouletteSelection(p)
		var r float64 = rand.Float64()
		if r < ga.crossoverRate {
			ga.singlePointCrossover(first, second)
		}
		// If odd number of individuals, ignore the second selected individual.
		if ga.nIndividuals%2 == 1 && i == ga.nIndividuals-1 {
			new_p[i] = first
		} else {
			new_p[i], new_p[i+1] = first, second
		}
	}
	return new_p
}

func (ga *GA) mutation(p Individuals) {
	for i := range p {
		for j := 0; j < ga.nGenes; j++ {
			var r float64 = rand.Float64()
			if r < ga.mutationRate {
				p[i].genes[j] = !p[i].genes[j]
			}
		}
	}
}

func (ga *GA) elitism(p Individuals, new_p Individuals) {
	var nElites int = int(math.Ceil(ga.elitismRate * float64(ga.nIndividuals)))
	for i := nElites; i < ga.nIndividuals; i++ {
		p[i] = new_p[i-nElites]
	}
}

func (ga *GA) updateFitness(p Individuals) {
	for i := 0; i < ga.nIndividuals; i++ {
		p[i].fitness = ga.knapsack.Objective(p[i].genes)
	}
	sort.Sort(p)
}

func (ga *GA) Run() Individual {
	var p Individuals = ga.generatePopulation()
	for i := 1; i < ga.nGenerations+1; i++ {
		var new_p Individuals = ga.recombination(p)
		ga.mutation(new_p)
		ga.updateFitness(new_p)
		ga.elitism(p, new_p)
		ga.updateFitness(p)
	}
	return p[0]
}
