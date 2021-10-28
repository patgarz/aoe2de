# TODO: Put this into a pipeline to automatically update based on the source
# Will still need to manually add civ bonuses

$costData = Invoke-RestMethod -Method GET -Uri "https://raw.githubusercontent.com/SiegeEngineers/halfon/master/data/units_buildings_techs.de.json"
"" > xsContent.txt

for ($i = 0; $i -le 850; $i++) {
    $tech = $costData.techs.$i
    if (-Not ($tech.cost.wood -le 1 -and $tech.cost.food -le 1 -and $tech.cost.gold -le 1 -and $tech.cost.stone -le 1)) {
        if ($tech.localized_name) {
            @"
// $($tech.localised_name)
multiplyTechCost(player, $i, multiplier, $($tech.cost.wood), $($tech.cost.food), $($tech.cost.gold), $($tech.cost.stone));
"@ >> ./xscontent.txt
        } elseif ($tech.name) {
            @"
// $($tech.name)
multiplyTechCost(player, $i, multiplier, $($tech.cost.wood), $($tech.cost.food), $($tech.cost.gold), $($tech.cost.stone));
"@ >> ./xscontent.txt
        }
    }
}