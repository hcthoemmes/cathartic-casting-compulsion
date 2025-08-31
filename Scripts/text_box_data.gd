extends Resource
class_name TextBoxData

# Alter text based on the player's fishing level
@export_group("Mutability")
@export var mutable: bool	## If this text has any changeable elements
@export var mut_index: int	## Which index in the contents can be changed.
@export_multiline var mut_contents: Array[String]


@export_group("Contents")
@export var name: String
@export_multiline var contents: Array[String]
