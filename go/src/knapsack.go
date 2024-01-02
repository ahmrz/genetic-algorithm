/*
 * knapsack.go
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

type Knapsack struct {
	optimum  float64
	capacity float64
	weights  []float64
	values   []float64
}

// Get the knapsack dataset
func GetKnapsack(option int) Knapsack {
	switch option {
	case 1:
		return Knapsack{295, 269,
			[]float64{95, 4, 60, 32, 23, 72, 80, 62, 65, 46},
			[]float64{55, 10, 47, 5, 4, 50, 8, 61, 85, 87}}
	case 2:
		return Knapsack{1024, 878,
			[]float64{92, 4, 43, 83, 84, 68, 92, 82, 6, 44, 32,
				18, 56, 83, 25, 96, 70, 48, 14, 58},
			[]float64{44, 46, 90, 72, 91, 40, 75, 35, 8, 54, 78,
				40, 77, 15, 61, 17, 75, 29, 75, 63}}
	case 3:
		return Knapsack{35, 20,
			[]float64{6, 5, 9, 7},
			[]float64{9, 11, 13, 15}}
	case 4:
		return Knapsack{23, 11,
			[]float64{2, 4, 6, 7},
			[]float64{6, 10, 12, 13}}
	case 5:
		return Knapsack{481.0694, 375,
			[]float64{5.635853e+01, 8.087405e+01, 4.798730e+01,
				8.959624e+01, 7.466048e+01, 8.589435e+01, 5.135350e+01,
				1.498459e+00, 3.644520e+01, 1.658986e+01, 4.456923e+01,
				4.669330e-01, 3.778802e+01, 5.711844e+01, 6.071657e+01},
			[]float64{1.251260e-01, 1.933042e+01, 5.850093e+01,
				3.502914e+01, 8.228400e+01, 1.741081e+01, 7.105014e+01,
				3.039949e+01, 9.140294e+00, 1.473128e+01, 9.885250e+01,
				1.190832e+01, 8.911400e-01, 5.316629e+01, 6.017640e+01}}
	case 6:
		return Knapsack{52, 60,
			[]float64{30, 25, 20, 18, 17, 11, 5, 2, 1, 1},
			[]float64{20, 18, 17, 15, 15, 10, 5, 3, 1, 1}}
	case 7:
		return Knapsack{107, 50,
			[]float64{31, 10, 20, 19, 4, 3, 6},
			[]float64{70, 20, 39, 37, 7, 5, 10}}
	case 8:
		return Knapsack{9767, 10000,
			[]float64{983, 982, 981, 980, 979, 978, 488, 976,
				972, 486, 486, 972, 972, 485, 485, 969, 966, 483, 964, 963,
				961, 958, 959},
			[]float64{981, 980, 979, 978, 977, 976, 487, 974,
				970, 485, 485, 970, 970, 484, 484, 976, 974, 482, 962, 961,
				959, 958, 857}}
	case 9:
		return Knapsack{130, 80,
			[]float64{15, 20, 17, 8, 31},
			[]float64{33, 24, 36, 37, 12}}
	case 10:
		return Knapsack{1025, 879,
			[]float64{84, 83, 43, 4, 44, 6, 82, 92, 25, 83, 56,
				18, 58, 14, 48, 70, 96, 32, 68, 92},
			[]float64{91, 72, 90, 46, 55, 8, 35, 75, 61, 15, 77,
				40, 63, 75, 29, 75, 17, 78, 40, 44}}
	case 11:
		return Knapsack{1437, 577,
			[]float64{46, 17, 35, 1, 26, 17, 17, 48, 38, 17, 32,
				21, 29, 48, 31, 8, 42, 37, 6, 9, 15, 22, 27, 14, 42, 40, 14, 31,
				6, 34},
			[]float64{57, 64, 50, 6, 52, 6, 85, 60, 70, 65, 63,
				96, 18, 48, 85, 50, 77, 18, 70, 92, 17, 43, 5, 23, 67, 88, 35,
				3, 91, 48}}
	case 12:
		return Knapsack{1689, 655,
			[]float64{7, 4, 36, 47, 6, 33, 8, 35, 32, 3, 40, 50,
				22, 18, 3, 12, 30, 31, 13, 33, 4, 48, 5, 17, 33, 26, 27, 19,
				39, 15, 33, 47, 17, 41, 40},
			[]float64{35, 67, 30, 69, 40, 40, 21, 73, 82, 93, 52,
				20, 61, 20, 42, 86, 43, 93, 38, 70, 59, 11, 42, 93, 6, 39, 25,
				23, 36, 93, 51, 81, 36, 46, 96}}
	case 13:
		return Knapsack{1821, 819,
			[]float64{28, 23, 35, 38, 20, 29, 11, 48, 26, 14, 12,
				48, 35, 36, 33, 39, 30, 26, 44, 20, 13, 15, 46, 36, 43, 19, 32,
				2, 47, 24, 26, 39, 17, 32, 17, 16, 33, 22, 6, 12},
			[]float64{13, 16, 42, 69, 66, 68, 1, 13, 77, 85, 75,
				95, 92, 23, 51, 79, 53, 62, 56, 74, 7, 50, 23, 34, 56, 75, 42,
				51, 13, 22, 30, 45, 25, 27, 90, 59, 94, 62, 26, 11}}
	case 14:
		return Knapsack{2033, 907,
			[]float64{18, 12, 38, 12, 23, 13, 18, 46, 1, 7, 20,
				43, 11, 47, 49, 19, 50, 7, 39, 29, 32, 25, 12, 8, 32, 41, 34,
				24, 48, 30, 12, 35, 17, 38, 50, 14, 47, 35, 5, 13, 47, 24, 45,
				39, 1},
			[]float64{98, 70, 66, 33, 2, 58, 4, 27, 20, 45, 77,
				63, 32, 30, 8, 18, 73, 9, 92, 43, 8, 58, 84, 35, 78, 71, 60,
				38, 40, 43, 43, 22, 50, 4, 57, 5, 88, 87, 34, 98, 96, 99, 16,
				1, 25}}
	case 15:
		return Knapsack{2440, 882,
			[]float64{15, 40, 22, 28, 50, 35, 49, 5, 45, 3, 7,
				32, 19, 16, 40, 16, 31, 24, 15, 42, 29, 4, 14, 9, 29, 11, 25,
				37, 48, 39, 5, 47, 49, 31, 48, 17, 46, 1, 25, 8, 16, 9, 30,
				33, 18, 3, 3, 3, 4, 1},
			[]float64{78, 69, 87, 59, 63, 12, 22, 4, 45, 33, 29,
				50, 19, 94, 95, 60, 1, 91, 69, 8, 100, 32, 81, 47, 59, 48, 56,
				18, 59, 16, 45, 54, 47, 84, 100, 98, 75, 20, 4, 19, 58, 63,
				37, 64, 90, 26, 29, 13, 53, 83}}
	default:
		return Knapsack{5, 5,
			[]float64{1, 2, 3, 4},
			[]float64{1, 2, 3, 4}}
	}
}

func dot(x []bool, y []float64) float64 {
	var sum float64 = 0
	for i := range x {
		if x[i] {
			sum += y[i]
		}
	}
	return sum
}

func (k *Knapsack) Objective(x []bool) float64 {
	var w = dot(x, k.weights)
	var v = dot(x, k.values)
	if w > k.capacity {
		return -v
	} else {
		return v
	}
}
