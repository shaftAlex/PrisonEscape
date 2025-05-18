#!mainFile "main.opy"

playervar avgPosition
playervar spawnPoint
playervar distanceSpawn
playervar distancePercent
playervar deathCount = 0
playervar deathEffect = false
playervar deathEffectTextEntity
playervar heroIndex = 40
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

    progressBarHud(eventPlayer, eventPlayer.distancePercent, null, HudPosition.TOP, 0, Color.WHITE, Color.WHITE, ProgressHudReeval.VISIBILITY_AND_VALUES)

    hudSubtext(eventPlayer, f"Hero {eventPlayer.heroIndex + 1}/43 {heroIcon(eventPlayer.heroArray[eventPlayer.heroIndex])} > {heroIcon(eventPlayer.heroArray[eventPlayer.heroIndex + 1])} > {heroIcon(eventPlayer.heroArray[eventPlayer.heroIndex + 2])} > {heroIcon(eventPlayer.heroArray[eventPlayer.heroIndex + 3])}", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(eventPlayer, f"Deaths {eventPlayer.deathCount}/5", HudPosition.RIGHT, 0, Color.LIGHT_RED, HudReeval.STRING)

rule "playerSpawned":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned()

    eventPlayer.spawnPoint = eventPlayer.getPosition()

rule "playerTick":
    @Event eachPlayer
    @Team 1

    eventPlayer.distanceSpawn = distance(eventPlayer.getPosition(), eventPlayer.spawnPoint)
    eventPlayer.distancePercent = (eventPlayer.distanceSpawn / totalDistance) * 100

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

    if DEBUG == true and not victim.isInAir() and not victim.isJumping():
        wait(1.0)
        smallMessage(victim, f"{Texture.WORKSHOP} Debug Resurrect")
        victim.resurrect()
    else:
        victim.respawn()

rule "playerReachedGoal":
    @Event eachPlayer
    @Team 1
    @Condition distance(eventPlayer.getPosition(), goalPosition) <= goalRadius + 1

    eventPlayer.deathCount = 0

    if eventPlayer.heroIndex < 43:
        eventPlayer.heroIndex += 1

    if eventPlayer.heroIndex < 43:
        nextHero()
        disableDeathEffect()
    elif eventPlayer.heroIndex == 44:
        becomeHelper()
    else:
        pass

rule "playerRerollInteract":
    @Event eachPlayer
    @Team 1
    @Condition distance(eventPlayer.getPosition(), rerollPosition) <= 2
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    smallMessage(eventPlayer, "  Rerolling... 3")

    wait(1)

    smallMessage(eventPlayer, "  Rerolling... 2")

    wait(1)

    smallMessage(eventPlayer, "  Rerolling... 1")

    wait(1)

    if eventPlayer.isHoldingButton(Button.INTERACT) == false:
        return

    eventPlayer.heroIndex = 0
    eventPlayer.heroArray = random.shuffle(getAllHeroes())
    eventPlayer.startForcingHero(eventPlayer.heroArray[eventPlayer.heroIndex])
    eventPlayer.respawn()
    disableDeathEffect()

    bigMessage(eventPlayer, "Rerolled!")

    wait(10)

def enableDeathEffect():
    victim.deathEffect = true
    victim.setMaxHealth(200)

    destroyHudText(eventPlayer.deathEffectTextEntity)
    hudSubtext(eventPlayer, "200% Health", HudPosition.RIGHT, 1, Color.PURPLE, HudReeval.STRING)
    eventPlayer.deathEffectTextEntity = getLastCreatedText()

def disableDeathEffect():
    victim.deathEffect = false
    victim.setMaxHealth(100)

    destroyHudText(eventPlayer.deathEffectTextEntity)

def nextHero():
    bigMessage(eventPlayer, "Next Hero")
    eventPlayer.startForcingHero(eventPlayer.heroArray[eventPlayer.heroIndex])
    eventPlayer.respawn()

def becomeHelper():
    bigMessage(eventPlayer, "Become Helper")
    eventPlayer.isHelper = true
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.GREEN, OutlineVisibility.ALWAYS)
    eventPlayer.respawn()
    enableDeathEffect()