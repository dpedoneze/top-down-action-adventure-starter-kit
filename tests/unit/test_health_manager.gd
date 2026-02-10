extends GutTest
## Unit tests for HealthManager
##
## Tests the health system functionality including damage, healing,
## and signal emissions.

var health_manager: Node


func before_each():
	health_manager = preload("res://health_manager.gd").new()
	health_manager.max_health = 6
	health_manager.start_health = 6
	health_manager.ui_hearts = []
	add_child_autofree(health_manager)
	# Wait for ready to complete
	await get_tree().process_frame


func test_initial_health_equals_start_health():
	assert_eq(health_manager.health_points, 6, "Initial health should equal start_health")


func test_get_damage_reduces_health():
	var initial_health = health_manager.health_points
	health_manager.get_damage(2)
	assert_eq(health_manager.health_points, initial_health - 2, "Health should be reduced by damage amount")


func test_get_damage_cannot_go_below_zero():
	health_manager.get_damage(100)
	assert_eq(health_manager.health_points, 0, "Health should not go below 0")


func test_get_health_increases_health():
	health_manager.health_points = 2
	health_manager.get_health(2)
	assert_eq(health_manager.health_points, 4, "Health should increase by heal amount")


func test_get_health_cannot_exceed_max():
	health_manager.health_points = 5
	health_manager.get_health(10)
	assert_eq(health_manager.health_points, health_manager.max_health, "Health should not exceed max_health")


func test_get_full_health_restores_max():
	health_manager.health_points = 1
	health_manager.get_full_health()
	assert_eq(health_manager.health_points, health_manager.max_health, "get_full_health should restore to max")


func test_instant_death_sets_health_to_zero():
	health_manager.instant_death()
	assert_eq(health_manager.health_points, 0, "instant_death should set health to 0")


func test_health_changed_signal_emitted_on_damage():
	watch_signals(health_manager)
	health_manager.get_damage(1)
	assert_signal_emitted(health_manager, "health_changed", "health_changed signal should be emitted on damage")


func test_health_depleted_signal_emitted_at_zero():
	watch_signals(health_manager)
	health_manager.instant_death()
	assert_signal_emitted(health_manager, "health_depleted", "health_depleted signal should be emitted when health reaches 0")


func test_damage_signal_emitted_on_get_damage():
	watch_signals(health_manager)
	health_manager.get_damage(1)
	assert_signal_emitted(health_manager, "damage", "damage signal should be emitted when taking damage")


func test_health_replenished_signal_at_max():
	health_manager.health_points = 5
	watch_signals(health_manager)
	health_manager.get_health(1)
	assert_signal_emitted(health_manager, "health_replenished", "health_replenished signal should be emitted at max health")


func test_multiple_damage_events():
	health_manager.get_damage(1)
	health_manager.get_damage(2)
	health_manager.get_damage(1)
	assert_eq(health_manager.health_points, 2, "Multiple damage events should stack correctly")
