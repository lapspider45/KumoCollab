extends Control

signal dialog_over
var speaker := []
@export var dialog_script := "test_dialog"
var _dialogue: ClydeDialogue
var is_text_animating := false
var skip := false


func _ready():
	for i in get_tree().get_nodes_in_group("dialog_animation"):
		i.play("move_in")
	await get_tree().create_timer(0.5).timeout
	_dialogue = ClydeDialogue.new()
	_dialogue.load_dialogue("test_dialog")
	_dialogue.event_triggered.connect(_on_event_triggered)
	_dialogue.variable_changed.connect(_on_variable_changed)
	_get_next_dialogue_line()


func _physics_process(delta):
	if Input.is_action_just_released("shoot"):
		if is_text_animating:
			is_text_animating = false
			return
		_get_next_dialogue_line()
	if Input.is_action_pressed("bomb"):
		skip = true
		_get_next_dialogue_line()


func _get_next_dialogue_line():
	if _dialogue == null:
		return
	var content = _dialogue.get_content()
	if not content:
		var dialog_animation_group = get_tree().get_nodes_in_group("dialog_animation")
		for i in 3:
			dialog_animation_group[i].play( "move_in", -1, -1.0, true )
		await dialog_animation_group[2].animation_finished
		emit_signal("dialog_over")
		queue_free()
		return
	
	if content.type == "line":
		_set_up_line(content)
	else:
		#branching storyline?
		print(content.type)


func _set_up_line(content):
	var is_speaker1 = speaker[0] == content.get("speaker")
	if $TextBox/Speaker1Name.visible != is_speaker1 or $TextBox/Speaker1Name.visible == $TextBox/Speaker2Name.visible: 
		var offset = 0 if is_speaker1 else 1
		get_tree().get_nodes_in_group("dialog_animation")[0 + offset].play("fade_in")
		get_tree().get_nodes_in_group("dialog_animation")[1 - offset].play("fade_in", -1, -1.0, true)
	$TextBox/Speaker1Name.visible = is_speaker1
	$TextBox/Speaker2Name.visible = not is_speaker1
	$TextBox/Text.text = content.text
	$TextBox/Text.visible_characters = 0
	
	var length :int = content.text.length()
	is_text_animating = true
	for i in length:
		$TextBox/Text.visible_characters = i
		await get_tree().create_timer(0.005).timeout
		if not is_text_animating:
			$TextBox/Text.visible_characters = length
			break
	is_text_animating = false


func _on_event_triggered(event_name):
	print("Event received: %s" % event_name)


func _on_variable_changed(_variable_name, new_value, _previous_value):
	speaker.append(new_value)
	get_tree().get_nodes_in_group("speaker_label")[speaker.size() - 1].text = new_value
