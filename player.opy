#!mainFile "main.opy"

playervar avgPosition
playervar deathCount = 0
playervar deathEffect = false
playervar heroIndex = 0
playervar heroArray = []
playervar isHelper = false

subroutine enableDeathEffect
subroutine disableDeathEffect
subroutine nextHero
subroutine becomeHelper

rule "playerInit":
    @Event eachPlayer
    @Team 1

    eventPlayer.disableGamemodeHud()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableKillFeed()
    eventPlayer.disableRespawn()
    eventPlayer.disableScoreboard()

    eventPlayer.heroArray = random.shuffle(getAllHeroes())
    eventPlayer.startForcingHero(eventPlayer.heroArray[eventPlayer.heroIndex])
    eventPlayer.respawn()

    hudSubtext(eventPlayer, f"Hero: {eventPlayer.heroIndex + 1}/43", HudPosition.RIGHT, 0, Color.YELLOW, HudReeval.STRING)
    hudSubtext(eventPlayer, f"Next Hero: {eventPlayer.heroArray[eventPlayer.heroIndex + 1]}", HudPosition.RIGHT, 0, Color.GREEN, HudReeval.STRING)
    hudSubtext(eventPlayer, f"Deaths: {eventPlayer.deathCount}/5", HudPosition.RIGHT, 0, Color.RED, HudReeval.STRING)

rule "playerTick":
    @Event eachPlayer
    @Team 1

    eventPlayer.avgPosition = vect(eventPlayer.getPosition().x, (eventPlayer.getPosition().y + eventPlayer.getEyePosition().y) / 2, eventPlayer.getPosition().z)

    wait(0.05)
    loop()

rule "playerDied":
    @Event playerDied
    @Team 1

    if victim.deathCount < 5:
        victim.deathCount += 1

    if victim.deathCount >= 5:
        enableDeathEffect()

    if DEBUG == true and not victim.isInAir():
        wait(1.0)
        smallMessage(victim, f"{Texture.WORKSHOP} Debug Resurrect")
        victim.resurrect()
    else:
        victim.respawn()

rule "playerReachedGoal":
    @Event eachPlayer
    @Team 1
    @Condition distance(eventPlayer.avgPosition, goalPosition) <= goalRadius + 1

    eventPlayer.deathCount = 0

    if eventPlayer.heroIndex <= 42:
        eventPlayer.heroIndex += 1

    if eventPlayer.heroIndex < 42:
        nextHero()
        disableDeathEffect()
    elif eventPlayer.heroIndex == 42:
        becomeHelper()
    else:
        pass

def enableDeathEffect():
    victim.deathEffect = true
    victim.setMaxHealth(200)

def disableDeathEffect():
    victim.deathEffect = false
    victim.setMaxHealth(100)

def nextHero():
    bigMessage(eventPlayer, "Next Hero")
    eventPlayer.startForcingHero(eventPlayer.heroArray[eventPlayer.heroIndex])
    eventPlayer.respawn()

def becomeHelper():
    bigMessage(eventPlayer, "Become Helper")
    eventPlayer.isHelper = true
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.GREEN, OutlineVisibility.ALWAYS)
    enableDeathEffect()