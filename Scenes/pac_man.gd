extends CharacterBody2D


@export var speed := 100.0

signal direction_changed(direction)

#func _physics_process(delta: float) -> void:
#
	#var horizontal := Input.get_axis("left", "right")
	#var vertical = Input.get_axis("up", "down")
	#
	#if horizontal:
		#if !test_move(global_transform, Vector2(horizontal, 0) *speed *delta):
			#velocity.x = horizontal * speed
			#direction_changed.emit(horizontal)
	#
	#if vertical:
		#if !test_move(global_transform, Vector2(vertical, 0) *speed *delta): #tests if by moving the object from global_transform using the Vector2 there would be any collisions (if yes => true)
			#velocity.y = vertical * speed
			#direction_changed.emit(vertical * 2)
#
	#move_and_slide()
const TILE_SIZE = 16
const SPEED = 100

var direction := Vector2.ZERO
var desired_direction := Vector2.ZERO  # V(0, 0)
var target_position := Vector2.ZERO
var is_moving := false

func _ready() -> void:
	#Transforms the position vector in the nearest multiple of the Vector2 
	# ex: (37, 12).snapped((16, 16)) => (32, 16)
	target_position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	
	
func _process(delta: float) -> void:
	handle_input()
	if is_moving:
		move_to_target(delta)
	else:
		try_move()

func handle_input():
	if Input.is_action_pressed("right"):
		desired_direction = Vector2.RIGHT # V(1, 0)
	elif Input.is_action_pressed("left"):
		desired_direction = Vector2.LEFT
	elif Input.is_action_pressed("up"):
		desired_direction = Vector2.UP
	elif Input.is_action_pressed("down"):
		desired_direction = Vector2.DOWN

func move_to_target(delta):
	position = position.move_toward(target_position, SPEED * delta)
	if position == target_position:
		is_moving = false

func try_move():
	var next_tile_pos = (position + desired_direction * TILE_SIZE).snapped(Vector2(TILE_SIZE, TILE_SIZE))
	if is_tile_walkable(next_tile_pos):
		direction = desired_direction
		direction_changed.emit(direction)
		target_position = next_tile_pos
		is_moving = true
		

func is_tile_walkable(pos: Vector2) -> bool:
	var wall_tilemap: TileMapLayer = $"../Map/Walls"
	var coords = wall_tilemap.local_to_map(pos)
	var tile_id = wall_tilemap.get_cell_source_id(coords)

	# If there's no wall tile at this position, it's walkable
	return tile_id == -1

func _on_direction_changed(direction: Variant) -> void:
	match direction:
		Vector2.RIGHT:
			$".".rotation = deg_to_rad(0) # conversion from degrees to radian
		Vector2.LEFT:
			$".".rotation = deg_to_rad(180)
		Vector2.DOWN:
			$".".rotation = deg_to_rad(90)
		Vector2.UP:
			$".".rotation = deg_to_rad(-90)
		_:
			pass
	
