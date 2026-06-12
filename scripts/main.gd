extends Control

var day := 1
var explored := 0

var resources := {
	"food": 80,
	"wood": 50,
	"gold": 20
}

var heroes := [
	{
		"name": "流浪战士",
		"hp": 35,
		"max_hp": 35,
		"atk": 8,
		"def": 3
	}
]

var monsters := [
	{
		"name": "野狼",
		"hp": 22,
		"atk": 5,
		"def": 1,
		"gold": 5,
		"wood": 2
	},
	{
		"name": "盗贼",
		"hp": 32,
		"atk": 7,
		"def": 2,
		"gold": 9,
		"wood": 4
	},
	{
		"name": "腐尸",
		"hp": 45,
		"atk": 9,
		"def": 3,
		"gold": 14,
		"wood": 6
	}
]

var log_box: RichTextLabel
var status_label: Label
var hero_label: Label


func _ready() -> void:
	randomize()
	_build_ui()
	_log("[b]灰烬营地建立。[/b]")
	_log("你带着一名流浪战士，在废土边缘建立了一个临时据点。")
	_log("先采集资源，然后尝试探索荒野。")
	_refresh()


func _build_ui() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var margin := MarginContainer.new()
	margin.anchor_right = 1.0
	margin.anchor_bottom = 1.0
	margin.offset_left = 16
	margin.offset_top = 16
	margin.offset_right = -16
	margin.offset_bottom = -16
	add_child(margin)

	var root := HBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(root)

	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(left)

	var title := Label.new()
	title.text = "地下文字流 Demo"
	title.add_theme_font_size_override("font_size", 24)
	left.add_child(title)

	log_box = RichTextLabel.new()
	log_box.bbcode_enabled = true
	log_box.scroll_following = true
	log_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	log_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left.add_child(log_box)

	var right := VBoxContainer.new()
	right.custom_minimum_size = Vector2(300, 0)
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(right)

	status_label = Label.new()
	status_label.text = ""
	right.add_child(status_label)

	hero_label = Label.new()
	hero_label.text = ""
	right.add_child(hero_label)

	right.add_child(_make_button("采集资源", Callable(self, "_on_gather_pressed")))
	right.add_child(_make_button("探索荒野", Callable(self, "_on_explore_pressed")))
	right.add_child(_make_button("休整治疗", Callable(self, "_on_rest_pressed")))
	right.add_child(_make_button("升级营地", Callable(self, "_on_upgrade_pressed")))


func _make_button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 44)
	button.pressed.connect(callback)
	return button


func _on_gather_pressed() -> void:
	day += 1

	var food_gain := randi_range(8, 16)
	var wood_gain := randi_range(6, 14)
	var gold_gain := randi_range(1, 4)

	resources["food"] += food_gain
	resources["wood"] += wood_gain
	resources["gold"] += gold_gain

	_log("")
	_log("[color=green]你派人外出采集。[/color]")
	_log("获得 食物 +%d，木材 +%d，金币 +%d。" % [food_gain, wood_gain, gold_gain])

	_refresh()


func _on_explore_pressed() -> void:
	if resources["food"] < 10:
		_log("")
		_log("[color=red]食物不足，无法探索。[/color]")
		return

	resources["food"] -= 10
	day += 1

	var monster_index: int = mini(int(explored / 3), monsters.size() - 1)
	var monster: Dictionary = monsters[monster_index].duplicate(true)

	_log("")
	_log("[b]你进入荒野深处。[/b]")
	_log("遭遇敌人：%s。" % monster["name"])

	var victory := _fight(monster)

	if victory:
		explored += 1
		resources["gold"] += int(monster["gold"])
		resources["wood"] += int(monster["wood"])

		_log("[color=yellow]战斗胜利。[/color]")
		_log("获得 金币 +%d，木材 +%d。" % [monster["gold"], monster["wood"]])

		if explored % 3 == 0:
			_level_up_hero()
	else:
		_log("[color=red]战斗失败。你的队伍撤回了营地。[/color]")

	_refresh()


func _fight(monster: Dictionary) -> bool:
	var round := 0
	var monster_hp := int(monster["hp"])

	while int(heroes[0]["hp"]) > 0 and monster_hp > 0 and round < 20:
		round += 1

		var hero_damage: int = maxi(1, int(heroes[0]["atk"]) - int(monster["def"]))
		monster_hp -= hero_damage
		_log("第 %d 回合：%s 对 %s 造成 %d 伤害。" % [
			round,
			heroes[0]["name"],
			monster["name"],
			hero_damage
		])

		if monster_hp <= 0:
			break

		var monster_damage: int = maxi(1, int(monster["atk"]) - int(heroes[0]["def"]))
		heroes[0]["hp"] = maxi(0, int(heroes[0]["hp"]) - monster_damage)

		_log("%s 反击，造成 %d 伤害。" % [
			monster["name"],
			monster_damage
		])

	return monster_hp <= 0


func _on_rest_pressed() -> void:
	if resources["gold"] < 5:
		_log("")
		_log("[color=red]金币不足，无法休整。[/color]")
		return

	resources["gold"] -= 5
	heroes[0]["hp"] = heroes[0]["max_hp"]

	_log("")
	_log("[color=cyan]队伍完成休整，生命恢复。[/color]")

	_refresh()


func _on_upgrade_pressed() -> void:
	if resources["wood"] < 40 or resources["gold"] < 15:
		_log("")
		_log("[color=red]升级营地需要 木材 40、金币 15。[/color]")
		return

	resources["wood"] -= 40
	resources["gold"] -= 15

	heroes[0]["max_hp"] += 5
	heroes[0]["hp"] = heroes[0]["max_hp"]
	heroes[0]["atk"] += 1
	heroes[0]["def"] += 1

	_log("")
	_log("[color=orange]营地升级完成。[/color]")
	_log("战士获得更好的补给：生命、攻击、防御提升。")

	_refresh()


func _level_up_hero() -> void:
	heroes[0]["max_hp"] += 4
	heroes[0]["atk"] += 1
	heroes[0]["hp"] = heroes[0]["max_hp"]

	_log("")
	_log("[color=yellow]%s 经历战斗后变强了。[/color]" % heroes[0]["name"])
	_log("最大生命 +4，攻击 +1。")


func _refresh() -> void:
	status_label.text = "第 %d 天\n\n资源\n食物：%d\n木材：%d\n金币：%d\n\n探索进度：%d" % [
		day,
		resources["food"],
		resources["wood"],
		resources["gold"],
		explored
	]

	hero_label.text = "\n队伍\n%s\n生命：%d / %d\n攻击：%d\n防御：%d" % [
		heroes[0]["name"],
		heroes[0]["hp"],
		heroes[0]["max_hp"],
		heroes[0]["atk"],
		heroes[0]["def"]
	]


func _log(text: String) -> void:
	log_box.append_text(text + "\n")
