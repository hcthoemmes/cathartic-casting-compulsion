extends Area3D

@export var data: TextBoxData

func display_check():
	pass

func _on_body_entered(body: Node3D) -> void:
	if body == GS.h:
		if data.mutable:
			var v
			# Doing this the gross way for now cause I gotta PUSH
			# To be replaced with like. A nice table or something later on
			# And also bound it so we don't go overboard
			if GS.timesFished == 0:
				v = 0
			elif GS.timesFished >= 1 and GS.timesFished < 10:
				v = 1
			elif GS.timesFished >=10 and GS.timesFished < 20:
				v = 2
			else:
				v = 3
			
			if v > data.mut_contents.size():
				v = data.mut_contents.size()
			GS.show_text(data, v)
		else: GS.show_text(data)
	pass # Replace with function body.
