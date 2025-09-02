extends Control

var entries: Array[FishData]
var left_panels: Array
var right_panels: Array

@onready var left_page: VBoxContainer= $LeftPage
@onready var right_page: VBoxContainer = $RightPage


func _ready() -> void:
	load_data()
	
	left_panels = left_page.get_children()
	right_panels = right_page.get_children()
	for i in left_panels.size() + right_panels.size():
		var panel: PanelContainer = (
				left_panels[i] if i < left_panels.size()
				else right_panels[i - left_panels.size()]
		)
		var data: FishData = entries[i]
		show_entry(panel, data)


## adds all FishData in res://Resources/Fish to [Array] entries
func load_data() -> void:
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


## displays entry in encyclopedia
func show_entry(panel: PanelContainer, data) -> void:
	if data.caught > 0:
		panel.image.texture = data.image 
		
	var format: String = "[b]%s[/b]\nRarity: %s\nSize: %s\nCaught: %d"
	
	panel.label.text = format % [
			data.name.capitalize() if data.caught > 0 else "???",
			int_to_string(data.rarity, "rarity").capitalize(),
			int_to_string(data.size, "size").capitalize(),
			data.caught
	]


func int_to_string(num: int, data_type: String) -> String:
	const CONVERSION = {
		"size": ["tiny", "small", "medium", "large", "huge"],
		"rarity": ["common", "uncommon", "rare", "epic", "legendary"]
	}
	
	return CONVERSION[data_type][num - 1]


func update_entry(data: FishData) -> void:
	var index = entries.find(data)
	if index < left_panels.size():
		show_entry(left_panels[index], data)
	else:
		index -= left_panels.size()
		show_entry(right_panels[index], data)


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
	var rarity_arr: Array = entries.map(func(entry): return entry.rarity)
	# map rarity_arr to array of corresponding probabilities
	var weights: Array = rarity_arr.map(
		func(rarity): return RARITY_PROB[rarity]
	)
	 
	return entries[rng.rand_weighted(weights)]
