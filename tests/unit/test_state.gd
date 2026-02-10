extends GutTest
## Unit tests for State
##
## Tests the base State class functionality including
## signals and parent state relationships.

var state: State
var parent_state: State
var state_machine: StateMachine


func before_each():
	# Create a state machine structure
	state_machine = StateMachine.new()
	state_machine.name = "TestStateMachine"
	
	# Create states
	state = State.new()
	state.name = "TestState"
	
	state_machine.add_child(state)
	state_machine.initial_state = NodePath("TestState")
	
	add_child_autofree(state_machine)
	await get_tree().process_frame


func test_state_has_state_machine_reference():
	# The state should have a reference to its state machine
	assert_not_null(state._state_machine, "State should have a reference to state machine")


func test_enter_emits_signal():
	watch_signals(state)
	state.enter()
	assert_signal_emitted(state, "enter_state", "enter_state signal should be emitted")


func test_exit_emits_signal():
	watch_signals(state)
	state.exit()
	assert_signal_emitted(state, "exit_state", "exit_state signal should be emitted")


func test_enter_accepts_message_dict():
	# Should not throw error when called with message
	state.enter({"test_key": "test_value"})
	assert_true(true, "enter() should accept message dictionary")


func test_enter_accepts_empty_dict():
	# Should not throw error when called without message
	state.enter()
	assert_true(true, "enter() should accept empty dictionary")


func test_process_method_exists():
	# Process should not throw error
	state.process(0.016)
	assert_true(true, "process() method should exist and run")


func test_physics_process_method_exists():
	# Physics process should not throw error
	state.physics_process(0.016)
	assert_true(true, "physics_process() method should exist and run")


func test_unhandled_input_method_exists():
	# Create a mock input event
	var event = InputEventKey.new()
	state.unhandled_input(event)
	assert_true(true, "unhandled_input() method should exist and run")


func test_parent_state_null_when_direct_child_of_state_machine():
	# When state is direct child of state machine, _parent should be null
	assert_null(state._parent, "Parent should be null when direct child of state machine")


func test_get_state_machine_returns_state_machine():
	var found_sm = state._get_state_machine(state)
	assert_eq(found_sm, state_machine, "_get_state_machine should return the state machine")


func test_get_state_machine_returns_null_for_null_node():
	var found_sm = state._get_state_machine(null)
	assert_null(found_sm, "_get_state_machine should return null for null input")
