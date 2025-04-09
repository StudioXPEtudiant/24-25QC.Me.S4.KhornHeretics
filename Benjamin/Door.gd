extends Area3D

@export var animation_player : AnimationPlayer
@export var area_de_detection : Area3D
@export var porte : Node3D  # La porte elle-même (ex : MeshInstance3D)

var porte_ouverte = false

# Fonction qui se déclenche lorsqu'un objet entre dans la zone
func _on_Area3D_body_entered(body):
	if body.is_in_group("player"):  # Vérifie si c'est un joueur
		ouvrir_porte()

# Fonction qui se déclenche lorsqu'un objet sort de la zone
func _on_Area3D_body_exited(body):
	if body.is_in_group("player"):  # Vérifie si c'est un joueur
		fermer_porte()

# Fonction pour ouvrir la porte
func ouvrir_porte():
	if not porte_ouverte:
		porte_ouverte = true
		animation_player.play("ouvrir")  # Jouer l'animation d'ouverture

# Fonction pour fermer la porte
func fermer_porte():
	if porte_ouverte:
		porte_ouverte = false
		animation_player.play("fermer")  # Jouer l'animation de fermeture
