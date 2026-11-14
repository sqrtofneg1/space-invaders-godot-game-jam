# Space Invaders
This is a spacee invaders boilerplate project for the second Blastworks Juice Jam.

## Scenes
The project features 3 scenes:
* components/enemy
	* 128px by 32px enemy sprite
	* "Enemy" collision layer
	* Shoot SFX
* components/player
	* 128px by 48px player sprite
	* "Player" collision layer
	* Mask for "Default" collision layer to stop going off the screen
	* Marker for spawn position of projectiles
	* Shoot SFX
	* Timer for shoot cooldown
* components/projectile
	* 16px by 64px projectile sprite
	* "Projectile" collision layer
	* No mask
* game
	* Background CanvasLayer for BG color and announcement text
	* Timer for delay before restarting the game on win/lose condition
	* Timer for how often enemies will randomly shoot
	* Container for holding enemies
	* Player
	* Left and right wall boundaries
		* These use a WorldBoundaryShape2D shape (infinite line with a direction)
	* Hit SFX
		* This is for enemies being hit so it persists after free'ing
	* Victory SFX

## Scripts
The project features 4 scripts that correspond to the 4 scenes:
* Enemy
	* Shoot method (called by game on a random enemy)
	* Hit method (called by projectile on collision)
* Player
	* Can move left and right via input
	* Shoots a projectile on input
	* Hit method (called by projectile on collision)
* Game
	* Hooks up all enemies found in the enemy container node
	* Gets a random enemy to shoot every X seconds (controlled by timer signal)
	* Victory if all enemies destroyed
	* Game over if player destroyed
	* Note: if player and all enemies are destroyed it's whatever happens first

## Project Settings
The following project settings were set:
* Project name is "Space Invaders"
* Default scene is the Game scene
* Has `move_left`, `move_right`, and `shoot` input actions
	* Keyboard and controller
* Viewport is 1920x1080
* Window size is 1280x720
* Window stretch mode set to "canvas_items"
	* Scales with black bars for maintaining 16x9 aspect ratio
* Physics layers
	* 1 - Default
	* 2 - Player
	* 3 (4) - Enemy
	* 4 (8) - Projectile
