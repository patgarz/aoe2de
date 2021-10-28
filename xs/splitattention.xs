// TODOs:
// --Additional Civ bonuses--
// Some of these may require data mods outside of XS - I don't want to do this? Solutions TBD.
// * Goth +10*multiplier pop in Imp
// * All civs +multiplier TCs allowed to build pre-Castle
// * Cumans +multiplier TCs allowed to build in Feudal
// * Cuman Mercenaries +multiplier 
// * Chinese not starting with extra vils on all TCs
// * Ethiopians (+100F, +100G)*multiplier per age
// * Atheism (Huns) +100*multiplier years countdown
// * Paper Money (Vietnamese) *multiplier resources
// * First Crusade (Sicilians) allow for more max Serjeants
// --Other--
// * Alternate build that allows for researching all techs (multiplier) times, with same cost but 1/multiplier effect
//  - May require a data mod? Needs research. Should finish this build in at least a RC state first.
// * Relic bonus for Lithuanians - balancing?
// * General balancing?

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

void multiplyTechCost(int playerId = 1, int techId = -1, int multiplier = 1, int woodCost = 0, int foodCost = 0, int goldCost = 0, int stoneCost = 0) {

    xsEffectAmount(cModifyTech, techId, cAttrSetWoodCost, multiplier*woodCost, playerId);
    xsEffectAmount(cModifyTech, techId, cAttrSetFoodCost, multiplier*foodCost, playerId);
    xsEffectAmount(cModifyTech, techId, cAttrSetGoldCost, multiplier*goldCost, playerId);
    xsEffectAmount(cModifyTech, techId, cAttrSetStoneCost, multiplier*stoneCost, playerId);

    return; 
}

void adjustStartingResources(int multiplier = 1) {

    // cMulResource doesn't appear to work properly (or expectedly)
    // so we get the current value and then multiply it

   for(player = 1; <= xsGetNumPlayers()) {
        
        // Multiply all starting resources by the multiplier
        // This respects civ bonuses as well!
        int startingWood = xsPlayerAttribute(player, cAttributeWood);
        int startingFood = xsPlayerAttribute(player, cAttributeFood);
        int startingGold = xsPlayerAttribute(player, cAttributeGold);
        int startingStone = xsPlayerAttribute(player, cAttributeStone);

        xsEffectAmount(cModResource, cAttributeWood, cAttributeSet, startingWood*multiplier, player);
        xsEffectAmount(cModResource, cAttributeFood, cAttributeSet, startingFood*multiplier, player);
        xsEffectAmount(cModResource, cAttributeGold, cAttributeSet, startingGold*multiplier, player);
        xsEffectAmount(cModResource, cAttributeStone, cAttributeSet, startingStone*multiplier, player);

        // Multiply pop cap by 4
        // TODO: Goths are not respected here in any game starting before the Imperial Age
        // as they gain 10 pop upon hitting imperial age, not earlier
        // We can maybe fix by applying tech 406 multiple times to the goth player upon hitting imp?
        int popCap = xsPlayerAttribute(player, cAttributeUnitLimit);
        xsEffectAmount(cModResource, cAttributeUnitLimit, cAttributeSet, popCap*multiplier, player);
    }

    return; 
}

// Each individual tech will unfortunately need to be hardcoded
// There is no function to "fetch" tech costs
// This means civ bonuses will also need to be applied manually
// Confirmed with Siege Engineers RMS Discord

void adjustTechnologyCosts(int multiplier = 1) {

    for(player = 1; <= xsGetNumPlayers()) { 
        // See generation script at ../generateTechXSData.ps1
        // Civ bonuses added manually, as well as reordering / cleaning for easier organization
        // (originally ordered by techId which is very scrambled)

        // Civ bonuses resulting in Free & Auto-Researched techs (like Franks Mill) do NOT need to be coded in

        int playerCiv = xsGetPlayerCivilization(player);

        // Overall Balance Tuning + Civ Bonuses
        // This could probably be better constructed but it took me a long time to get here
        // and I'm irritated (and at least it makes multipliers semi-centrally located)
        // Other ideas: Break this into a helper function and use default values,
        // each civ then calls the helper function and changes the default values where necessary
        float ecoMultiplier = 1.0;
        float ecoWMultiplier = ecoMultiplier;
        float ecoFMultiplier = ecoMultiplier;
        float ecoGMultiplier = ecoMultiplier;
        float ecoSMultiplier = ecoMultiplier;

        if (playerCiv == cBurgundians) {
            ecoFMultiplier = 0.5*ecoFMultiplier;
        } else if (playerCiv == cVietnamese) {
            ecoWMultiplier = 0.5*ecoWMultiplier;
        }

        float raxMultiplier = 1.0;
        float raxWMultiplier = raxMultiplier;
        float raxFMultiplier = raxMultiplier;
        float raxGMultiplier = raxMultiplier;
        float raxSMultiplier = raxMultiplier;

        float rangeMultiplier = 1.0;
        float rangeWMultiplier = rangeMultiplier;
        float rangeFMultiplier = rangeMultiplier;
        float rangeGMultiplier = rangeMultiplier;
        float rangeSMultiplier = rangeMultiplier;

        float stableMultiplier = 1.0;
        if (playerCiv == cBurgundians) {
            stableMultiplier = 0.5*stableMultiplier;
        }
        float stableWMultiplier = stableMultiplier;
        float stableFMultiplier = stableMultiplier;
        float stableGMultiplier = stableMultiplier;
        float stableSMultiplier = stableMultiplier;

        float siegeMultiplier = 1.0;
        float siegeWMultiplier = siegeMultiplier;
        float siegeFMultiplier = siegeMultiplier;
        float siegeGMultiplier = siegeMultiplier;
        float siegeSMultiplier = siegeMultiplier;
        if (playerCiv == cBulgarians) {
            siegeFMultiplier = 0.5*siegeFMultiplier;
        }

        float smithMultiplier = 1.0;
        float smithWMultiplier = smithMultiplier;
        float smithFMultiplier = smithMultiplier;
        float smithGMultiplier = smithMultiplier;
        float smithSMultiplier = smithMultiplier;
        if (playerCiv == cBulgarians) {
            smithFMultiplier = 0.5*smithFMultiplier;
        } else if (playerCiv == cSpanish) {
            smithGMultiplier = 0*smithGMultiplier;
        }

        float dockMultiplier = 1.0;
        if (playerCiv == cItalians) {
            dockMultiplier = 0.6666*dockMultiplier;
        }
        float dockWMultiplier = dockMultiplier;
        float dockFMultiplier = dockMultiplier;
        float dockGMultiplier = dockMultiplier;
        float dockSMultiplier = dockMultiplier;
        
        float dockEcoMultiplier = 1.0;
        float dockEcoWMultiplier = dockEcoMultiplier*dockWMultiplier*ecoWMultiplier;
        float dockEcoFMultiplier = dockEcoMultiplier*dockFMultiplier*ecoFMultiplier;
        float dockEcoGMultiplier = dockEcoMultiplier*dockGMultiplier*ecoGMultiplier;
        float dockEcoSMultiplier = dockEcoMultiplier*dockSMultiplier*ecoSMultiplier;

        float uniMultiplier = 1.0;
        if (playerCiv == cItalians) {
            uniMultiplier = 0.6666*uniMultiplier;
        }
        float uniWMultiplier = uniMultiplier;
        float uniFMultiplier = uniMultiplier;
        float uniGMultiplier = uniMultiplier;
        float uniSMultiplier = uniMultiplier;

        float castleMultiplier = 1.0;
        float castleWMultiplier = castleMultiplier;
        float castleFMultiplier = castleMultiplier;
        float castleGMultiplier = castleMultiplier;
        float castleSMultiplier = castleMultiplier;

        float monasteryMultiplier = 1.0;
        if (playerCiv == cBurmese) {
            monasteryMultiplier = 0.5*monasteryMultiplier;
        }
        float monasteryWMultiplier = monasteryMultiplier;
        float monasteryFMultiplier = monasteryMultiplier;
        float monasteryGMultiplier = monasteryMultiplier;
        float monasterySMultiplier = monasteryMultiplier;

        float tcOtherMultiplier = 1.0;
        float tcOtherWMultiplier = tcOtherMultiplier;
        float tcOtherFMultiplier = tcOtherMultiplier;
        float tcOtherGMultiplier = tcOtherMultiplier;
        float tcOtherSMultiplier = tcOtherMultiplier;

        float tcAgeUpMultiplier = 1.0;
        if (playerCiv == cItalians) {
            tcAgeUpMultiplier = 0.85*tcAgeUpMultiplier;
        }
        float tcAgeUpWMultiplier = tcAgeUpMultiplier;
        float tcAgeUpFMultiplier = tcAgeUpMultiplier;
        float tcAgeUpGMultiplier = tcAgeUpMultiplier;
        float tcAgeUpSMultiplier = tcAgeUpMultiplier;
        
        float tcImperialAgeMultiplier = 1.0;
        if (playerCiv == cByzantines) {
            tcImperialAgeMultiplier = 0.6666*tcImperialAgeMultiplier;        
        }
        float tcImperialAgeWMultiplier = tcImperialAgeMultiplier*tcAgeUpWMultiplier;
        float tcImperialAgeFMultiplier = tcImperialAgeMultiplier*tcAgeUpFMultiplier;
        float tcImperialAgeGMultiplier = tcImperialAgeMultiplier*tcAgeUpGMultiplier;
        float tcImperialAgeSMultiplier = tcImperialAgeMultiplier*tcAgeUpSMultiplier;

        float tcEcoMultiplier = 1.0; 
        float tcEcoWMultiplier = tcEcoMultiplier*ecoWMultiplier;
        float tcEcoFMultiplier = tcEcoMultiplier*ecoFMultiplier;
        float tcEcoGMultiplier = tcEcoMultiplier*ecoWMultiplier;
        float tcEcoSMultiplier = tcEcoMultiplier*ecoSMultiplier;

        float mineMultiplier = 1.0;
        float mineWMultiplier = mineMultiplier*ecoWMultiplier;
        float mineFMultiplier = mineMultiplier*ecoFMultiplier;
        float mineGMultiplier = mineMultiplier*ecoGMultiplier;
        float mineSMultiplier = mineMultiplier*ecoSMultiplier;

        float lumberMultiplier = 1.0;
        float lumberWMultiplier = lumberMultiplier*ecoWMultiplier;
        float lumberFMultiplier = lumberMultiplier*ecoFMultiplier;
        float lumberGMultiplier = lumberMultiplier*ecoGMultiplier;
        float lumberSMultiplier = lumberMultiplier*ecoSMultiplier;

        float millMultiplier = 1.0;
        float millWMultiplier = millMultiplier*ecoWMultiplier;
        float millFMultiplier = millMultiplier*ecoFMultiplier;
        float millGMultiplier = millMultiplier*ecoGMultiplier;
        float millSMultiplier = millMultiplier*ecoSMultiplier;

        float marketMultiplier = 1.0;
        float marketWMultiplier = marketMultiplier*ecoWMultiplier;
        float marketFMultiplier = marketMultiplier*ecoFMultiplier;
        float marketGMultiplier = marketMultiplier*ecoGMultiplier;
        float marketSMultiplier = marketMultiplier*ecoSMultiplier;

        float marketEcoMultiplier = 1.0;
        float marketEcoWMultiplier = marketEcoMultiplier*marketWMultiplier*ecoWMultiplier;
        float marketEcoFMultiplier = marketEcoMultiplier*marketFMultiplier*ecoFMultiplier;
        float marketEcoGMultiplier = marketEcoMultiplier*marketGMultiplier*ecoGMultiplier;
        float marketEcoSMultiplier = marketEcoMultiplier*marketSMultiplier*ecoSMultiplier;

        float gunpowderMultiplier = 1.0;
        if (playerCiv == cTurks) {
            gunpowderMultiplier = 0.5*gunpowderMultiplier;
        }
        float gunpowderWMultiplier = gunpowderMultiplier;
        float gunpowderFMultiplier = gunpowderMultiplier;
        float gunpowderGMultiplier = gunpowderMultiplier;
        float gunpowderSMultiplier = gunpowderMultiplier;

        // ------BARRACKS------
        float wMultiplier = raxWMultiplier;
        float fMultiplier = raxFMultiplier;
        float gMultiplier = raxGMultiplier;
        float sMultiplier = raxSMultiplier;

        // Pikeman
        multiplyTechCost(player, 197, multiplier, 0*wMultiplier, 215*fMultiplier, 90*gMultiplier, 0*sMultiplier);
        // Halberdier
        multiplyTechCost(player, 429, multiplier, 0*wMultiplier, 300*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Man-At-Arms
        multiplyTechCost(player, 222, multiplier, 0*wMultiplier, 100*fMultiplier, 40*gMultiplier, 0*sMultiplier);
        // Long Swordsman
        multiplyTechCost(player, 207, multiplier, 0*wMultiplier, 150*fMultiplier, 65*gMultiplier, 0*sMultiplier);
        // Two-Handed Swordsman
        multiplyTechCost(player, 217, multiplier, 0*wMultiplier, 300*fMultiplier, 100*gMultiplier, 0*sMultiplier);
        // Champion
        multiplyTechCost(player, 264, multiplier, 0*wMultiplier, 750*fMultiplier, 350*gMultiplier, 0*sMultiplier);
        // Eagle Warrior
        multiplyTechCost(player, 384, multiplier, 0*wMultiplier, 200*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Elite Eagle Warrior
        multiplyTechCost(player, 434, multiplier, 0*wMultiplier, 800*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Squires
        multiplyTechCost(player, 215, multiplier, 0*wMultiplier, 100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Arson
        multiplyTechCost(player, 602, multiplier, 0*wMultiplier, 150*fMultiplier, 50*gMultiplier, 0*sMultiplier);
        // Tracking
        multiplyTechCost(player, 716, multiplier, 0*wMultiplier, 75*fMultiplier, 75*gMultiplier, 0*sMultiplier);
        
        // ------ARCHERY RANGE------
        wMultiplier = rangeWMultiplier;
        fMultiplier = rangeFMultiplier;
        gMultiplier = rangeGMultiplier;
        sMultiplier = rangeSMultiplier;

        // Elite Skirmisher
        multiplyTechCost(player, 98, multiplier, 230*wMultiplier, 0*fMultiplier, 130*gMultiplier, 0*sMultiplier);
        // Imperial Skirmisher
        multiplyTechCost(player, 655, multiplier, 300*wMultiplier, 0*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Elite Genitour
        multiplyTechCost(player, 430, multiplier, 0*wMultiplier, 800*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Elite Genitour
        multiplyTechCost(player, 599, multiplier, 450*wMultiplier, 500*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Crossbow
        multiplyTechCost(player, 100, multiplier, 0*wMultiplier, 125*fMultiplier, 75*gMultiplier, 0*sMultiplier);
        // Arbalest
        multiplyTechCost(player, 237, multiplier, 0*wMultiplier, 350*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Heavy Cavalry Archer
        multiplyTechCost(player, 218, multiplier, 0*wMultiplier, 900*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Parthian Tactics
        multiplyTechCost(player, 436, multiplier, 0*wMultiplier, 200*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Thumb Ring
        multiplyTechCost(player, 437, multiplier, 250*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);

        // ------STABLE------
        wMultiplier = stableWMultiplier;
        fMultiplier = stableFMultiplier;
        gMultiplier = stableGMultiplier;
        sMultiplier = stableSMultiplier;
        
        // Light Cavalry
        multiplyTechCost(player, 254, multiplier, 0*wMultiplier, 150*fMultiplier, 50*gMultiplier, 0*sMultiplier);
        // Hussar
        multiplyTechCost(player, 428, multiplier, 0*wMultiplier, 500*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Winged Hussar
        multiplyTechCost(player, 786, multiplier, 0*wMultiplier, 600*fMultiplier, 800*gMultiplier, 0*sMultiplier);
        // Cavalier
        multiplyTechCost(player, 209, multiplier, 0*wMultiplier, 300*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Paladin
        multiplyTechCost(player, 265, multiplier, 0*wMultiplier, 1300*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Heavy Camel
        multiplyTechCost(player, 236, multiplier, 0*wMultiplier, 325*fMultiplier, 360*gMultiplier, 0*sMultiplier);
        // Imperial Camel
        multiplyTechCost(player, 521, multiplier, 0*wMultiplier, 1200*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Elite Steppe Lancer
        multiplyTechCost(player, 715, multiplier, 0*wMultiplier, 900*fMultiplier, 550*gMultiplier, 0*sMultiplier);
        // Elite Battle Elephant
        multiplyTechCost(player, 631, multiplier, 0*wMultiplier, 1200*fMultiplier, 900*gMultiplier, 0*sMultiplier);
        // Husbandry
        multiplyTechCost(player, 39, multiplier, 0*wMultiplier, 150*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Bloodlines
        multiplyTechCost(player, 435, multiplier, 0*wMultiplier, 150*fMultiplier, 100*gMultiplier, 0*sMultiplier);
                
        // ------SIEGE WORKSHOP------
        wMultiplier = siegeWMultiplier;
        fMultiplier = siegeFMultiplier;
        gMultiplier = siegeGMultiplier;
        sMultiplier = siegeSMultiplier;

        // Capped Ram
        multiplyTechCost(player, 96, multiplier, 0*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Siege Ram
        multiplyTechCost(player, 255, multiplier, 0*wMultiplier, 1000*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Onager
        multiplyTechCost(player, 257, multiplier, 0*wMultiplier, 800*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Siege Onager
        multiplyTechCost(player, 320, multiplier, 0*wMultiplier, 1450*fMultiplier, 1000*gMultiplier, 0*sMultiplier);
        // Heavy Scorpion
        multiplyTechCost(player, 239, multiplier, 1100*wMultiplier, 1000*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Houfnice
        multiplyTechCost(player, 787, multiplier, 0*wMultiplier*gunpowderWMultiplier, 950*fMultiplier*gunpowderFMultiplier, 750*gMultiplier*gunpowderGMultiplier, 0*sMultiplier*gunpowderSMultiplier);

        // ------BLACKSMITH------
        wMultiplier = smithWMultiplier;
        fMultiplier = smithFMultiplier;
        gMultiplier = smithGMultiplier;
        sMultiplier = smithSMultiplier;
        
        // Padded Archer Armor
        multiplyTechCost(player, 211, multiplier, 0*wMultiplier, 100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Leather Archer Armor
        multiplyTechCost(player, 212, multiplier, 0*wMultiplier, 150*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Ring Archer Armor
        multiplyTechCost(player, 219, multiplier, 0*wMultiplier, 250*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Fletching
        multiplyTechCost(player, 199, multiplier, 0*wMultiplier, 100*fMultiplier, 50*gMultiplier, 0*sMultiplier);
        // Bodkin Arrow
        multiplyTechCost(player, 200, multiplier, 0*wMultiplier, 200*fMultiplier, 100*gMultiplier, 0*sMultiplier);
        // Bracer
        multiplyTechCost(player, 201, multiplier, 0*wMultiplier, 300*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Forging
        multiplyTechCost(player, 67, multiplier, 0*wMultiplier, 150*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Iron casting
        multiplyTechCost(player, 68, multiplier, 0*wMultiplier, 220*fMultiplier, 120*gMultiplier, 0*sMultiplier);
        // Blast Furnace
        multiplyTechCost(player, 75, multiplier, 0*wMultiplier, 275*fMultiplier, 225*gMultiplier, 0*sMultiplier);
        // Scale Mail Armor
        multiplyTechCost(player, 74, multiplier, 0*wMultiplier, 100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Chain Mail Armor
        multiplyTechCost(player, 76, multiplier, 0*wMultiplier, 200*fMultiplier, 100*gMultiplier, 0*sMultiplier);
        // Plate Mail Armor
        multiplyTechCost(player, 77, multiplier, 0*wMultiplier, 300*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Scale Barding Armor
        multiplyTechCost(player, 81, multiplier, 0*wMultiplier, 150*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Chain Barding Armor
        multiplyTechCost(player, 82, multiplier, 0*wMultiplier, 250*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Plate Barding Armor
        multiplyTechCost(player, 80, multiplier, 0*wMultiplier, 350*fMultiplier, 200*gMultiplier, 0*sMultiplier);

        // ------DOCK------
        wMultiplier = dockWMultiplier;
        fMultiplier = dockFMultiplier;
        gMultiplier = dockGMultiplier;
        sMultiplier = dockSMultiplier;

        // War Galley
        multiplyTechCost(player, 34, multiplier, 0*wMultiplier, 230*fMultiplier, 100*gMultiplier, 0*sMultiplier);
        // Galleon
        multiplyTechCost(player, 35, multiplier, 315*wMultiplier, 400*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Heavy Demolition
        multiplyTechCost(player, 244, multiplier, 200*wMultiplier, 0*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Fast Fire Ship
        multiplyTechCost(player, 246, multiplier, 280*wMultiplier, 0*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Shipwright
        multiplyTechCost(player, 373, multiplier, 0*wMultiplier, 1000*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Careening
        multiplyTechCost(player, 374, multiplier, 0*wMultiplier, 250*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Dry Dock
        multiplyTechCost(player, 375, multiplier, 0*wMultiplier, 600*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Elite Cannon Galley
        multiplyTechCost(player, 376, multiplier, 525*wMultiplier*gunpowderWMultiplier, 0*fMultiplier*gunpowderFMultiplier, 500*gMultiplier*gunpowderGMultiplier, 0*sMultiplier*gunpowderSMultiplier);
        // Elite Caravel
        multiplyTechCost(player, 597, multiplier, 0*wMultiplier, 750*fMultiplier, 475*gMultiplier, 0*sMultiplier);
        // Elite Longboat
        multiplyTechCost(player, 372, multiplier, 0*wMultiplier, 750*fMultiplier, 475*gMultiplier, 0*sMultiplier);
        // Elite Turtle Ship
        multiplyTechCost(player, 448, multiplier, 0*wMultiplier, 1000*fMultiplier, 800*gMultiplier, 0*sMultiplier);

        wMultiplier = dockEcoWMultiplier;
        fMultiplier = dockEcoFMultiplier;
        gMultiplier = dockEcoGMultiplier;
        sMultiplier = dockEcoSMultiplier;
        // Gillnets
        multiplyTechCost(player, 65, multiplier, 200*wMultiplier, 150*fMultiplier, 0*gMultiplier, 0*sMultiplier);

        // ------UNIVERSITY------
        wMultiplier = uniWMultiplier;
        fMultiplier = uniFMultiplier;
        gMultiplier = uniGMultiplier;
        sMultiplier = uniSMultiplier;

        // Siege Engineers
        multiplyTechCost(player, 377, multiplier, 600*wMultiplier, 500*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Heated Shot
        multiplyTechCost(player, 380, multiplier, 0*wMultiplier, 350*fMultiplier, 100*gMultiplier, 0*sMultiplier);
        // Treadmill crane
        multiplyTechCost(player, 54, multiplier, 200*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Fortified Wall
        multiplyTechCost(player, 194, multiplier, 100*wMultiplier, 200*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Ballistics
        multiplyTechCost(player, 93, multiplier, 300*wMultiplier, 0*fMultiplier, 175*gMultiplier, 0*sMultiplier);
        // Chemistry
        multiplyTechCost(player, 47, multiplier, 0*wMultiplier*gunpowderWMultiplier, 300*fMultiplier*gunpowderFMultiplier, 200*gMultiplier*gunpowderGMultiplier, 0*sMultiplier*gunpowderSMultiplier);
        // Masonry
        multiplyTechCost(player, 50, multiplier, 175*wMultiplier, 150*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Architecture
        multiplyTechCost(player, 51, multiplier, 200*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Guard Tower
        multiplyTechCost(player, 140, multiplier, 250*wMultiplier, 100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Keep
        multiplyTechCost(player, 63, multiplier, 350*wMultiplier, 500*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Bombard Tower
        multiplyTechCost(player, 64, multiplier, 400*wMultiplier*gunpowderWMultiplier, 800*fMultiplier*gunpowderFMultiplier, 0*gMultiplier*gunpowderGMultiplier, 0*sMultiplier*gunpowderSMultiplier);
        // Murder Holes
        multiplyTechCost(player, 322, multiplier, 0*wMultiplier, 200*fMultiplier, 0*gMultiplier, 100*sMultiplier);
        // Arrowslits
        multiplyTechCost(player, 608, multiplier, 250*wMultiplier, 250*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        
        // ------CASTLE------
        wMultiplier = castleWMultiplier;
        fMultiplier = castleFMultiplier;
        gMultiplier = castleGMultiplier;
        sMultiplier = castleSMultiplier;   

        // Elite Tarkan
        multiplyTechCost(player, 2, multiplier, 0*wMultiplier, 1000*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // British Yeoman
        multiplyTechCost(player, 3, multiplier, 750*wMultiplier, 0*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Mayan El Dorado
        multiplyTechCost(player, 4, multiplier, 0*wMultiplier, 750*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Celtic Furor Celtica
        multiplyTechCost(player, 5, multiplier, 0*wMultiplier, 750*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Mongol Siege Drill
        multiplyTechCost(player, 6, multiplier, 500*wMultiplier, 0*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Persian Mahouts
        multiplyTechCost(player, 7, multiplier, 0*wMultiplier, 300*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Saracen Zealotry
        multiplyTechCost(player, 9, multiplier, 0*wMultiplier, 500*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Turkish Artillery
        multiplyTechCost(player, 10, multiplier, 450*wMultiplier, 0*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Teuton Crenellations
        multiplyTechCost(player, 11, multiplier, 0*wMultiplier, 600*fMultiplier, 0*gMultiplier, 400*sMultiplier);
        // Gothic Anarchy
        multiplyTechCost(player, 16, multiplier, 0*wMultiplier, 450*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Hun Atheism
        multiplyTechCost(player, 21, multiplier, 0*wMultiplier, 500*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Aztec Garland Wars
        multiplyTechCost(player, 24, multiplier, 0*wMultiplier, 450*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Elite Plumed Archer
        multiplyTechCost(player, 27, multiplier, 1000*wMultiplier, 700*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Viking Berserkergang
        multiplyTechCost(player, 49, multiplier, 0*wMultiplier, 850*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Japanese Kataparuto
        multiplyTechCost(player, 59, multiplier, 750*wMultiplier, 0*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Elite Conquistador
        multiplyTechCost(player, 60, multiplier, 0*wMultiplier, 1200*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Byzantine Logistica
        multiplyTechCost(player, 61, multiplier, 0*wMultiplier, 800*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Frankish Bearded Axe
        multiplyTechCost(player, 83, multiplier, 0*wMultiplier, 300*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Chinese Rocketry
        multiplyTechCost(player, 52, multiplier, 750*wMultiplier, 0*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Conscription
        multiplyTechCost(player, 315, multiplier, 0*wMultiplier, 150*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Sappers
        multiplyTechCost(player, 321, multiplier, 0*wMultiplier, 400*fMultiplier, 200*gMultiplier, 0*sMultiplier); 
        // Elite Longbow
        multiplyTechCost(player, 360, multiplier, 0*wMultiplier, 850*fMultiplier, 850*gMultiplier, 0*sMultiplier);
        // Elite Cataphract
        multiplyTechCost(player, 361, multiplier, 0*wMultiplier, 1200*fMultiplier, 800*gMultiplier, 0*sMultiplier);
        // Elite Chu Ko Nu
        multiplyTechCost(player, 362, multiplier, 0*wMultiplier, 950*fMultiplier, 950*gMultiplier, 0*sMultiplier);
        // Elite Throwing Axemen
        multiplyTechCost(player, 363, multiplier, 0*wMultiplier, 1000*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Elite Teutonic Knight
        multiplyTechCost(player, 364, multiplier, 0*wMultiplier, 1200*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Elite Huskarl
        multiplyTechCost(player, 365, multiplier, 0*wMultiplier, 1200*fMultiplier, 550*gMultiplier, 0*sMultiplier);
        // Elite Samurai
        multiplyTechCost(player, 366, multiplier, 0*wMultiplier, 950*fMultiplier, 875*gMultiplier, 0*sMultiplier);
        // Elite War Elephant
        multiplyTechCost(player, 367, multiplier, 0*wMultiplier, 1600*fMultiplier, 1200*gMultiplier, 0*sMultiplier);
        // Elite Mameluke
        multiplyTechCost(player, 368, multiplier, 0*wMultiplier, 600*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Elite Jannisary
        multiplyTechCost(player, 369, multiplier, 0*wMultiplier, 850*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Elite Woad Raider
        multiplyTechCost(player, 370, multiplier, 0*wMultiplier, 1000*fMultiplier, 800*gMultiplier, 0*sMultiplier);
        // Elite Mangudai
        multiplyTechCost(player, 371, multiplier, 0*wMultiplier, 1100*fMultiplier, 675*gMultiplier, 0*sMultiplier);
        // Hoardings
        multiplyTechCost(player, 379, multiplier, 400*wMultiplier, 400*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Elite Berserk
        multiplyTechCost(player, 398, multiplier, 0*wMultiplier, 1300*fMultiplier, 550*gMultiplier, 0*sMultiplier);
        // Spy Technology -- already scales with villager count
        // multiplyTechCost(player, 408, multiplier, 0*wMultiplier, 0*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Elite Jaguar Man
        multiplyTechCost(player, 432, multiplier, 0*wMultiplier, 1000*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Spanish Supremacy
        multiplyTechCost(player, 440, multiplier, 0*wMultiplier, 400*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Korean catapults
        multiplyTechCost(player, 445, multiplier, 800*wMultiplier, 0*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Elite War Wagon
        multiplyTechCost(player, 450, multiplier, 1000*wMultiplier, 0*fMultiplier, 800*gMultiplier, 0*sMultiplier);
        // Gothic Perfusion
        multiplyTechCost(player, 457, multiplier, 400*wMultiplier, 0*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Aztec Sacrifice
        multiplyTechCost(player, 460, multiplier, 0*wMultiplier, 400*fMultiplier, 350*gMultiplier, 0*sMultiplier);
        // Britons City Rights
        multiplyTechCost(player, 461, multiplier, 800*wMultiplier, 0*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Chinese Great Wall
        multiplyTechCost(player, 462, multiplier, 400*wMultiplier, 0*fMultiplier, 0*gMultiplier, 200*sMultiplier);
        // Viking Chieftains
        multiplyTechCost(player, 463, multiplier, 0*wMultiplier, 700*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Byzantines Greek Fire
        multiplyTechCost(player, 464, multiplier, 0*wMultiplier, 250*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Elite Genoese Bow
        multiplyTechCost(player, 468, multiplier, 0*wMultiplier, 900*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Elite Magyar Huszar
        multiplyTechCost(player, 472, multiplier, 0*wMultiplier, 800*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Elite Elephant Archer
        multiplyTechCost(player, 481, multiplier, 0*wMultiplier, 1000*fMultiplier, 800*gMultiplier, 0*sMultiplier);
        // Stronghold
        multiplyTechCost(player, 482, multiplier, 0*wMultiplier, 250*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Huns UT
        multiplyTechCost(player, 483, multiplier, 300*wMultiplier, 0*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Japanese UT
        multiplyTechCost(player, 484, multiplier, 300*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Mayans UT
        multiplyTechCost(player, 485, multiplier, 0*wMultiplier, 300*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Koreans UT
        multiplyTechCost(player, 486, multiplier, 300*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Mongols UT
        multiplyTechCost(player, 487, multiplier, 300*wMultiplier, 0*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Persians UT
        multiplyTechCost(player, 488, multiplier, 0*wMultiplier, 400*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Teutons UT
        multiplyTechCost(player, 489, multiplier, 400*wMultiplier, 0*fMultiplier, 350*gMultiplier, 0*sMultiplier);
        // Saracens UT
        multiplyTechCost(player, 490, multiplier, 0*wMultiplier, 200*fMultiplier, 100*gMultiplier, 0*sMultiplier);
        // Sipahi
        multiplyTechCost(player, 491, multiplier, 0*wMultiplier, 350*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Spanish UT
        multiplyTechCost(player, 492, multiplier, 0*wMultiplier, 100*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Franks UT
        multiplyTechCost(player, 493, multiplier, 600*wMultiplier, 0*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Pavise
        multiplyTechCost(player, 494, multiplier, 0*wMultiplier, 300*fMultiplier, 150*gMultiplier, 0*sMultiplier);
        // Silk Route
        multiplyTechCost(player, 499, multiplier, 0*wMultiplier, 500*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Elite Siege Tower
        multiplyTechCost(player, 504, multiplier, 0*wMultiplier, 1000*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Indians UT
        multiplyTechCost(player, 506, multiplier, 400*wMultiplier, 400*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Indians UT2
        multiplyTechCost(player, 507, multiplier, 0*wMultiplier, 500*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Elite Kamayuk
        multiplyTechCost(player, 509, multiplier, 0*wMultiplier, 900*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Slavs UT
        multiplyTechCost(player, 512, multiplier, 0*wMultiplier, 200*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Slavs UT
        multiplyTechCost(player, 513, multiplier, 0*wMultiplier, 1200*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Magyars UT
        multiplyTechCost(player, 514, multiplier, 0*wMultiplier, 200*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Indians UT
        multiplyTechCost(player, 515, multiplier, 600*wMultiplier, 0*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Incas UT
        multiplyTechCost(player, 516, multiplier, 0*wMultiplier, 200*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Indians UT
        multiplyTechCost(player, 517, multiplier, 0*wMultiplier, 600*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Elite Organ Gun
        multiplyTechCost(player, 563, multiplier, 0*wMultiplier, 1200*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Elite Camel Archer
        multiplyTechCost(player, 565, multiplier, 1000*wMultiplier, 0*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Elite Mali Unit
        multiplyTechCost(player, 567, multiplier, 0*wMultiplier, 900*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Elite Ethiopia Unit
        multiplyTechCost(player, 569, multiplier, 0*wMultiplier, 1200*fMultiplier, 550*gMultiplier, 0*sMultiplier);
        // Portuguese UT
        multiplyTechCost(player, 572, multiplier, 200*wMultiplier, 0*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Portuguese UT
        multiplyTechCost(player, 573, multiplier, 0*wMultiplier, 700*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Ethiopian UT
        multiplyTechCost(player, 574, multiplier, 0*wMultiplier, 300*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Ethiopian UT
        multiplyTechCost(player, 575, multiplier, 0*wMultiplier, 1000*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Malian UT
        multiplyTechCost(player, 576, multiplier, 300*wMultiplier, 200*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Malian UT
        multiplyTechCost(player, 577, multiplier, 0*wMultiplier, 650*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Berber UT
        multiplyTechCost(player, 578, multiplier, 0*wMultiplier, 250*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Berber UT
        multiplyTechCost(player, 579, multiplier, 0*wMultiplier, 700*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Elite Ballista Elephant
        multiplyTechCost(player, 615, multiplier, 0*wMultiplier, 1000*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Elite Karambit Warrior
        multiplyTechCost(player, 617, multiplier, 0*wMultiplier, 900*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Elite Arambai
        multiplyTechCost(player, 619, multiplier, 0*wMultiplier, 1100*fMultiplier, 675*gMultiplier, 0*sMultiplier);
        // Elite Rattan Archer
        multiplyTechCost(player, 621, multiplier, 0*wMultiplier, 1000*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Khmer UT
        multiplyTechCost(player, 622, multiplier, 300*wMultiplier, 0*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Khmer UT
        multiplyTechCost(player, 623, multiplier, 0*wMultiplier, 700*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Malay UT
        multiplyTechCost(player, 624, multiplier, 0*wMultiplier, 300*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Malay UT
        multiplyTechCost(player, 625, multiplier, 0*wMultiplier, 850*fMultiplier, 500*gMultiplier, 0*sMultiplier);
        // Burmese UT
        multiplyTechCost(player, 626, multiplier, 300*wMultiplier, 400*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Burmese UT
        multiplyTechCost(player, 627, multiplier, 0*wMultiplier, 650*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Vietnamese UT
        multiplyTechCost(player, 628, multiplier, 0*wMultiplier, 250*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Vietnamese UT
        multiplyTechCost(player, 629, multiplier, 300*wMultiplier, 500*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Elite Konnik
        multiplyTechCost(player, 678, multiplier, 0*wMultiplier, 1000*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Elite Keshik
        multiplyTechCost(player, 680, multiplier, 0*wMultiplier, 700*fMultiplier, 900*gMultiplier, 0*sMultiplier);
        // Elite Kipchak
        multiplyTechCost(player, 682, multiplier, 1000*wMultiplier, 1100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Elite Leitis
        multiplyTechCost(player, 684, multiplier, 0*wMultiplier, 750*fMultiplier, 750*gMultiplier, 0*sMultiplier);
        // Khmer UT
        multiplyTechCost(player, 685, multiplier, 0*wMultiplier, 400*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Khmer UT
        multiplyTechCost(player, 686, multiplier, 0*wMultiplier, 900*fMultiplier, 450*gMultiplier, 0*sMultiplier);
        // Malay UT
        multiplyTechCost(player, 687, multiplier, 400*wMultiplier, 0*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Malay UT
        multiplyTechCost(player, 688, multiplier, 500*wMultiplier, 0*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Burmese UT
        multiplyTechCost(player, 689, multiplier, 300*wMultiplier, 200*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Burmese UT
        multiplyTechCost(player, 690, multiplier, 0*wMultiplier, 650*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Vietnamese UT
        multiplyTechCost(player, 691, multiplier, 0*wMultiplier, 250*fMultiplier, 250*gMultiplier, 0*sMultiplier);
        // Vietnamese UT
        multiplyTechCost(player, 692, multiplier, 0*wMultiplier, 500*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Elite Coustillier
        multiplyTechCost(player, 751, multiplier, 0*wMultiplier, 1000*fMultiplier, 800*gMultiplier, 0*sMultiplier);
        // Elite Serjeant
        multiplyTechCost(player, 753, multiplier, 0*wMultiplier, 1100*fMultiplier, 800*gMultiplier, 0*sMultiplier);
        // Burgundian Vineyards
        multiplyTechCost(player, 754, multiplier, 0*wMultiplier, 400*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Flemish Revolution
        multiplyTechCost(player, 755, multiplier, 0*wMultiplier, 1200*fMultiplier, 650*gMultiplier, 0*sMultiplier);
        // First Crusade
        multiplyTechCost(player, 756, multiplier, 0*wMultiplier, 300*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Hauberk
        multiplyTechCost(player, 757, multiplier, 0*wMultiplier, 500*fMultiplier, 400*gMultiplier, 0*sMultiplier);
        // Elite Obuch
        multiplyTechCost(player, 779, multiplier, 0*wMultiplier, 800*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Elite Hussite Wagon
        multiplyTechCost(player, 781, multiplier, 800*wMultiplier, 0*fMultiplier, 600*gMultiplier, 0*sMultiplier);
        // Szlachta Privileges
        multiplyTechCost(player, 782, multiplier, 0*wMultiplier, 500*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Lechitic Legacy
        multiplyTechCost(player, 783, multiplier, 0*wMultiplier, 750*fMultiplier, 550*gMultiplier, 0*sMultiplier);
        // Wagenburg Tactics
        multiplyTechCost(player, 784, multiplier, 0*wMultiplier, 300*fMultiplier, 300*gMultiplier, 0*sMultiplier);
        // Hussite Reforms
        multiplyTechCost(player, 785, multiplier, 0*wMultiplier, 800*fMultiplier, 450*gMultiplier, 0*sMultiplier);

        // ------MONASTERY------
        wMultiplier = monasteryWMultiplier;
        fMultiplier = monasteryFMultiplier;
        gMultiplier = monasteryGMultiplier;
        sMultiplier = monasterySMultiplier;
        
        // Redemption
        multiplyTechCost(player, 316, multiplier, 0*wMultiplier, 0*fMultiplier, 475*gMultiplier, 0*sMultiplier);
        // Atonement
        multiplyTechCost(player, 319, multiplier, 0*wMultiplier, 0*fMultiplier, 325*gMultiplier, 0*sMultiplier);
        // Fervor
        multiplyTechCost(player, 252, multiplier, 0*wMultiplier, 0*fMultiplier, 140*gMultiplier, 0*sMultiplier);
        // Faith
        multiplyTechCost(player, 45, multiplier, 0*wMultiplier, 750*fMultiplier, 1000*gMultiplier, 0*sMultiplier);
        // Block printing
        multiplyTechCost(player, 46, multiplier, 0*wMultiplier, 200*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Block Printing
        multiplyTechCost(player, 230, multiplier, 0*wMultiplier, 0*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Sanctity
        multiplyTechCost(player, 231, multiplier, 0*wMultiplier, 0*fMultiplier, 120*gMultiplier, 0*sMultiplier);
        // Illumination
        multiplyTechCost(player, 233, multiplier, 0*wMultiplier, 0*fMultiplier, 120*gMultiplier, 0*sMultiplier);
        // Theocracy
        multiplyTechCost(player, 438, multiplier, 0*wMultiplier, 0*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Heresy
        multiplyTechCost(player, 439, multiplier, 0*wMultiplier, 0*fMultiplier, 1000*gMultiplier, 0*sMultiplier);
        // Herbal Medicine
        multiplyTechCost(player, 441, multiplier, 0*wMultiplier, 0*fMultiplier, 200*gMultiplier, 0*sMultiplier);

        // ------TOWN CENTER------
        wMultiplier = tcAgeUpWMultiplier;
        fMultiplier = tcAgeUpFMultiplier;
        gMultiplier = tcAgeUpGMultiplier;
        sMultiplier = tcAgeUpSMultiplier;
        
        // Feudal Age
        multiplyTechCost(player, 101, multiplier, 0*wMultiplier, 500*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Castle Age
        multiplyTechCost(player, 102, multiplier, 0*wMultiplier, 800*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Imperial Age
        multiplyTechCost(player, 103, multiplier, 0*wMultiplier, 1000*fMultiplier, 800*gMultiplier, 0*sMultiplier);

        wMultiplier = tcOtherWMultiplier;
        fMultiplier = tcOtherFMultiplier;
        gMultiplier = tcOtherGMultiplier;
        sMultiplier = tcOtherSMultiplier;

        // Loom
        multiplyTechCost(player, 22, multiplier, 0*wMultiplier, 0*fMultiplier, 50*gMultiplier, 0*sMultiplier);
        // Town Watch
        multiplyTechCost(player, 8, multiplier, 0*wMultiplier, 75*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Town Patrol
        multiplyTechCost(player, 280, multiplier, 0*wMultiplier, 300*fMultiplier, 100*gMultiplier, 0*sMultiplier);

        wMultiplier = tcEcoWMultiplier;
        fMultiplier = tcEcoFMultiplier;
        gMultiplier = tcEcoGMultiplier;
        sMultiplier = tcEcoSMultiplier;

        // Wheel Barrow
        multiplyTechCost(player, 213, multiplier, 50*wMultiplier, 175*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Hand Cart
        multiplyTechCost(player, 249, multiplier, 200*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);

        // ------MINING CAMP------
        wMultiplier = mineWMultiplier;
        fMultiplier = mineFMultiplier;
        gMultiplier = mineGMultiplier;
        sMultiplier = mineSMultiplier;
        
        // Stone Mining
        multiplyTechCost(player, 278, multiplier, 75*wMultiplier, 100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Stone Shaft Mining
        multiplyTechCost(player, 279, multiplier, 150*wMultiplier, 200*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Gold Mining
        multiplyTechCost(player, 55, multiplier, 75*wMultiplier, 100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Gold Shaft Mining
        multiplyTechCost(player, 182, multiplier, 150*wMultiplier, 200*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        
        // ------LUMBER CAMP------
        wMultiplier = lumberWMultiplier;
        fMultiplier = lumberFMultiplier;
        gMultiplier = lumberGMultiplier;
        sMultiplier = lumberSMultiplier;

        // Double Bit Axe
        multiplyTechCost(player, 202, multiplier, 50*wMultiplier, 100*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Bow Saw
        multiplyTechCost(player, 203, multiplier, 100*wMultiplier, 150*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Two Man Saw
        multiplyTechCost(player, 221, multiplier, 200*wMultiplier, 300*fMultiplier, 0*gMultiplier, 0*sMultiplier);

        // ------MILL------
        wMultiplier = millWMultiplier;
        fMultiplier = millFMultiplier;
        gMultiplier = millGMultiplier;
        sMultiplier = millSMultiplier;

        // Horse collar
        multiplyTechCost(player, 14, multiplier, 75*wMultiplier, 75*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Heavy plow
        multiplyTechCost(player, 13, multiplier, 125*wMultiplier, 125*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // Crop rotation
        multiplyTechCost(player, 12, multiplier, 250*wMultiplier, 250*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        
        // ------MARKET------
        wMultiplier = marketWMultiplier;
        fMultiplier = marketFMultiplier;
        gMultiplier = marketGMultiplier;
        sMultiplier = marketSMultiplier;
        
        // Guilds
        multiplyTechCost(player, 15, multiplier, 0*wMultiplier, 300*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Banking
        multiplyTechCost(player, 17, multiplier, 0*wMultiplier, 300*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        // Coinage
        multiplyTechCost(player, 23, multiplier, 0*wMultiplier, 200*fMultiplier, 100*gMultiplier, 0*sMultiplier);

        wMultiplier = marketEcoWMultiplier;
        fMultiplier = marketEcoFMultiplier;
        gMultiplier = marketEcoGMultiplier;
        sMultiplier = marketEcoSMultiplier;
        
        // Caravan
        multiplyTechCost(player, 48, multiplier, 0*wMultiplier, 200*fMultiplier, 200*gMultiplier, 0*sMultiplier);
        
        // // ------??????------
        // float ?Multiplier = 1.0;
        // wMultiplier = ?Multiplier;
        // fMultiplier = ?Multiplier;
        // gMultiplier = ?Multiplier;
        // sMultiplier = ?Multiplier;

        // // Shadow Tower ------ Age Four
        // multiplyTechCost(player, 143, multiplier, 0*wMultiplier, 0*fMultiplier, 0*gMultiplier, 300*sMultiplier);
        // // Camelry
        // multiplyTechCost(player, 111, multiplier, 0*wMultiplier, 200*fMultiplier, 100*gMultiplier, 0*sMultiplier);
        // // Fire Tower (make avail)
        // multiplyTechCost(player, 525, multiplier, 10*wMultiplier, 0*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // // Hunting Dogs
        // multiplyTechCost(player, 526, multiplier, 25*wMultiplier, 40*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // // Fire Tower (make avail)
        // multiplyTechCost(player, 527, multiplier, 10*wMultiplier, 0*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // // Enable sheep
        // multiplyTechCost(player, 555, multiplier, 25*wMultiplier, 40*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // // Enable llamas
        // multiplyTechCost(player, 556, multiplier, 25*wMultiplier, 40*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // // Enable cows
        // multiplyTechCost(player, 557, multiplier, 25*wMultiplier, 40*fMultiplier, 0*gMultiplier, 0*sMultiplier);
        // // Enable turkeys
        // multiplyTechCost(player, 558, multiplier, 25*wMultiplier, 40*fMultiplier, 0*gMultiplier, 0*sMultiplier);

    }
    return;
}

void main() {

    // get current multiplier based on map size
    int multiplier = getMultiplier();

    adjustStartingResources(multiplier);
    adjustTechnologyCosts(multiplier);
    
}