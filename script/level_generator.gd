extends Node

# Membuat abstract class LevelGenerator agar dapat dipanggil tanpa perlu di instance
class_name LevelGenerator

# Constant DIRECTIONS untuk menyimpan arah yang dapat digunakan oleh algoritma
const DIRECTIONS = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var position = Vector2.ZERO # Variabel untuk menyimpan posisi terkini saat algoritma bekerja. Di set default Vector2.ZERO (0,0)
var direction = Vector2.RIGHT # Variabel untuk menyimpan arah gerakan algoritma. Di set default UP
var borders = Rect2() # Variabel untuk menyimpan batas algoritma.
var step_history = [] # Variabel untuk menyimpan .
var rooms = [] # Variabel untuk menyimpan ruangan yang dibuat.
var steps_since_turn = 0 # Variabel parameter yang digunakan untuk mengubah arah algoritma.

func _init(starting_pos, new_borders):
#	print(new_borders.has_point(starting_pos))
	assert(new_borders.has_point(starting_pos)) # Mengecek apakah starting position ada dalam border. Kalau false, skip operasi.
	position = starting_pos # Set variabel position dengan posisi yang di input.
	step_history.append(position) # Menyimpan posisi pertama kedalam array.
	borders = new_borders # Membuat border baru.

func walk(steps):
	place_room(position)
	for step in steps :
		if steps_since_turn >= 12:
			change_direction()
		if step():
			step_history.append(position)
			if(step_history[step_history.size()-2] - position == Vector2(0,1) || step_history[step_history.size()-1] - position == Vector2(0,-1)):
				step_history.append(Vector2(position.x+1, position.y))
				step_history.append(Vector2(position.x+1, position.y+1))
			elif(step_history[step_history.size()-2] - position == Vector2(1,0) || step_history[step_history.size()-1] - position == Vector2(-1,0)):
				step_history.append(Vector2(position.x, position.y+1))
				step_history.append(Vector2(position.x+1, position.y+1))
		else:
			change_direction()
	return step_history

func step():
	var target_position = position + direction
	if(borders.has_point(target_position + Vector2(4,0)) && borders.has_point(target_position + Vector2(0,4)) && target_position - Vector2(4,0)) && borders.has_point(target_position - Vector2(0,4)):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_room(position):
	var size = Vector2(randi()%4+4, randi()%4+4)
	var top_left_corner = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if(borders.has_point(new_step)):
				step_history.append(new_step)

func get_end_room():
	var endRoom = rooms.pop_front()
	var startingPosition = step_history.front()
	for room in rooms:
		if(startingPosition.distance_to(room.position) > startingPosition.distance_to(endRoom.position)):
			endRoom = room
	return endRoom
