extends CharacterMovement

signal increase_score()
signal handle_ghost_collision()
signal handle_game_won()

func _ready() -> void:
	super._ready()


func _process(delta: float) -> void:
	if get_tree().paused == true:
		$AnimatedSprite2D.stop()
		return
		
	super._process(delta)
	eatFood()


func _on_direction_changed(direction: Variant) -> void:
	match direction:
		Vector2.RIGHT:
			$AnimatedSprite2D.rotation = deg_to_rad(0) # conversion from degrees to radian
		Vector2.LEFT:
			$AnimatedSprite2D.rotation = deg_to_rad(180)
		Vector2.DOWN:
			$AnimatedSprite2D.rotation = deg_to_rad(90)
		Vector2.UP:
			$AnimatedSprite2D.rotation = deg_to_rad(-90)
		_:
			pass


func handle_input():
	if Input.is_action_just_pressed("right"):
		desired_direction = Vector2.RIGHT # V(1, 0)
	elif Input.is_action_just_pressed("left"):
		desired_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("up"):
		desired_direction = Vector2.UP
	elif Input.is_action_just_pressed("down"):
		desired_direction = Vector2.DOWN


func eatFood():
	var pos = position
	var food: TileMapLayer = $"../Map/Food"
	var coords = food.local_to_map(food.to_local(pos))
	var foodId = food.get_cell_source_id(coords)
	
	if foodId != -1:
		increase_score.emit()
		food.erase_cell(coords)
		
	if food.get_used_cells().size() == 0:
		handle_game_won.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ghosts"):
		handle_ghost_collision.emit()
