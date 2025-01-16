extends Node
class_name SaveObject

var save_file_path = "user://save/"
var save_file_name = "PlayerSave1.2.tres" #IMPORTANT!!!!! CHANGE FILE NAME FOR EVERY NEW VERSION!!!!!
var data = SaveData.new()

func _ready():
	verify_save_directory(save_file_path)

func verify_save_directory(filePath : String):
	DirAccess.make_dir_absolute(filePath)

func _load_data() -> void:
	if ResourceLoader.exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		print("loaded")
	else:
		_save_data()

func _save_data() -> void:
	ResourceSaver.save(data,save_file_path + save_file_name)
	print("saved")

func _reset() -> void:
	data.reset_all()
	_save_data()
