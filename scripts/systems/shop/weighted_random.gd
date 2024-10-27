class_name WeightedRandom
extends Resource

@export var choices: Dictionary

func put_choice(choice: Variant, weight: float) -> void:
	choices[choice] = weight

func spin() -> float:
	var total_weight: float = choices.values().reduce(func(l, r): return l + r, 0)
	var rng = RandomNumberGenerator.new()
	return rng.randf_range(0, total_weight)

func get_random() -> Variant:
	var start_weight: float = spin()
	for choice in choices.keys():
		var weight: float = choices[choice]
		if start_weight <= weight:
			return choice
		start_weight -= weight
	return "This isn't supposed to happen!!"
