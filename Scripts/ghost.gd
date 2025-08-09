extends CharacterMovement

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	add_to_group("ghosts")
	#sprite_2d.texture = load("res://Resources/textures/ghosts/redGhost.png")

func _process(delta: float) -> void:
	if get_tree().paused == true:
		return
		
	super._process(delta)


func handle_input():
	var choices = [1,2,3,4]
	var number = choices.pick_random()
	
	match number:
		1:
			if direction != Vector2.LEFT:
				desired_direction = Vector2.RIGHT
		2:
			if direction != Vector2.RIGHT:
				desired_direction = Vector2.LEFT
		3:
			if direction != Vector2.DOWN:
				desired_direction = Vector2.UP
		4:
			if direction != Vector2.UP:
				desired_direction = Vector2.DOWN
