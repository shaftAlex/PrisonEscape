#!mainFile "main.opy"

globalvar goalPosition = vect(0, 0, 0)
globalvar goalRadius = 0
globalvar bastionIterator = 0
globalvar bastionAttackRange = []
globalvar bastionPositionArray = []
globalvar bastionEntityArray = []

subroutine map
    
rule "map":
    map()

    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.GREEN, goalPosition, goalRadius, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), Texture.ASSAULT, goalPosition + vect(0, 2, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY)

    for bastionIterator in range(0, len(bastionPositionArray)):
        createDummy(Hero.BASTION, Team.2, -1, bastionPositionArray[bastionIterator])
        bastionEntityArray.append(getLastCreatedEntity())

def map():
    switch getCurrentMap():
        case Map.WATCHPOINT_GIBRALTAR:
            goalPosition = vect(34.11, -4.82, -137.66)
            goalRadius = 5
            bastionAttackRange = 100
            bastionPositionArray.append(vect(79.15, 9.00, 21.43))
            bastionPositionArray.append(vect(45.65, 3.00, -34.26))
            bastionPositionArray.append(vect(62.71, 2.03, -23.29))
            bastionPositionArray.append(vect(79.85, 3.00, -34.03))
            startForcingSpawn(Team.ALL, 2)
            break