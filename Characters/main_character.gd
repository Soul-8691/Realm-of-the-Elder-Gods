extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var total_move_time : float = 0
@export var move_time_before_run : float
@export var walk_speed : float = 100
@export var run_speed : float = 200

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	var move_speed : float = walk_speed
	var is_running : bool = false
	if(input_direction != Vector2.ZERO):
		total_move_time += _delta
	if(total_move_time >= move_time_before_run):
		move_speed = run_speed
		is_running = true
	else:
		total_move_time = 0
	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	move_and_slide()

func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Run/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
