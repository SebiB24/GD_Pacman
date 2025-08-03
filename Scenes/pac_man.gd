extends CharacterBody2D


@export var speed := 100.0

signal direction_changed(direction)

func _physics_process(delta: float) -> void:

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		direction_changed.emit(direction)

	direction = Input.get_axis("up", "down")
	if direction:
		velocity.y = direction * speed
		direction_changed.emit(direction * 2)

	move_and_slide()
	
	

func _on_direction_changed(direction: Variant) -> void:
	match int(direction):
		1:
			$".".rotation = deg_to_rad(0) # conversion from degrees to radian
		-1:
			$".".rotation = deg_to_rad(180)
		2:
			$".".rotation = deg_to_rad(90)
		-2:
			$".".rotation = deg_to_rad(-90)
		_:
			pass
	
