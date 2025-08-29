class_name FishingLogData extends Resource

var entries: Array[FishData]

# PSEUDOCODE FOR FISHING LOG UI	
# FOR entry in entries:
# 	IF entry.caught > 0:
# 		display picture and info
#	ELSE:
#		display question mark (and silhouette?) and some info

func _ready() -> void:
	load_entries()

## adds all FishData in res://Resources/Fish to Array[] entries
func load_entries() -> void:
	entries = []
	var path = "res://Resources/Fish"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		entries.append(load("%s/%s" % [path, file_name]))
		file_name = dir.get_next()
	entries.sort_custom(sort_rarity) # sorted by rarity ascending
		
func sort_rarity(a, b) -> bool:
	return a.rarity < b.rarity
