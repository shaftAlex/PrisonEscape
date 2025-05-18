#!mainFile "main.opy"


globalvar rerollPosition = vect(0, 0, 0)
globalvar goalPosition = vect(0, 0, 0)
globalvar goalRadius = 0
globalvar totalDistance = 0
globalvar bastionIterator = 0
globalvar bastionAttackRange = []
globalvar bastionPositionArray = []
globalvar bastionEntityArray = []
globalvar allyPositionArray = []

subroutine map
    
rule "map":
    map()

    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, rerollPosition, 2, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), Texture.FALL_BACK, rerollPosition + vect(0, 1.0, 0), 3.0, Clip.SURFACES, WorldTextReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "Reroll [Interact]", rerollPosition + vect(0, 1.75, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.YELLOW)
    
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.GREEN, goalPosition, goalRadius, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), Texture.ASSAULT, goalPosition + vect(0, 2.0, 0), 3.0, Clip.NONE, WorldTextReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "Goal", goalPosition + vect(0, 2.5, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.GREEN)

    totalDistance = distance(rerollPosition, goalPosition)

    for bastionIterator in range(0, len(bastionPositionArray)):
        createDummy(Hero.BASTION, Team.2, -1, bastionPositionArray[bastionIterator])
        bastionEntityArray.append(getLastCreatedEntity())
    
    bastionIterator = 0
    
    for bastionIterator in range(0, len(allyPositionArray)):
        createDummy(Hero.BASTION, Team.1, -1, allyPositionArray[bastionIterator])
        # bastionEntityArray.append(getLastCreatedEntity())

def map():
    switch getCurrentMap():
        case Map.WATCHPOINT_GIBRALTAR:
            rerollPosition = vect(102.59, -2.00, 63.89)
            goalPosition = vect(34.11, -4.82, -137.66)
            goalRadius = 5
            bastionAttackRange = 100
            bastionPositionArray.append(vect(79.15, 9.00, 21.43))
            bastionPositionArray.append(vect(45.65, 3.00, -34.26))
            bastionPositionArray.append(vect(62.71, 2.03, -23.29))
            bastionPositionArray.append(vect(79.85, 3.00, -34.03))
            allyPositionArray.append(vect(78.31, -1.00, 37.51))
            allyPositionArray.append(vect(80.34, -0.94, 44.34))
            allyPositionArray.append(vect(79.91, 1.00, 55.74))
            startForcingSpawn(Team.1, 2)
            break