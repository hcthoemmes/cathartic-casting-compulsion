extends HeightMapShape3D

var heightmap_texture = ResourceLoader.load("res://Resources/fishingscape_heightmap.png")
var heightmap_image = heightmap_texture.get_image()

var height_min = 0.0
var height_max = 10.0

func _ready() -> void:
	heightmap_image.convert(Image.FORMAT_RF)
	update_map_data_from_image(heightmap_image, height_min, height_max)
