class_name CharacterMovement
extends CharacterBody2D


const TILE_SIZE = 16

var speed := 60.0
var is_moving := false

var direction := Vector2.ZERO
var desired_direction := Vector2.ZERO  # V(0, 0)
var prev_desired_direction := Vector2.ZERO
var target_position := Vector2.ZERO

signal direction_changed(direction)

func _ready() -> void:
	# Transforms the position vector in the nearest multiple of the Vector2 
	# ex: (37, 12).snapped((16, 16)) => (32, 16)
	target_position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	
	
func _process(delta: float) -> void:
	handle_input()
	if is_moving:
		move_to_target(delta)
	else:
		try_move()

func handle_input():
	pass

func move_to_target(delta):
	position = position.move_toward(target_position, speed * delta)
	if position == target_position:
		is_moving = false
	
	# coord check and change for teleportation
	if position.y == -16:
		if position.x == 176.0:
			position.x = -160.0
		if position.x == -176.0:
			position.x = 160.0

func try_move():
	var next_tile_pos = (position + desired_direction * TILE_SIZE).snapped(Vector2(TILE_SIZE, TILE_SIZE))
	if is_tile_walkable(next_tile_pos):
		direction = desired_direction
		prev_desired_direction = desired_direction
		direction_changed.emit(direction)
		target_position = next_tile_pos
		is_moving = true
	else:
		desired_direction = prev_desired_direction
		is_moving = true
		

func is_tile_walkable(pos: Vector2) -> bool:
	var wall_tilemap: TileMapLayer = $"../Map/Walls"
	# .local_to_map -- returns coords of cell containing the pos coordonates
		# pos -> considering those coord in the local coord sistem
		# wall_tilemap.to_local(pos) -> considering those coord in the global coord sistem
	var coords = wall_tilemap.local_to_map(wall_tilemap.to_local(pos)) 
	var tile_id = wall_tilemap.get_cell_source_id(coords)

	# If there's no wall tile at this position, it's walkable
	return tile_id == -1
