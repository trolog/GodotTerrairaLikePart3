extends Area2D

export(NodePath) var tilemap_path
export(float) var swing_time = 0.25 # how long between swings

var is_swinging = true # if true then do our swing loop

var tilemap : TileMap

onready var swing_timer := $Timer
onready var ani_player := $AnimationPlayer

func _ready() -> void:
	tilemap = get_node(tilemap_path)

func _physics_process(_delta: float) -> void:
	
	look_at(get_global_mouse_position())
	
	if(Input.is_action_just_pressed("mb_left")):
		start_swing()
	if(Input.is_action_just_released("mb_left")):
		stop_swing()
		
func start_swing():
	is_swinging = true
	swing_timer.start(swing_time)
	ani_player.play("swing")
	ani_player.playback_speed = 1 / swing_time
	
	
func stop_swing():
	is_swinging = false
	swing_timer.stop()
	ani_player.stop()
	$Sprite.scale = Vector2(1,1)

func _swing_timer_timeout() -> void:
	hit_block()
	if(is_swinging):
		swing_timer.start(swing_time)
		ani_player.play("swing")


func hit_block():
	var tile : Vector2 = tilemap.world_to_map($CollisionShape2D.global_position)
	var id = tilemap.get_cell(int(tile.x),int(tile.y))
	
	if(id != -1): # we've hit something
		if(id in [4,9,14,19,24]): # these are last stage blocks
			#TODO add or spawn gem
			id = -1 # remove the block
		else:# increase the blocks ID
			id+=1
			#TODO : particles
		tilemap.set_cell(int(tile.x),int(tile.y) ,id)
