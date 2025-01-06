extends Node
class_name SaveObject

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.tres"
var saveData = SaveData.new()

func _ready():
	verify_save_directory(save_file_path)

func verify_save_directory(filePath : String):
	DirAccess.make_dir_absolute(filePath)

func _load_data() -> void:
	if ResourceLoader.exists(save_file_path + save_file_name):
		saveData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		print("loaded")

func _save_data() -> void:
	ResourceSaver.save(saveData,save_file_path + save_file_name)
	print("saved")

func _reset() -> void:
	saveData.resetAll()
	_save_data()
