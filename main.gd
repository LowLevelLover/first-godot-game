extends Node

@export var mob_scene: PackedScene
var score
var color_up

func _ready() -> void:
	color_up = 1


func _input(_event):
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()


func _process(_delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()

	$HUD.show_game_over()

	get_tree().call_group("mobs", "queue_free")

	$Music.stop()
	$DeathSound.play()


func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

	$Music.play()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2

	mob.position = mob_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0 + score, 250.0 + score), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_color_timer_timeout() -> void:
	if $ColorRect.color.g8 == 160:
		color_up = -1
	elif $ColorRect.color.g8 == 80:
		color_up = 1

	$ColorRect.color.g8 += color_up
