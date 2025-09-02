class_name EncyclopediaData extends Control

var entries: Array[FishData]

# PSEUDOCODE FOR FISHING LOG UI	
# FOR entry in entries:
# 	IF entry.caught > 0:
# 		display picture and info
#	ELSE:
#		display question mark (and silhouette?) and some info


func _init() -> void:
	load_entries()


## adds all FishData in res://Resources/Fish to [Array] entries
func load_entries() -> void:
	entries = []
	var path = "res://Resources/Fish"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		entries.append(load("%s/%s" % [path, file_name]))
		file_name = dir.get_next()
		
	# sort entries by rarity ascending
	entries.sort_custom(func(a, b): return a.rarity < b.rarity) 


## returns a random [FishData] using weighted probabilities
func get_random_fish() -> FishData:
	var rng = RandomNumberGenerator.new()
	
	const RARITY_PROB := {
		1: 0.5, 
		2: 0.25, 
		3: 0.15, 
		4: 0.08, 
		5: 0.02,
	}
	
	# make array of all fishes' rarities
	var rarity_arr = entries.map(func(entry): return entry.rarity)
	# map rarity_arr to array of corresponding probabilities
	var weights := rarity_arr.map(func(rarity): return RARITY_PROB[rarity])
	 
	return entries[rng.rand_weighted(weights)]
