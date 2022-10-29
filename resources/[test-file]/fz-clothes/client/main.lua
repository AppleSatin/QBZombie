QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("playAnim", function(a,b,c,d,e,f,g,h,i,j)
    print("tset")
    while not HasAnimDictLoaded(a) do
        RequestAnimDict(a)
        Wait(1)
    end
    TaskPlayAnim(PlayerPedId(), a, b, c, d, e, f, g, h, i, j)
end)


RegisterCommand("robclothes", function()
    exports['qb-menu']:openMenu({
        {
            header = "Rob Clothes",
            isMenuHeader = true, 
        },
        {
            header = "Steal Shoes",
            params = {
                event = "qb-usable-accessories:client:TheftShoe",
            }
        },
    })
end)