#!mainFile "main.opy"

playervar bastionIterator = 0
playervar bastionTargetArray = []
playervar bastionTargetDistances = []
playervar bastionCurrentTarget
playervar bastionTransform = false

subroutine bastionTransform

rule "bastionInit":
    @Event eachPlayer
    @Team 2

    eventPlayer.setKnockbackReceived(0)

rule "bastionTick":
    @Event eachPlayer
    @Team 2

    eventPlayer.setHealth(eventPlayer.getMaxHealth())

    eventPlayer.bastionTargetArray = getRealPlayersInRadius(eventPlayer.getEyePosition(), bastionAttackRange, Team.1, LosCheck.SURFACES)

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.bastionTransform == false:
        bastionTransform()
        
    if eventPlayer.bastionTargetArray == not []:
        if not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        pass
    else:
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    
    if eventPlayer.bastionTargetArray == not []:
        if eventPlayer.bastionTransform == false:
            bastionTransform()
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

        if eventPlayer.bastionTransform == true:
            bastionTransform()
        else:
            pass

    wait(0.05)
    loop()

def bastionTransform():
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.bastionTransform = not eventPlayer.bastionTransform
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.05)
    eventPlayer.stopForcingButton(Button.ABILITY_1)