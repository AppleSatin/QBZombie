Config = {}

Config.StartingApartment = true -- Enable/disable starting apartments (make sure to set default spawn coords)

Config.Interior = vector3(-1453.56, -551.53, 72.84) -- Interior to load where characters are previewed
Config.PedCoords = vector4(-1451.538, -554.2218, 72.843765, 33.687664) -- Create preview ped at these coordinates
Config.HiddenCoords = vector4(-1453.58, -556.30, 72.88, 299.5) -- Hides your actual ped while you are in selection
Config.CamCoords = vector4(-1455.97, -547.68, 72.84, 216.51) -- Camera coordinates for character preview screen
Config.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) -- Default spawn coords if you have start apartments disabled

Config.PedToCoords = {
    ["pedtocoords"] = {
        [1] = vector3(-1453.93, -551.32, 72.84),
        [2] = vector3(-1454.209, -550.7174, 72.843757),  -- Ped walks to these coords
        [3] = vector3(-1454.977, -549.6193, 72.843765),
    },
}
