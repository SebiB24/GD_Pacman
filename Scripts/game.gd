extends Node
var Ghost = preload("res://Scenes/ghost.tscn")
var score := 0
enum EndGameStatus {LOSE, WIN}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	spawnGhosts();


func _process(delta: float) -> void:
	if get_tree().paused == true:
		return
	$ScoreLabel.text = "SCORE: " + str(score)


func spawnGhosts():
	var readGhost = Ghost.instantiate()
	readGhost.position = Vector2(16, -16)
	add_child(readGhost)
	readGhost.sprite_2d.texture = load("res://Resources/textures/ghosts/redGhost.png")
	
	
	var pinkGhost = Ghost.instantiate()
	pinkGhost.position = Vector2(-16, -16)
	add_child(pinkGhost)
	pinkGhost.sprite_2d.texture = load("res://Resources/textures/ghosts/pinkGhost.png")
	
	var blueGhost = Ghost.instantiate()
	blueGhost.position = Vector2(32, -16)
	add_child(blueGhost)
	blueGhost.sprite_2d.texture = load("res://Resources/textures/ghosts/blueGhost.png")
	
	var orangeGhost = Ghost.instantiate()
	orangeGhost.position = Vector2(-32, -16)
	add_child(orangeGhost)
	orangeGhost.sprite_2d.texture = load("res://Resources/textures/ghosts/orangeGhost.png")


func end_game(status: EndGameStatus):
	get_tree().paused = true
	if status == EndGameStatus.LOSE:
		$ScoreLabel.text = "YOU DIED"
	elif status == EndGameStatus.WIN:
		$ScoreLabel.text = "! YOU WON !"


func _input(event: InputEvent) -> void:
	if event is InputEventKey and get_tree().paused == true:
		get_tree().paused = false
		get_tree().reload_current_scene()


func _on_pac_man_increase_score() -> void:
	score += 1


func _on_pac_man_handle_ghost_collision() -> void:
	end_game(EndGameStatus.LOSE)


func _on_pac_man_handle_game_won() -> void:
	end_game(EndGameStatus.WIN) 
