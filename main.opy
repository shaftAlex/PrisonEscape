settings "settings.json"

#!extension spawnMoreDummyBots

#!define DEBUG true

#!include "debug.opy"
#!include "map.opy"
#!include "player.opy"
#!include "bastion.opy"

rule "globalInit":
    disableAnnouncer()
    disableGamemodeCompletion()
    disableInspector()
    disableMusic()
    disableScoring()
