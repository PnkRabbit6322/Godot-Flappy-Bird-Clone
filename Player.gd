extends KinematicBody2D


const UP = Vector2(0, -1)
const FLAP = 300
const MAXFALLSPEED = 400
const GRAVITY = 20

var score = 0
var motion = Vector2()
var pipe = preload("res://PipeNode.tscn")
var spawn

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn = get_node("../../Spawnpoint")
	pass # Replace with function body.

func _physics_process(delta):
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
		
	if Input.is_action_just_pressed("FLAP"):
		motion.y = -FLAP
		
	motion = move_and_slide(motion, UP)
	
	get_parent().get_parent().get_node("CanvasLayer/RichTextLabel").text = str(score)

func Pipe_reset():
	var pipe_instance = pipe.instance()
	#pipe_instance.position = Vector2(420, rand_range(-90.0, 90.0))
	pipe_instance.global_position = spawn.global_position
	get_parent().call_deferred("add_child", pipe_instance)

func _on_DeleteZone_body_entered(body):
	if body.name == "Pipes":
		body.queue_free() 

func _on_SpawnZone_body_entered(body):
	if body.name == "Pipes":
		Pipe_reset()

func _on_Detect_area_entered(area):
	if area.name == "ScoreZone":
		score = score + 1
	elif area.name == "KillZone":
		get_tree().reload_current_scene()

func _on_Detect_body_entered(body):
	if body.name == "Pipes":
		get_tree().reload_current_scene()
