extends CharacterBody3D

var player = null
# Variables para la velocidad mínima y máxima del enemigo
var min_speed = 1.0
var max_speed = 6.50
var SPEED = 4.0

const ATTACK_RANGE = 2.0
var Health = 3

# Variables para el tamaño mínimo y máximo del enemigo
var min_scale = 0.55
var max_scale = 1

signal zombie_hit
signal enemy_defeated


@export var player_path :=  "/root/World/NavigationRegion3D/Player_Character"
var ammo_box = preload("res://Player_Controller/Spawnable_Objects/Clips/blaster_n_clip.tscn")  # Asegúrate de reemplazar esto con la ruta a tu escena de caja de munición


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var nav_agent = $NavigationAgent3D


func Hit_Successful(Damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= Damage
	if Health <= 0:
		emit_signal("enemy_defeated")
		# Spawnea una caja de munición con una probabilidad del 50%
		if randf() < 0.5:
			var municion = ammo_box.instantiate()
			municion.global_transform = global_transform
			get_parent().add_child(municion)
		queue_free()
		

func _process(delta):
	move_and_slide()
	velocity = Vector3.ONE
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	if _target_in_range():
		_hit_finished()
		
		
func _ready():
	player = get_node(player_path)
	SPEED = randf_range(min_speed, max_speed)
	self.enemy_defeated.connect(player._on_enemy_defeated)

	# Genera un valor aleatorio para la escala
	var random_scale = randf_range(min_scale, max_scale)

	# Aplica la escala al enemigo
	self.scale = Vector3(random_scale, random_scale, random_scale)

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
		



