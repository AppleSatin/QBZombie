Config = {}

Config.StartingApartment = false -- Enable/disable starting apartments (make sure to set default spawn coords)

Config.Interior = vector3(-631.0, -229.63, 38.06) -- Interior to load where characters are previewed
Config.PedCoords = vector4(-690.3, -244.24, 37.04, 31.77) -- Create preview ped at these coordinates
Config.HiddenCoords =vector4(-690.3, -244.24, 37.04, 31.77) -- Hides your actual ped while you are in selection
Config.CamCoords = vector4(-708.8, -216.18, 37.11, 208.68) -- Camera coordinates for character preview screen
Config.DefaultSpawn = vector3(456.52, -746.06, 27.35) -- Default spawn coords if you have start apartments disabled

Config.PedToCoords = {
    ["pedtocoords"] = {
        [1] = vector3(-1453.93, -551.32, 72.84),
        [2] = vector3(-1454.209, -550.7174, 72.843757),  -- Ped walks to these coords
        [3] = vector3(-1454.977, -549.6193, 72.843765),
    },
}
