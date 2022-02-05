extends Node2D


# Declare member variables here. Examples:
export var velocity = 10
onready var player = get_node("Player")

var collision = false
var dragging = false
var click_radius = 64 # Size of the sprite.
#var player_pixel_size = Vector2(-12, -12)
var shader_min_pixel_size = 8
var shader_max_pixel_size = 512
#export(PackedScene) var Player = preload("res://player.tscn") 
#var player:Player = $Player
# var a = 2
# var b = "text"
#var map = load('map.tscn').instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	add_child(map)
#
func _physics_process(delta):
	player.linear_velocity[0] = clamp(player.linear_velocity[0], -200, 200)
	player.linear_velocity[1] = -200 if player.linear_velocity[1] <= -200 else player.linear_velocity[1]
#	player.get_node("Sprite").material.set_shader_param('image_size', ((player_pixel_size*200) / player.linear_velocity[0]) * delta * 100)
#	player.get_node("Sprite").material.set_shader_param('image_size', ((player_pixel_size*200) / player.linear_velocity[1]) * delta * 5.25)
#	var shader_image_size = Vector2(((player_pixel_size*200) / player.linear_velocity[0]) * delta, (clamp(player.linear_velocity[1], -200, 200) / player.linear_velocity[1])) * delta)
#	var shader_image_size = Vector2(
#		((shader_min_pixel_size[0] * 200) / (abs(player.linear_velocity[0]) + 12)) * delta * 0.05, 
#		200
#	)
#	var shader_image_size = Vector2(
#			abs(player.linear_velocity[0]),
#			64
#		)
#	var shader_image_size = Vector2(
#			clamp(shader_max_pixel_size * (1 / (abs(player.linear_velocity[0]) + 1)), shader_min_pixel_size, shader_max_pixel_size),
#			clamp(shader_max_pixel_size * (1 / (abs(player.linear_velocity[1]) + 1)), shader_min_pixel_size, shader_max_pixel_size)
#	)
	var shader_image_size = Vector2(
			clamp(shader_max_pixel_size * (1 / (abs(player.linear_velocity[0]) + 1)), shader_min_pixel_size, shader_max_pixel_size),
			clamp(shader_max_pixel_size * (1 / (abs(player.linear_velocity[1]) + 1)), shader_min_pixel_size, shader_max_pixel_size)
	)
#	player.get_node("Sprite").material.set_shader_param('image_size', shader_image_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print($Player.position)
	if Input.is_action_pressed("ui_right"):
		player.apply_impulse(Vector2(0, -130 * delta * 3), Vector2(130 * delta * 3, 0))
	elif Input.is_action_pressed("ui_left"):
#			$Player.apply_impulse(Vector2(0, 0), Vector2(-13, 0))  
		player.apply_impulse(Vector2(0, -130 * delta * 3), Vector2(-130 * delta * 3, 0)) 
	elif Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	
	$CanvasLayer/Control/Label.text = "player_position: \n" + str(player.position)
	$CanvasLayer/Control/Label.text += "\nlinear_velocity: \n" + str(player.linear_velocity)
	$CanvasLayer/Control/Label.text += "\nsleeping: " + str(player.sleeping)
	$CanvasLayer/Control/Label.text += "\ncollision: " + str(collision)
	if delta == 0:
		delta = 1
	$CanvasLayer/Control/Label.text += "\nFPS: " + str(ceil(1/delta))
#	$Player.apply_impulse(Vector2(0, -130) * delta, Vector2(130, 0) * delta) 
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
#		var cam = player.get_node('Camera2D')
		print(player.get_viewport().get_position_in_parent())
		print(event.global_position, player.get_global_transform_with_canvas().origin)
		if (event.position - player.get_global_transform_with_canvas().origin).length() < click_radius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		player.mode = RigidBody2D.MODE_STATIC
#		player.position *= 0
		player.mode = RigidBody2D.MODE_RIGID


func _unhandled_input(event):
	if player.sleeping or collision:
		if event.is_action_pressed("jump"):
			player.apply_impulse(Vector2(0, 0), Vector2(0, -300))
	
#		$Player.apply_impulse(Vector2(1000, 0), Vector2(10,10))
#		$Player.add_force(Vector2(100, 0), Vector2(0, 0))
#		print('Click')
#		var new_player = Player.instance()
#		new_player.position = get_viewport().get_mouse_position()
#		add_child(new_player)
#	if Input.is_action_pressed("jump"):
#		var player:Player = $Player
#	if event.is_action_pressed("click"):
#		var new_ball = Ball.instance()
#		new_ball.position = get_viewport().get_mouse_position()
#		add_child(new_ball)

#	pass # Replace with function body.


#func _on_Player_sleeping_state_changed():
#	print('State changed!')
#	pass # Replace with function body.


func _on_Player_body_entered(body):
	collision = true
	


func _on_Player_body_exited(body):
	collision = false


func _on_ResetButton_pressed():
	get_tree().reload_current_scene()
