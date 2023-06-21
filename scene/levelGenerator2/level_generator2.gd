extends Node2D

const ROOM_COORDINATE = {
	0: Vector2(500, 400),
	1: Vector2(1650, 400),
	2: Vector2(2800, 400),
	3: Vector2(500, 1300),
	4: Vector2(1650, 1300),
	5: Vector2(2800, 1300),
	6: Vector2(500, 2200),
	7: Vector2(1650, 2200),
	8: Vector2(2800, 2200)
}

# Dipake buat DFS
var adjacent_list = {
	0: [1, 3],
	1: [0, 2, 4],
	2: [1, 5],
	3: [0, 4, 6],
	4: [1, 3, 5, 7],
	5: [2, 4, 8],
	6: [3, 7],
	7: [4, 6, 8],
	8: [5, 7]
}
# ===============

# ================== DFS =====================
func dfs(pos, vis):
	vis.append(pos)

	if (vis.size() == 9 && vis[0]%2 != 1) || vis.size() == 10:
		return vis
	
	if pos%2 == 1 && vis.size() == 1:
		var shuffled_arr = adjacent_list[pos]
		shuffled_arr.shuffle()
		vis.append(shuffled_arr[0])
		vis.append(pos)

	var shuffled_arr = adjacent_list[pos]
	shuffled_arr.shuffle()
	for adj in shuffled_arr:
		if !vis.has(adj):
			print(vis)
			var result = dfs(adj, vis)
			if result != null:
				return result

	vis.pop_back()
	return null

func find_valid_path(start_room):
	var visited_rooms = []
	var path = dfs(start_room, visited_rooms)
	return path
# ===========================================

# ======= Room Coordinate Generator =========
func create_room(size):
	return Rect2(Vector2(0,0), size)

func translate_coordinate(translated_coordinate, offset):
	var transform_matrix = Transform2D(Vector2(1,0), Vector2(0,1), translated_coordinate)
	return transform_matrix.translated(offset)[2]

func generate_room_array():
	var rooms:Array
	var size = Vector2(16,12)
	
	var temp_room
	
	for i in range(0,3):
		for j in range(0,3):
			temp_room = create_room(size)
			temp_room.position = translate_coordinate(temp_room.position, Vector2(18*j, 14*i))
			rooms.append(temp_room)
	return rooms
# ===========================================

# ============ Map Generator ================
func laid_foundation():
	var foundation = Rect2(Vector2(-4, -4), Vector2(58,46))
	for y in range(foundation.position.y, foundation.end.y+1):
		for x in range(foundation.position.x, foundation.end.x+1):
			$grass_wall.set_cell(x, y, 0)
	$grass_wall.update_bitmask_region()

func carving_room(room_path:Array, room_coordinate:Array):
	for room_order in room_path:
		for y in range(room_coordinate[room_order].position.y, room_coordinate[room_order].end.y):
			for x in range(room_coordinate[room_order].position.x, room_coordinate[room_order].end.x):
				$grass_wall.set_cell(x, y, 1)
		
		if room_order != room_path[0]:
			var room_before = room_path[room_path.find(room_order)-1]
			if (room_coordinate[room_order].position.x > room_coordinate[room_before].position.x) && (room_coordinate[room_order].position.y == room_coordinate[room_before].position.y):
				$grass_wall.set_cell(room_coordinate[room_order].position.x-1, room_coordinate[room_order].position.y+12/2, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x-1, room_coordinate[room_order].position.y+12/2+1, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x-2, room_coordinate[room_order].position.y+12/2, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x-2, room_coordinate[room_order].position.y+12/2+1, 1)
				print("set kanan"," ",room_before," ",room_order)
			elif (room_coordinate[room_order].position.x < room_coordinate[room_before].position.x) && (room_coordinate[room_order].position.y == room_coordinate[room_before].position.y):
				$grass_wall.set_cell(room_coordinate[room_order].end.x, room_coordinate[room_order].end.y+12/2-12, 1)
				$grass_wall.set_cell(room_coordinate[room_order].end.x, room_coordinate[room_order].end.y+12/2+1-12, 1)
				$grass_wall.set_cell(room_coordinate[room_order].end.x+1, room_coordinate[room_order].end.y+12/2-12, 1)
				$grass_wall.set_cell(room_coordinate[room_order].end.x+1, room_coordinate[room_order].end.y+12/2+1-12, 1)
				print("set kiri"," ",room_before," ",room_order)
			elif (room_coordinate[room_order].position.y > room_coordinate[room_before].position.y) && (room_coordinate[room_order].position.x == room_coordinate[room_before].position.x):
				$grass_wall.set_cell(room_coordinate[room_order].position.x+8, room_coordinate[room_order].position.y-1, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x+7, room_coordinate[room_order].position.y-1, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x+8, room_coordinate[room_order].position.y-2, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x+7, room_coordinate[room_order].position.y-2, 1)
			elif (room_coordinate[room_order].position.y < room_coordinate[room_before].position.y) && (room_coordinate[room_order].position.x == room_coordinate[room_before].position.x):
				$grass_wall.set_cell(room_coordinate[room_order].position.x+8, room_coordinate[room_order].end.y, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x+7, room_coordinate[room_order].end.y, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x+8, room_coordinate[room_order].end.y+1, 1)
				$grass_wall.set_cell(room_coordinate[room_order].position.x+7, room_coordinate[room_order].end.y+1, 1)
	$grass_wall.update_bitmask_region()
# ===========================================

func _ready():
	# Bikin path pake DFS
	randomize()
	print(find_valid_path(randi()%8))

	laid_foundation()
	carving_room(find_valid_path(randi()%8+1), generate_room_array())
	
	$Player.position = ROOM_COORDINATE[0]
	$EnemyGenerator.position = ROOM_COORDINATE[0]
	$EnemyGenerator2.position = ROOM_COORDINATE[1]
	$EnemyGenerator3.position = ROOM_COORDINATE[2]
	$EnemyGenerator4.position = ROOM_COORDINATE[3]
	$EnemyGenerator5.position = ROOM_COORDINATE[4]
	$EnemyGenerator6.position = ROOM_COORDINATE[5]
	$EnemyGenerator7.position = ROOM_COORDINATE[6]
	$Portal.position = ROOM_COORDINATE[8]
	
	$Portal.connect("player_entered", self, "changeRoom")
	
	$FadeScreen.fadeOut()
	
func changeRoom():
	$FadeScreen.fadeIn()
	GameManager.currentLevel += 1
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().reload_current_scene()
