function knapsack = knapsack_datasets(number)
	if number == 1
		knapsack.optimum = 295;
		knapsack.capacity = 269;
		knapsack.weights = [95, 4, 60, 32, 23, 72, 80, 62, 65, 46];
		knapsack.values = [55, 10, 47, 5, 4, 50, 8, 61, 85, 87];
	elseif number == 2
		knapsack.optimum = 1024;
		knapsack.capacity = 878;
		knapsack.weights = [92, 4, 43, 83, 84, 68, 92, 82, 6, 44, 32, 18, 56, 83, 25, 96, 70, 48, 14, 58];
		knapsack.values = [44, 46, 90, 72, 91, 40, 75, 35, 8, 54, 78, 40, 77, 15, 61, 17, 75, 29, 75, 63];
	elseif number == 3
		knapsack.optimum = 35;
		knapsack.capacity = 20;
		knapsack.weights = [6, 5, 9, 7];
		knapsack.values = [9, 11, 13, 15];
	elseif number == 4
		knapsack.optimum = 23;
		knapsack.capacity = 11;
		knapsack.weights = [2, 4, 6, 7];
		knapsack.values = [6, 10, 12, 13];
	elseif number == 5
		knapsack.optimum = 481.0694;
		knapsack.capacity = 375;
		knapsack.weights = [5.635853e+01, 8.087405e+01, 4.798730e+01, 8.959624e+01, 7.466048e+01, 8.589435e+01, 5.135350e+01, 1.498459e+00, 3.644520e+01, 1.658986e+01, 4.456923e+01, 4.669330e-01, 3.778802e+01, 5.711844e+01, 6.071657e+01];
		knapsack.values = [1.251260e-01, 1.933042e+01, 5.850093e+01, 3.502914e+01, 8.228400e+01, 1.741081e+01, 7.105014e+01, 3.039949e+01, 9.140294e+00, 1.473128e+01, 9.885250e+01, 1.190832e+01, 8.911400e-01, 5.316629e+01, 6.017640e+01];
	elseif number == 6
		knapsack.optimum = 52;
		knapsack.capacity = 60;
		knapsack.weights = [30, 25, 20, 18, 17, 11, 5, 2, 1, 1];
		knapsack.values = [20, 18, 17, 15, 15, 10, 5, 3, 1, 1];
	elseif number == 7
		knapsack.optimum = 107;
		knapsack.capacity = 50;
		knapsack.weights = [31, 10, 20, 19, 4, 3, 6];
		knapsack.values = [70, 20, 39, 37, 7, 5, 10];
	elseif number == 8
		knapsack.optimum = 9767;
		knapsack.capacity = 10000;
		knapsack.weights = [983, 982, 981, 980, 979, 978, 488, 976, 972, 486, 486, 972, 972, 485, 485, 969, 966, 483, 964, 963, 961, 958, 959];
		knapsack.values = [981, 980, 979, 978, 977, 976, 487, 974, 970, 485, 485, 970, 970, 484, 484, 976, 974, 482, 962, 961, 959, 958, 857];
	elseif number == 9
		knapsack.optimum = 130;
		knapsack.capacity = 80;
		knapsack.weights = [15, 20, 17, 8, 31];
		knapsack.values = [33, 24, 36, 37, 12];
	elseif number == 10
		knapsack.optimum = 1025;
		knapsack.capacity = 879;
		knapsack.weights = [84, 83, 43, 4, 44, 6, 82, 92, 25, 83, 56, 18, 58, 14, 48, 70, 96, 32, 68, 92];
		knapsack.values = [91, 72, 90, 46, 55, 8, 35, 75, 61, 15, 77, 40, 63, 75, 29, 75, 17, 78, 40, 44];
	elseif number == 11
		knapsack.optimum = 1437;
		knapsack.capacity = 577;
		knapsack.weights = [46, 17, 35, 1, 26, 17, 17, 48, 38, 17, 32, 21, 29, 48, 31, 8, 42, 37, 6, 9, 15, 22, 27, 14, 42, 40, 14, 31, 6, 34];
		knapsack.values = [57, 64, 50, 6, 52, 6, 85, 60, 70, 65, 63, 96, 18, 48, 85, 50, 77, 18, 70, 92, 17, 43, 5, 23, 67, 88, 35, 3, 91, 48];
	elseif number == 12
		knapsack.optimum = 1689;
		knapsack.capacity = 655;
		knapsack.weights = [7, 4, 36, 47, 6, 33, 8, 35, 32, 3, 40, 50, 22, 18, 3, 12, 30, 31, 13, 33, 4, 48, 5, 17, 33, 26, 27, 19, 39, 15, 33, 47, 17, 41, 40];
		knapsack.values = [35, 67, 30, 69, 40, 40, 21, 73, 82, 93, 52, 20, 61, 20, 42, 86, 43, 93, 38, 70, 59, 11, 42, 93, 6, 39, 25, 23, 36, 93, 51, 81, 36, 46, 96];
	elseif number == 13
		knapsack.optimum = 1821;
		knapsack.capacity = 819;
		knapsack.weights = [28, 23, 35, 38, 20, 29, 11, 48, 26, 14, 12, 48, 35, 36, 33, 39, 30, 26, 44, 20, 13, 15, 46, 36, 43, 19, 32, 2, 47, 24, 26, 39, 17, 32, 17, 16, 33, 22, 6, 12];
		knapsack.values = [13, 16, 42, 69, 66, 68, 1, 13, 77, 85, 75, 95, 92, 23, 51, 79, 53, 62, 56, 74, 7, 50, 23, 34, 56, 75, 42, 51, 13, 22, 30, 45, 25, 27, 90, 59, 94, 62, 26, 11];
	elseif number == 14
		knapsack.optimum = 2033;
		knapsack.capacity = 907;
		knapsack.weights = [18, 12, 38, 12, 23, 13, 18, 46, 1, 7, 20,43, 11, 47, 49, 19, 50, 7, 39, 29, 32, 25, 12, 8, 32, 41, 34, 24, 48, 30, 12, 35, 17, 38, 50, 14, 47, 35, 5, 13, 47, 24, 45, 39, 1];
		knapsack.values = [98, 70, 66, 33, 2, 58, 4, 27, 20, 45, 77, 63, 32, 30, 8, 18, 73, 9, 92, 43, 8, 58, 84, 35, 78, 71, 60, 38, 40, 43, 43, 22, 50, 4, 57, 5, 88, 87, 34, 98, 96, 99, 16, 1, 25];
	elseif number == 15
		knapsack.optimum = 2440;
		knapsack.capacity = 882;
		knapsack.weights = [15, 40, 22, 28, 50, 35, 49, 5, 45, 3, 7, 32, 19, 16, 40, 16, 31, 24, 15, 42, 29, 4, 14, 9, 29, 11, 25, 37, 48, 39, 5, 47, 49, 31, 48, 17, 46, 1, 25, 8, 16, 9, 30, 33, 18, 3, 3, 3, 4, 1];
		knapsack.values = [78, 69, 87, 59, 63, 12, 22, 4, 45, 33, 29, 50, 19, 94, 95, 60, 1, 91, 69, 8, 100, 32, 81, 47, 59, 48, 56, 18, 59, 16, 45, 54, 47, 84, 100, 98, 75, 20, 4, 19, 58, 63, 37, 64, 90, 26, 29, 13, 53, 83];
	else
		knapsack.optimum = 5;
		knapsack.capacity = 5;
		knapsack.weights = [1, 2, 3, 4];
		knapsack.values = [1, 2, 3, 4];
	end
end
