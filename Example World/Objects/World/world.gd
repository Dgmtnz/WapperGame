extends Node3D

@onready var spawns = $spawns
@onready var navigation_region = $NavigationRegion3D
@onready var player = $NavigationRegion3D/Player_Character

@onready var hit_rect = $UI/HitRect
@onready var oof_sound = preload("res://Sonidos/roblox-death-sound-1-made-with-Voicemod.mp3")

var zombie = load("res://PNGs/CristobalNivel1.tscn")

var zombie2 = load("res://PNGs/CristobalNivel2.tscn")
var instance


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_zombie_spawn_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	
	if player.score >= 0:
		instance = zombie.instantiate()
		instance.position = spawn_point
		instance.visible = true
		navigation_region.add_child(instance)
	if player.score >= 10:
		instance = zombie2.instantiate()
		instance.position = spawn_point
		instance.visible = true
		navigation_region.add_child(instance)
	if player.score >= 30:
		instance = zombie2.instantiate()
		instance.position = spawn_point
		instance.visible = true
		navigation_region.add_child(instance)
	if player.score >= 40:
		instance = zombie2.instantiate()
		instance.position = spawn_point
		instance.visible = true
		navigation_region.add_child(instance)
	if player.score >= 50:
		instance = zombie2.instantiate()
		instance.position = spawn_point
		instance.visible = true
		navigation_region.add_child(instance)
		
func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	# Crear un nuevo AudioStreamPlayer3D
	var sound_player = AudioStreamPlayer3D.new()
	# Establecer el stream al sonido de disparo
	sound_player.stream = oof_sound
	# Añadir el AudioStreamPlayer3D al árbol de nodos
	self.add_child(sound_player)
	# Reproducir el sonido
	sound_player.volume_db = 30
	sound_player.play()
	hit_rect.visible = false


