extends GutTest
## Unit tests for StateMachine
##
## Tests the state machine functionality including state transitions
## and signal emissions.

var state_machine: StateMachine
var mock_state_1: State
var mock_state_2: State


func before_each():
	# Create state machine
	state_machine = StateMachine.new()
	state_machine.name = "TestStateMachine"
	
	# Create mock states
	mock_state_1 = State.new()
	mock_state_1.name = "State1"
	
	mock_state_2 = State.new()
	mock_state_2.name = "State2"
	
	# Build the hierarchy
	state_machine.add_child(mock_state_1)
	state_machine.add_child(mock_state_2)
	
	# Set initial state path
	state_machine.initial_state = NodePath("State1")
	
	add_child_autofree(state_machine)
	await get_tree().process_frame


func test_initial_state_is_set():
	# After ready, state machine should have the initial state
	assert_not_null(state_machine.state, "State machine should have a current state")


func test_state_machine_in_group():
	assert_true(state_machine.is_in_group("state_machine"), "State machine should be in 'state_machine' group")


func test_transition_to_changes_state():
	# Transition to State2
	state_machine.transition_to("State2")
	assert_eq(state_machine.state.name, "State2", "State should change to State2")


func test_transition_emits_signal():
	watch_signals(state_machine)
	state_machine.transition_to("State2")
	assert_signal_emitted(state_machine, "transitioned", "transitioned signal should be emitted")


func test_transition_to_same_state():
	state_machine.transition_to("State1")
	assert_eq(state_machine.state.name, "State1", "Should be able to transition to the same state")


func test_state_name_tracking():
	state_machine.transition_to("State2")
	assert_eq(state_machine._state_name, "State2", "Internal state name should track current state")


func test_has_node_check_for_invalid_state():
	# This tests the assertion but we can only verify it doesn't crash with valid states
	assert_true(state_machine.has_node("State1"), "Should have State1 node")
	assert_true(state_machine.has_node("State2"), "Should have State2 node")
	assert_false(state_machine.has_node("NonExistent"), "Should not have NonExistent node")
