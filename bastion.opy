#!mainFile "main.opy"

playervar bastionIterator = 0
playervar bastionTargetArray = []
playervar bastionTargetDistances = []
playervar bastionCurrentTarget
playervar bastionSpawnPosition = vect(0, 0, 0)
playervar bastionTransform = false
playervar bastionTransformActive = false

subroutine bastionTransform

rule "bastionInit":
    @Event eachPlayer
    @Team 2

    eventPlayer.setKnockbackReceived(0)
    # eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    # eventPlayer.setAbilityCharge(Button.ABILITY_1, 10)
    
rule "bastionSpawned":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.hasSpawned()
    
    eventPlayer.bastionSpawnPosition = eventPlayer.getPosition()

rule "bastionTick":
    @Event eachPlayer
    @Team 2

    eventPlayer.teleport(eventPlayer.bastionSpawnPosition)

    eventPlayer.setHealth(eventPlayer.getMaxHealth())

    eventPlayer.bastionTargetArray = getRealPlayersInRadius(eventPlayer.getEyePosition(), bastionAttackRange, Team.1, LosCheck.SURFACES)

    # if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.bastionTransform == false:
    #     bastionTransform()
        
    if eventPlayer.bastionTargetArray == not []:
        if not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        pass
    else:
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    
    if eventPlayer.bastionTargetArray == not []:
        # if eventPlayer.bastionTransform == false:
        #     bastionTransform()
        if eventPlayer.isInAlternateForm() == false:
            eventPlayer.startForcingButton(Button.ABILITY_1)
            eventPlayer.stopForcingButton(Button.ABILITY_1)
        else:
            pass

        for eventPlayer.bastionIterator in range(0, len(eventPlayer.bastionTargetArray)):
            eventPlayer.bastionTargetDistances[bastionIterator] = distance(eventPlayer, eventPlayer.bastionTargetArray[bastionIterator])

            if eventPlayer.bastionTargetDistances[bastionIterator] < eventPlayer.bastionTargetDistances[bastionIterator - 1]:
                eventPlayer.bastionTargetArray = eventPlayer.bastionTargetArray.exclude(eventPlayer.bastionTargetArray[bastionIterator])
            else:
                eventPlayer.bastionCurrentTarget = eventPlayer.bastionTargetArray[0]
        
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.bastionCurrentTarget.avgPosition))        
    
    else:
        eventPlayer.bastionTargetArray = []
        eventPlayer.bastionCurrentTarget = null

        if eventPlayer.isInAlternateForm() == true:
            eventPlayer.startForcingButton(Button.ABILITY_1)
            eventPlayer.stopForcingButton(Button.ABILITY_1)
        else:
            pass

    wait(0.05)
    loop()

def bastionTransform():
    if eventPlayer.bastionTransformActive == false:
        eventPlayer.bastionTransformActive = true

        while eventPlayer.bastionTransformActive == true:
            eventPlayer.bastionTransform = not eventPlayer.bastionTransform

            eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

            eventPlayer.startForcingButton(Button.ABILITY_1)
            wait(0.05)
            eventPlayer.stopForcingButton(Button.ABILITY_1)

            eventPlayer.bastionTransformActive = false
    
    else:
        pass