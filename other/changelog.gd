extends Node

const changes = """ [b][color=aqua]Version 1.0[/color][/b]
[color=green]Changes[/color]
*Completely removed what little controller support there was, as it was outside the scope of the project
*Updated the leaderboard API
*Updated the order of cosmetics and badges in the customization menu
*Many text changes
*Waste Disposal is now locked by default
*Many visual improvements to the stage selection screen
*Reworded some text since the game is out of beta now
*The lava indicator now changes it's sprite when the next round is slime
*Lava residue and lava spawners now have unique sprites during slime rounds
*Slight code optimizations
*Lava and slime are now less intense during later rounds

[color=green]Fixes[/color]
*Fixed a bug where explosions would be rendered incorrectly
*Fixed a bug where lava could spread onto collision
*The random map button will no longer choose locked maps
*Unlocked stages will no longer become locked again when resetting stats



 [b][color=aqua]Beta 1.2.0[/color][/b]
[color=green]Additions[/color]
*The player now plays a \"squish\" animation when running into a wall
*Item pickups now sparkle to indicate that they are collectibles
*Added scorch marks
	*Appear when lava breaks a block
	*Cannot be placed on
	*Disappear after 1 round
*Added slime
	*Appears in place of lava every 5 rounds
	*Does inverse damage to blocks (ie: lots of damage to strong blocks, not so much to strong blocks)
*Added cosmetics
*Added achievements
	*14 in total
	*Can be completed to unlock cosmetics
*Added a customization menu in the settings
*Added a \"random\" button to the color customization menu
*Added an achievements menu in place of the statistics menu
	*Statistics can still be accessed from within the achievements menu
*The score info window in the leaderboard is now much more detailed
	*Tells what map a score was obtained on
	*Shows a preview of the player
*The player can now press \"R\" to start a round early, no commands necessary
	
[color=green]Changes[/color]
*Items in the leaderboard now glow when hovered over
*The 'reset' prompt in the statistics menu has been updated
*Added the coordinates of the currently targeted block to the debug/tab menu
*Now a circle appears around the player when they enter lava
*Renamed the \"Widescreen Window\" setting to \"Ignore Aspect\"
*Redesigned the controls menu
*The player is now prompted to look at the controls if it is their first time playing
*Rebalanced lava
*Blocks are now slightly more durable
*Redesigned the settings menu
*Blocks can no longer be placed in the 4 tiles adjacent to a lava spawner



 [b][color=aqua]Beta 1.1.1[/color][/b]
[color=green]Additions[/color]
*Stone and Wood now have variations
*Added a \"Cursor Transparency\" option to the settings
	*When disabled, stops the cursor from changing transparency
	
[color=green]Changes[/color]
*The landmine limit in debug mode has been upped from 10 to 15
*The Deep Mines now take on a more red color for better contrast
*Updated the hotbar sprite for landmines
*Updated the leaderboard API and project settings
	*This will either lead to a better experience or break everything
*The Enter key can now be used to make selections in menus
*The game will now use GLES2 if GLES3 is unavailable
*Improved the particles that blocks emit

[color=green]Fixes[/color]
*Fixed a bug where the block count won't be reset
*Fixed a crash that occurred when placing a landmine in debug mode
*Fixed a bug where infinite landmines could be placed in debug mode

*Despite all these fixes, landmines are still incredibly buggy when used in debug mode


 [b][color=aqua]Beta 1.1.0[/color][/b]
[color=green]Additions[/color]
*Added a new map: Waste disposal
	*In this facility, you must avoid 2 waves of lava at once
	*Lava spawners take on the appearance of pipes
*Added a \"random\" option to the stage select menu
*Added \"cmdGameOver\" as a command
	*Instantly makes a game over occur
*Added \"setintensity\" as a command
	*Sets how much damage lava does
*Added a death animations for when all lives are lost
*Various UI improvements
*Added a new map: Deep Mines
	*Takes place underground with 3 separate platforms connected by bridges
	*2 landmines randomly appear when starting the map
		*Have health bars
			*When they drop to 0, a game over occurs
		*Can be walked on freely, and blocks cannot be placed on them
		*Can only be damaged by lava

[color=green]Changes[/color]
*Stage descriptions now stick around for longer
*Lava spawners now have stage-specific sprites
*Lava spawners now show the lava inside of them if they're about to release it
*Lava residue sprites are now stage-specific
*Stage previews are now smaller
*Rounded the corners of the health bar
*The stage selection screen now uses the smaller changelog font
*Added a \"T\" value to the debug menu
	*Shows what type of tile is currently selected
*Holding shift now makes the HUD transparent
*Game overs now have a reason attached
*Commands are no longer case-sensitive
*Respawn times are now 2 seconds shorter
*Lava is now lighter in color
*The tile in the background of the boot screen is now random
*Blocks can no longer be placed within 0.5 seconds of choosing a map
*Nerfed lava

[color=green]Fixes[/color]
*Pickups can no longer spawn outside the map on Desert Plateau
*\"Pause on lost focus\" now works on the title screen
*The cursor now becomes pink when out of forcefields
*Fixed a bug where the background of the title screen would eventually scroll offscreen
*Damage from lava is no longer based on it's initial spawning position
*Fixed a bug where blocks could be placed on lava spawners
*Fixed a bug where grid spaces would become unusable


 [b][color=aqua]Beta 1.0.1[/color][/b]
[color=green]Changes[/color]
*The \"fading\" animation when the player dies is now slightly more visible
*Changed some text in the credits to specify that the soundtrack is not endorsed
*Stages can now be played by clicking on the associated picture
	*As a result, the dedicated \"play\" button has been removed
*Added a confirmation dialog when resetting statistics
*Changed the font in the changelog to be more readable
*The boot message can now be clicked to skip it
	*This still can be done with escape
*The block placement cursor now looks different depending on the context

[color=green]Fixes[/color]
*Fixed a bug where players who aren't you on the leaderboard would still show \"(You)\" next to them
*Some buttons that didn't play sounds now play sounds


 [b][color=aqua]Beta 1.0.0[/color][/b]
*Initial Release
"""
