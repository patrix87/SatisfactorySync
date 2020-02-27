# Satisfactory game sharing synchronization script.

Hi,

This script was originally made for me and I wasn't intending to share it so it's not the cleanest but it works.

I hope you enjoy it.

# What you need : 

- A shared cloud folder with write access with your friends like Google Drive / One Drive / Dropbox etc.
- The Google Drive / One Drive / Dropbox etc, desktop application to sync the folder.
- Some very basic skills in scripting *(changing paths in variables)

# What it does : 

This script will take you local save file and compare it with a cloud shared file and if the cloud file is more recent it will zip your local file and make a backup of it then replace it file with the cloud file. If the local file is more recent it will zip the cloud file and make a backup of it and them replace it with the local file.

# How to configure it : 

- Once you have downloaded the repository extract it directly in your cloud synced folder 
*not just the script, the 7z and the other 2 empty folder as well.*
- Each user should then copy the content of the script folder somewhere on their computer.
- Once you have your own copy of the script folder you must adjust the different paths and variables to match your local configuration. *(Details in the .ps1 script itself.)*
- Disable cloud save in the Epic Games Launcher.
- Start a new game or save an existing game with the name **SharedGame** *(you can change that name in the script.)*

# How to use it : 

- Before you start your gaming session check if you're the first to launch the game. If so then you'll be the host.
- Run the script to check if the cloud file was updated.
- Launch the game
- Load the **SharedGame** save file.
- Other players will then join you.
- Before you leave, save the game with the name **SharedGame** and overwrite the previous save with that name.
- Close the game and run the script again to sync the most up to date version to the cloud.
- The next person to host the game should then wait for the save to sync and run the script on their end to update their local file.

# DISCLAIMER !

Since this script was meant to be used only by me I do not take any responsibility for anything that happens because of it.

## Security consideration 

Understand that running a cloud hosted PowerShell script on your local computer represent a major security risk. If anyone modify the script they could easily break your computer or way worse. Always copy the script locally and verify it before your run it for the first time. Note that the 7zip files could also be tempered with so you might as well make your own local copy of them to avoid that. *you'll have to edit your copy of the script to match the paths*