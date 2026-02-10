extends GutTest
## Unit tests for SwitchComponent
##
## Tests the switch component functionality including
## activation states and signal emissions.

var switch_component: SwitchComponent


func before_each():
	switch_component = SwitchComponent.new()
	add_child_autofree(switch_component)
	await get_tree().process_frame


func test_default_not_activated():
	assert_false(switch_component.is_activated, "Switch should not be activated by default")


func test_activation_changes_state():
	switch_component.is_activated = true
	assert_true(switch_component.is_activated, "Switch should be activated after setting")


func test_deactivation_changes_state():
	switch_component.is_activated = true
	switch_component.is_activated = false
	assert_false(switch_component.is_activated, "Switch should be deactivated after setting")


func test_activation_emits_signal():
	watch_signals(switch_component)
	switch_component.is_activated = true
	assert_signal_emitted(switch_component, "activation_signal", "activation_signal should be emitted")


func test_activation_signal_value_normal():
	# With inversed_signal = false, signal should match activation state
	switch_component.inversed_signal = false
	var received_value = null
	switch_component.activation_signal.connect(func(val): received_value = val)
	switch_component.is_activated = true
	assert_true(received_value, "Signal should emit true when activated (not inversed)")


func test_activation_signal_value_inversed():
	# With inversed_signal = true, signal should be opposite of activation state
	switch_component.inversed_signal = true
	var received_value = null
	switch_component.activation_signal.connect(func(val): received_value = val)
	switch_component.is_activated = true
	assert_false(received_value, "Signal should emit false when activated (inversed)")


func test_deactivation_signal_value_normal():
	switch_component.inversed_signal = false
	switch_component.is_activated = true
	var received_value = null
	switch_component.activation_signal.connect(func(val): received_value = val)
	switch_component.is_activated = false
	assert_false(received_value, "Signal should emit false when deactivated (not inversed)")


func test_deactivation_signal_value_inversed():
	switch_component.inversed_signal = true
	switch_component.is_activated = true
	var received_value = null
	switch_component.activation_signal.connect(func(val): received_value = val)
	switch_component.is_activated = false
	assert_true(received_value, "Signal should emit true when deactivated (inversed)")


func test_default_inversed_switch_false():
	assert_false(switch_component.inversed_switch, "inversed_switch should be false by default")


func test_default_inversed_signal_false():
	assert_false(switch_component.inversed_signal, "inversed_signal should be false by default")


func test_on_interaction_method_exists():
	# on_interaction should not throw error
	switch_component.on_interaction(true)
	switch_component.on_interaction(false)
	assert_true(true, "on_interaction() method should exist and run")


func test_getter_returns_activation_state():
	switch_component.is_activated = true
	assert_true(switch_component.is_activated, "Getter should return current activation state")
	switch_component.is_activated = false
	assert_false(switch_component.is_activated, "Getter should return updated activation state")
