extends CharacterBody2D

@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_time_before_run : float = 1.0
@export var walk_speed : float = 100
@export var run_speed : float = 500
@onready var timer: Timer = $Timer

var total_move_time : float = 0
var is_running : bool = false
var move_speed : float = walk_speed

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if(input_direction != Vector2.ZERO):
		total_move_time += _delta
		if(timer.is_stopped() and is_running == false):
			timer.start(move_time_before_run)
	else:
		total_move_time = 0
		move_speed = walk_speed
		is_running = false
	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	move_and_slide()

func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		if is_running:
			animation_tree.set("parameters/Run/blend_position", move_input)
			state_machine.travel("Run")
			print('Running')
		else:
			animation_tree.set("parameters/Walk/blend_position", move_input)
			state_machine.travel("Walk")
			print('Walking')

func _on_timer_timeout():
	if(total_move_time >= move_time_before_run):
		move_speed = run_speed
		is_running = true
