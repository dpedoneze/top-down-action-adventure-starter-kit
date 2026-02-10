# Testing Guide

This directory contains unit tests for the Top-Down Action Adventure Starter Kit using GUT (Godot Unit Test).

## Prerequisites

### Installing GUT (Godot Unit Test)

1. Open the project in Godot 4.5
2. Go to **AssetLib** (top menu)
3. Search for "GUT" or "Godot Unit Test"
4. Download and install the GUT addon (version 9.x for Godot 4.x)
5. Enable the plugin in **Project > Project Settings > Plugins**

Alternatively, you can install GUT manually:
1. Download GUT from [GitHub](https://github.com/bitwes/Gut/releases)
2. Extract the `addons/gut` folder into your project's `addons/` directory
3. Enable the plugin in Project Settings

## Test Structure

```
tests/
├── .gutconfig.json    # GUT configuration file
├── README.md          # This file
└── unit/              # Unit tests
    ├── test_health_manager.gd    # Health system tests
    ├── test_state_machine.gd     # State machine tests
    ├── test_state.gd             # State base class tests
    └── test_switch_component.gd  # Switch system tests
```

## Running Tests

### From Godot Editor

1. Open the GUT panel (bottom dock or **Project > Tools > GUT**)
2. Click **Run All** to run all tests
3. Or select specific test files to run individual test suites

### From Command Line

```bash
# Run all tests
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit -gexit

# Run specific test file
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_health_manager.gd -gexit

# Run with verbose output
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit -gexit -glog=2
```

### CI/CD Integration

This repository includes a GitHub Actions workflow (`.github/workflows/tests.yml`) that automatically runs tests on:
- Push to `main` or `master` branches
- Pull requests targeting `main` or `master` branches
- Manual workflow dispatch

The workflow:
1. Sets up Godot 4.5 using `chickensoft-games/setup-godot` action
2. Downloads and installs the GUT addon
3. Imports the Godot project
4. Runs all unit tests

For other CI systems, use:

```yaml
- name: Run Tests
  run: |
    godot --headless -s addons/gut/gut_cmdln.gd \
      -gdir=res://tests/unit \
      -gexit \
      -glog=1
```

## Writing Tests

### Test File Naming

- Test files must start with `test_` prefix (e.g., `test_my_feature.gd`)
- Test files must have `.gd` suffix

### Test Method Naming

- Test methods must start with `test_` prefix
- Example: `func test_health_decreases_on_damage():`

### GUT Test Structure

```gdscript
extends GutTest

var my_object

func before_each():
    # Setup code - runs before each test
    my_object = MyClass.new()
    add_child_autofree(my_object)

func after_each():
    # Cleanup code - runs after each test
    pass

func test_something():
    # Your test code
    assert_eq(my_object.value, expected_value, "Description of what's being tested")
```

### Common Assertions

```gdscript
assert_eq(a, b, "message")        # Assert equality
assert_ne(a, b, "message")        # Assert not equal
assert_true(condition, "message") # Assert true
assert_false(condition, "message")# Assert false
assert_null(value, "message")     # Assert null
assert_not_null(value, "message") # Assert not null
assert_signal_emitted(obj, "signal_name", "message")  # Assert signal was emitted
```

### Signal Testing

```gdscript
func test_signal_emitted():
    watch_signals(my_object)
    my_object.do_something()
    assert_signal_emitted(my_object, "my_signal")
```

## Test Coverage

Current test coverage includes:

- **HealthManager**: Health points, damage, healing, signals
- **StateMachine**: State transitions, signals, state tracking
- **State**: Enter/exit lifecycle, signal emissions, state machine references
- **SwitchComponent**: Activation states, inversed signals, interaction handling

## Adding New Tests

1. Create a new file in `tests/unit/` with the `test_` prefix
2. Extend `GutTest`
3. Add `before_each()` for setup
4. Write test methods starting with `test_`
5. Run tests to verify they pass

## Troubleshooting

### Tests not appearing in GUT panel
- Ensure test files have `test_` prefix
- Ensure test files are in the configured test directory
- Restart Godot Editor

### "GutTest not found" error
- Make sure GUT addon is installed in `addons/gut/`
- Enable the GUT plugin in Project Settings

### Signal tests failing
- Call `watch_signals()` before the action that triggers the signal
- Verify signal names match exactly (case-sensitive)
