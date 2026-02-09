# GitHub Copilot Instructions

This is a **Godot 4 Top-Down Action Adventure Starter Kit** project. It provides a starting point for developing action adventure games with features like character controllers, enemy AI, cutscenes, and more.

## Tech Stack

- **Engine**: Godot 4.5
- **Language**: GDScript
- **Key Add-ons**:
  - [Beehave](https://github.com/bitbrain/beehave) - Behavior tree add-on for enemy AI
  - [Dialogic 2](https://github.com/dialogic-godot/dialogic) - Dialogue and cutscene manager

## Project Structure

```
├── assets/           # 3D models, textures, sounds, objects
├── characters/       # Player and enemy entities
│   ├── player/       # Player entity, skins, and controllers
│   ├── enemies/      # Enemy entities with behavior trees
│   └── NPC/          # Non-player characters and dialogues
├── scenes/           # Game scenes and level managers
├── tools/            # Utility scripts
│   ├── automation/   # Import and build automation tools
│   ├── debugging/    # Debug overlay and stats
│   └── state_machine/# State machine implementation
├── ui/               # UI elements, menus, and dialogic styles
└── script_templates/ # GDScript templates
```

## Architecture Patterns

### State Machine Pattern
The project uses a hierarchical state machine for character control:
- `StateMachine` - Base class that manages state transitions (`tools/state_machine/StateMachine.gd`)
- `State` - Base class for individual states (`tools/state_machine/State.gd`)
- `PlayerState` - Extended state class for player-specific states

States implement these methods:
- `enter(msg: Dictionary)` - Called when entering the state
- `exit()` - Called when leaving the state
- `process(delta)` - Called every frame
- `physics_process(delta)` - Called every physics frame
- `unhandled_input(event)` - Called for input handling

### Entity Pattern
Character entities (player, enemies) extend `CharacterBody3D`:
- `PlayerEntity` - Main player class with controller scheme support
- `EnemyEntity` - Enemy class with navigation and animation control

### Controller Architecture
Player has multiple controller schemes selectable at runtime:
- One Stick Controller (Left Stick + Buttons)
- Two Stick Controller (Left Stick move, Right Stick aim)
- Two Stick Auto-Shoot Controller

Each controller uses nested state machines for:
- Movement control (Idle, Move, Jump, Fall)
- Aiming control (Rest, Aim, Fire)

### Behavior Trees (Beehave)
Enemy AI uses Beehave behavior trees with custom nodes in `characters/enemies/melee/minion/`:
- Condition nodes: `player_is_detected.gd`, `player_is_in_reach.gd`, `health_below_zero.gd`
- Action nodes: `reach_player.gd`, `attack_player.gd`, `play_death.gd`

## Coding Conventions

### GDScript Style
- Use `class_name` for reusable classes
- Use `@onready` for node references that need the scene tree
- Use `@export` for inspector-editable properties
- Use signals for decoupled communication
- Use `snake_case` for variables and functions
- Use `PascalCase` for class names

### Example GDScript patterns:
```gdscript
class_name MyEntity
extends CharacterBody3D

# Onready variables for node references
@onready var health_manager := $HealthManager
@onready var anim_tree := $AnimationTree

# Exported properties for editor configuration
@export var movement_speed: float = 8.0
@export var rotation_speed := 12.0

# Signals for events
signal is_dead

func _ready():
    # Initialization code
    pass

func _physics_process(delta: float) -> void:
    # Physics-based updates
    pass
```

### Animation Control
Animations are controlled via `AnimationTree` with transitions:
```gdscript
func move_to_running() -> void:
    transition.xfade_time = 0.1
    anim_tree["parameters/state/transition_request"] = "Running"
```

### Navigation
Enemies use `NavigationAgent3D` for pathfinding:
```gdscript
func set_movement_target(movement_target: Vector3):
    navigation_agent.set_target_position(movement_target)
```

## Key Systems

### Health Management
- `health_manager.gd` - Centralized health tracking
- Emits signals on damage and death
- Connected to entity `on_hit()` and `on_death()` methods

### Switch System
Interactive switches that control game elements:
- `switch_hub.gd` - Central hub connecting switches to controlled objects
- `switch_component.gd` - Base switch functionality
- Types: short interaction, long interaction, area switches

### Collision Layers
```
Layer 1: player
Layer 2: world
Layer 3: bullets
Layer 4: objects
Layer 5: enemies
```

### Debug Tools
- Press `L` to toggle debug overlay
- `DebugStats` autoload for displaying runtime properties
- `DebugOverlay` for visual debugging

## Development Guidelines

1. **Scene Organization**: Keep scenes modular with reusable components
2. **Signals over Direct References**: Use signals for loose coupling between systems
3. **State Machines for Complex Behavior**: Use the state machine pattern for characters with multiple behaviors
4. **Behavior Trees for AI**: Use Beehave for enemy decision-making logic
5. **GridMap for Levels**: Levels use GridMap with NavMeshRegion for navigation

## Running the Project

1. Open in Godot 4.5
2. Ensure Beehave and Dialogic add-ons are installed in `addons/`
3. Enable plugins in Project Settings > Plugins
4. Run the main scene: `scenes/main.tscn`

## Controls

### Keyboard
- Movement: `WASD` or Arrow keys
- Jump: `Space`
- Interact: `E`
- Debug Layer: `L`

### Gamepad
- Movement: Left Stick
- Camera: Right Trigger/Left Trigger
- Interact: X button
- Pause: Start button
