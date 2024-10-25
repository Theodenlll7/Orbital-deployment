class_name CustomWave extends Resource

@export var wave_number: int = 10  ## When to run this wave
@export var enemies: Array[PackedScene]  ## List of enemyes that are garanteed to spawn

@export_group("Standard pool settings")
@export_range(0, 100, 1, "or_greater") var extra_mobspawn_count: int = 0

@export_range(0, 1) var base_mobs_mean: float = 0.5

@export_range(0, 100) var base_mobs_std_dev: float = 0.5
