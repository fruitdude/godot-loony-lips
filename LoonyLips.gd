extends Control

#lets see if git regocnizes that this file got changed
#test test test test

var player_words = []
var current_story = {}
var introduction = "Welcome to LoonyLips,\ntype in some words\n\n"

onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText = $VBoxContainer/DisplayText
onready var ButtonText = $VBoxContainer/HBoxContainer/Label


func _ready():
	set_current_story()
	DisplayText.text = introduction
	check_player_words_length()


func set_current_story():
	#var stories = get_from_jason("StoryBook.json")
	randomize()
	#current_story = stories[randi() % stories.size()]
	var stories = $StoryBook.get_child_count()
	var selected_story = randi() % stories
	current_story.prompts = $StoryBook.get_child(selected_story).prompts
	current_story.story = $StoryBook.get_child(selected_story).story

#func get_from_jason(filename):
#	var file = File.new()
#	file.open(filename, File.READ)
#	var text = file.get_as_text()
#	var data = parse_json(text)
#	file.close()
#	return data

func _on_PlayerText_text_entered(new_text):
	add_to_player_words()


func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		add_to_player_words()


func add_to_player_words():
	#adds new words to the player_words array from the playertext
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()


func is_story_done():
	#returns true when the playr word size is as large as the prompt size
	return player_words.size() == current_story.prompts.size()


func check_player_words_length():
	PlayerText.grab_focus()
	if is_story_done():
		end_game()
	else:
		prompt_player()


func tell_story():
	DisplayText.text = current_story.story % player_words


func prompt_player():
	DisplayText.text += "May I have " + current_story.prompts[player_words.size()] + " please?"


func end_game():
	PlayerText.queue_free()
	ButtonText.text = "again?"
	tell_story()
