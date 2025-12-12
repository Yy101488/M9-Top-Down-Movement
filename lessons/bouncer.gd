extends CharacterBody2D



@onready var _dust: GPUParticles2D = %Dust
@onready var _runner_visual_purple: RunnerVisual = %RunnerVisualPurple


@export var max_speed:=600.0
@export var acceleration:=1200.0
@export var deceleration := 1080.0

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(get_global_mouse_position())
	var distance :=global_position.distance_to(get_global_mouse_position())
	var speed := max_speed if distance > 100 else max_speed * distance/100
	
	var desired_velocity := direction* speed
	velocity= velocity.move_toward(desired_velocity,acceleration*delta)
	move_and_slide()
	
	if velocity.length()>10.0:
		_runner_visual_purple.angle = rotate_toward(_runner_visual_purple.angle, direction.orthogonal().angle(), 8.0 * delta)
		var current_speed_percent:=velocity.length()/max_speed
		_runner_visual_purple.animation_name=(
			RunnerVisual.Animations.WALK
			if current_speed_percent <0.8
			else RunnerVisual.Animations.RUN
		)
		_dust.emitting = true
		
	else:
		_runner_visual_purple.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
