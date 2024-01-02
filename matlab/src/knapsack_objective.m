function fitness = knapsack_objective (genes, knapsack)
	total_weight = dot(genes, knapsack.weights);
	total_value = dot(genes, knapsack.values);
	if total_weight > knapsack.capacity
		fitness = -total_value;
	else
		fitness = total_value;
	end
end




