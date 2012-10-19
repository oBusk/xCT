@ECHO OFF
ECHO ________________________________________
luac -l -p .\..\xCT+\core.lua | lua globals.lua .\..\xCT+\core.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\init.lua | lua globals.lua .\..\xCT+\init.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\config\profile.lua | lua globals.lua .\..\xCT+\config\profile.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\media\colors.lua | lua globals.lua .\..\xCT+\media\colors.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\media\media.lua | lua globals.lua .\..\xCT+\media\media.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\modules\blizzard.lua | lua globals.lua .\..\xCT+\modules\blizzard.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\modules\combattext.lua | lua globals.lua .\..\xCT+\modules\combattext.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\modules\frames.lua | lua globals.lua .\..\xCT+\modules\frames.lua
ECHO ________________________________________
luac -l -p .\..\xCT+\modules\options.lua | lua globals.lua .\..\xCT+\modules\options.lua

ECHO ========================================
ECHO  DUMP FINISHED
ECHO ========================================