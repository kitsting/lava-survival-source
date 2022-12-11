# Lava Survival Source Code

## What is this?
This is the source code for a game I made using Godot Engine. The project should work right away if you download it and use it in the latest version of Godot 3. The game itself can be found at https://ksting.itch.io/lava-survival

## What's not included in this repository
The scoreboard system has been disabled. The plugin I used to implement this system can be found at https://silentwolf.com/
The code for the scoreboard system still exists, but is commented out. The plugin has been completely removed, so if you want to restore functionality, you need to reinstall it and put it in the "addons" folder.
The music has also been replaced by silence.
Other than these things, everything is still intact.

## Using
Simply download/pull this repository and open the project.godot file using Godot 3.x (3.5 is recommended).
There's an issue where the UI elements don't show up properly. To fix this, open other/DefaultTheme.tres in the editor and manually assign sprites to each relevant UI element. The sprites can be found in sprites/ui/<element_name>.
There aren't any other issues as far as I'm aware.
