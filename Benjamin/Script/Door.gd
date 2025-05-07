extends Node

@onready var animation_player = $"../AnimationPlayer"



func _ready():
	pass
	

  # Remplace avec le bon nom de noeud si nécessaire

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		if animation_player.has_animation("Open"):
			animation_player.play("Open")
			print("alo")
		else:
			push_warning("L'animation 'Open' n'existe pas dans AnimationPlayer.")



func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		if animation_player.has_animation("Close"):
			animation_player.play("Close")
			print("alo")
		else:
			push_warning("L'animation 'Open' n'existe pas dans AnimationPlayer.")# Replace with function body.
