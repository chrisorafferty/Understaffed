extends Node

func easeOutQuad(_x: float) -> float:
	return 1 - (1 - _x) * (1 - _x)
	
func easeOutQuint(x: float) -> float:
	var w = x - 1
	return 1 + w * w * w * w * w;
