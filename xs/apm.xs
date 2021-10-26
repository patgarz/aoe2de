// TODO: Technology costs

int getMultiplier() {
    
    // Map size constants
    const int tinyMap = 120;
    const int smallMap = 144;
    const int mediumMap = 168;
    const int normalMap = 200;
    const int largeMap = 220;
    const int giantMap = 240;
    const int ludicrousMap = 480; 

    int multiplier = 1;
    int mapHeight = xsGetMapHeight();
    int mapWidth = xsGetMapWidth();
    int smallestDimension = mapHeight;

    // Standard Maps are squares,
    // but custom / nonstandard maps can be rectangular
    if (mapHeight > mapWidth) {
        smallestDimension = mapWidth;        
    }

    // Use the map size as a "difficulty setting"
    // Tiny = no modifier
    // Large or greater = 4x modifier
    if (smallestDimension <= tinyMap) {
        multiplier = 1;
    } else if (smallestDimension <= smallMap) {
        multiplier = 1;
    } else if (smallestDimension <= mediumMap) {
        multiplier = 2;
    } else if (smallestDimension <= normalMap) {
        multiplier = 3;
    } else if (smallestDimension <= largeMap) {
        multiplier = 4;
    } else if (smallestDimension <= giantMap) {
        multiplier = 4;
    } else {
        multiplier = 4;
    }

    return (multiplier);
}

void adjustStartingResources(int multiplier = 1) {

    // cMulResource doesn't appear to work properly (or expectedly)
    // so we get the current value and then multiply it

   for(player = 1; <= xsGetNumPlayers()) {
        
        // Multiply all starting resources by the multiplier
        // This respects civ bonuses as well!
        int startingFood = xsPlayerAttribute(player, cAttributeFood);
        int startingWood = xsPlayerAttribute(player, cAttributeWood);
        int startingGold = xsPlayerAttribute(player, cAttributeGold);
        int startingStone = xsPlayerAttribute(player, cAttributeStone);

        xsPlayerAttribute(int playerNumber, int resourceID)

        xsEffectAmount(cModResource, cAttributeFood, cAttributeSet, startingFood*multiplier, player);
        xsEffectAmount(cModResource, cAttributeWood, cAttributeSet, startingWood*multiplier, player);
        xsEffectAmount(cModResource, cAttributeGold, cAttributeSet, startingGold*multiplier, player);
        xsEffectAmount(cModResource, cAttributeStone, cAttributeSet, startingStone*multiplier, player);


        // Multiply pop cap by 4
        // TODO: Goths are not respected here in any game starting in pre-Imperial Age
        // as they gain 10 pop upon hitting imperial age, not earlier
        // Unknown fix? Is the Goth bonus technically a "technology" that we can modify?
        int popCap = xsPlayerAttribute(player, cAttributeUnitLimit);
        xsEffectAmount(cModResource, cAttributeUnitLimit, cAttributeSet, popCap*multiplier, player);
    }

    return; 
}

// TODO: This will unfortunately need to be hardcoded
// Confirmed with Siege Engineers RMS Discord
void adjustTechnologyCosts(int multiplier = 1) {
    
    for(player = 1; <= xsGetNumPlayers()) { 
        for (techId = 0; <= 850) {
            int foodCost = ;
            int woodCost = ;
            int goldCost = ;
            int stoneCost = ;

            xsEffectAmount(cModifyTech, techId, cAttrSetFoodCost, multiplier, 1);
            xsEffectAmount(cModifyTech, techId, cAttrSetWoodCost, multiplier, 1);
            xsEffectAmount(cModifyTech, techId, cAttrSetGoldCost, multiplier, 1);
            xsEffectAmount(cModifyTech, techId, cAttrSetStoneCost, multiplier, 1);
            xsEffectAmount(int effectID, int unitOrTechnologyID, int attribtueOrOperation, int value, int playerNumber)
        }
    }
}

void main() {

    // get current multiplier based on map size
    int multiplier = getMultiplier();
    xsChatData("Current Multiplier: %d", multiplier);

    adjustStartingResources(multiplier);
    adjustTechnologyCosts(multiplier);

}