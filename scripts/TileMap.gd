extends TileMap

export(int) var max_x = 200
export(int) var max_y = 200

var noise : OpenSimplexNoise = OpenSimplexNoise.new()
var noise_gems : OpenSimplexNoise = OpenSimplexNoise.new()

var snap_size_x  = 8
var snap_size_y = 8

var debug : bool = false

onready var selector : Sprite = $selector

func _ready() -> void:

	randomize()
	
	init_noise()
	init_noise_gems()
	
	generate_level()
	
	generate_gems()
	
func init_noise():
	noise.seed = randi()
	noise.octaves = 0
	noise.period = 5
	noise.persistence = 0.588
	noise.lacunarity = 2.43

func init_noise_gems():
	noise_gems.seed = randi()
	noise_gems.octaves = 9
	noise_gems.period = 6.6
	noise_gems.persistence = 0
	noise_gems.lacunarity = 0.1
	
func generate_level():
	for x in max_x:
		for y in max_y:
			var tile_id = generate_id(noise.get_noise_2d(x,y))
			if(tile_id != -1):
				set_cell(x,y,tile_id)
				
			#Generate safe platform
	for i in range(4):
		set_cell(6+i,0,0)
		set_cell(6+i,1,0)
		
func generate_gems():
	for x in max_x:
		for y in max_y:
			if(get_cell(x,y) != -1): # there is mud here to place gem
				
				if(noise_gems.get_noise_2d(x,y) > 0.5):
					
					#Get percentage of the way down
					var percent : int = (float(y) / float(max_y)) * 100
					var gemID = 0 # mud
					
					#Further down the more rare the gem
					if(percent in range(0,20)):
						if(rand_range(0,1)) > 0.05: # 95%
							gemID = 5
						else:
							gemID = 10 #5% chance of a better gem
					elif(percent in range(21,40)):
						if(rand_range(0,1)) > 0.2: # 80%
							gemID = 10
						else:
							gemID = 15 #20% chance of a better gem
					elif(percent in range(41,60)):
						if(rand_range(0,1)) > 0.2: # 80%
							gemID = 15
						else:
							gemID = 20 #20% chance of a better gem
					elif(percent in range(61,80)):
						if(rand_range(0,1)) > 0.05: # 95%
							gemID = 20
						else:
							gemID = 25 #5% best gem
					elif(percent in range(81,100)):
						if(rand_range(0,1)) > 0.2: # 80%
							gemID = 20
						else:
							gemID = 25 #20% chance of the best gem
					
					set_cell(x,y,gemID)
				

func generate_id(noise_level : float):
	if(noise_level <= -0.3):
		return -1
	else:
		return 0
		
func _physics_process(_delta: float) -> void:
	if(Input.is_action_just_pressed("debug")):
		debug = !debug
		$selector.visible = debug # show depending if we're debugging or not
		
	if(!debug) : return
	
	if(Input.is_action_just_pressed("mb_left")):
		var tile : Vector2 = world_to_map(selector.mouse_pos * 8) # gets the tile we clicked on
		var tile_id = get_cellv(tile) # returns the ID of that cell
		
		var new_id = -1
		
		if(tile_id != -1): # we clicked on a mud block
			if(tile_id < 5): # we can increase the mud block
				new_id = (tile_id +1)
			else:
				new_id = -1
			set_cellv(tile,new_id)
	
	if(Input.is_action_just_pressed("mb_right")):
		var tile : Vector2 = world_to_map(selector.mouse_pos * 8)
		set_cellv(tile,0)
		
	
