#!mainFile "main.opy"

rule "debug":
    @Event eachPlayer
    @Team 1
    @Condition DEBUG

    hudSubheader(eventPlayer, f"Position: {eventPlayer.getPosition().x}, {eventPlayer.getPosition().y}, {eventPlayer.getPosition().z}", HudPosition.ACTUALLY_LEFT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, f"Facing Direction: {eventPlayer.getFacingDirection().x}, {eventPlayer.getFacingDirection().y}, {eventPlayer.getFacingDirection().z}", HudPosition.ACTUALLY_LEFT, 0, Color.WHITE, HudReeval.STRING)

    hudSubheader(eventPlayer, f"Server Load: {getServerLoad()}    Avg: {getAverageServerLoad()}    Peak: {getPeakServerLoad()}", HudPosition.ACTUALLY_LEFT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, f"Entity Count: {getNumberOfEntityIds()}    Text Count: {getNumberOfTextIds()}", HudPosition.ACTUALLY_LEFT, 0, Color.WHITE, HudReeval.STRING)
