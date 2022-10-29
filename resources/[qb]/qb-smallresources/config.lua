Config = {}
Config.MaxWidth = 5.0
Config.MaxHeight = 5.0
Config.MaxLength = 5.0
Config.DamageNeeded = 100.0
Config.IdleCamera = true
Config.EnableProne = false
Config.JointEffectTime = 60
Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25
Config.DefaultPrice = 100 -- carwash
Config.DirtLevel = 0.1 --carwash dirt level

ConsumeablesEat = {
    ["sandwich"] = math.random(35, 54),
    ["tosti"] = math.random(40, 50),
    ["twerks_candy"] = math.random(35, 54),
    ["snikkel_candy"] = math.random(40, 50),
    ["burger-bleeder"] = math.random(35, 54),
    ["burger-moneyshot"] = math.random(35, 54),
    ["burger-torpedo"] = math.random(35, 54),
    ["burger-heartstopper"] = math.random(35, 54),
    ["burger-meatfree"] = math.random(35, 54),
    ["burger-fries"] = math.random(35, 54),
    ["muffin"] = math.random(15, 35),
    ["cookie"] = math.random(15, 35),
    ["eggsbacon"] = math.random(35, 54),
    ["panini"] = math.random(35, 54),
    ["donut"] = math.random(15, 34),
    ["icecream"] = math.random(15, 34),
    ["pancakes"] = math.random(25, 34),
    ["frenchtoast"] = math.random(25, 34),
    ["banana"] = math.random(25, 34),
    ["apple"] = math.random(10, 20),
    ["beef"] = math.random(35, 50),
    ["slicedpie"] = math.random(10, 20),
    ["corncob"] = math.random(25, 40),
    ["canofcorn"] = math.random(35, 50),
    ["grapes"] = math.random(10, 20),
    ["greenpepper"] = math.random(10, 20),
    ["chillypepper"] = math.random(10, 20),
    ["tomato"] = math.random(10, 20),
    ["tomatopaste"] = math.random(25, 40),
    ["cooked_bacon"] = math.random(35, 50),
    ["cooked_sausage"] = math.random(35, 50),
    ["cooked_pork"] = math.random(35, 50),
    ["cooked_ham"] = math.random(35, 50),

    --// Mc Dondalds
    ["bigchickensupreme"] = math.random(35, 50),
    ["bigdoublecheese"] = math.random(35, 50),
    ["bigmac"] = math.random(35, 50),
    ["mcd_fries"] = math.random(35, 50),
    ["mcd_nugget"] = math.random(35, 50),
    ["meal1"] = math.random(100, 100),
    --// Pearls
    ["cookedtaco"] = math.random(70, 80),
    ["cheesecake"] = math.random(50, 70),
    ["shushyplate"] = math.random(100, 100),
}

ConsumeablesDrink = {
    ["water_bottle"] = math.random(35, 54),
    ["kurkakola"] = math.random(35, 54),
    ["coffee"] = math.random(40, 50),
    ["burger-softdrink"] = math.random(40, 50),
    ["burger-mshake"] = math.random(40, 50),
    ["apple_juice"] = math.random(25, 45),
    ["grapejuice"] = math.random(25, 45),
    ["hotsauce"] = math.random(10, 15),
    
    --// MC Donalds 
    ["cocacola"] = math.random(70, 80),
    ["mshake"] = math.random(70, 80),
    ["meal1"] = math.random(100, 100),
    --// Pearls
    ["drinkp"] = math.random(100, 100),
}

ConsumeablesAlcohol = {
    ["whiskey"] = math.random(20, 30),
    ["beer"] = math.random(30, 40),
    ["vodka"] = math.random(20, 40),
    ["lean"] = math.random(100, 100),

    -- vu
    ["caipirinha"] = math.random(100, 100),
    ["cosmopolitan"] = math.random(100, 100),
    ["mai_tai"] = math.random(100, 100),
    ["margarita"] = math.random(100, 100),
    ["mint_julep"] = math.random(100, 100),
    ["mojito"] = math.random(100, 100),
    ["pina_colada"] = math.random(100, 100),
}

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
        "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
        "WORLD_VEHICLE_POLICE_CAR",
        "WORLD_VEHICLE_POLICE_BIKE",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}

Config.BlacklistedVehs = {
    [`SHAMAL`] = false,
    [`LUXOR`] = false,
    [`LUXOR2`] = false,
    [`JET`] = false,
    [`LAZER`] = false,
    [`BUZZARD`] = false,
    [`BUZZARD2`] = false,
    [`ANNIHILATOR`] = false,
    [`SAVAGE`] = false,
    [`TITAN`] = false,
    [`RHINO`] = false,
    [`FIRETRUK`] = false,
    [`MULE`] = false,
    [`MAVERICK`] = false,
    [`BLIMP`] = false,
    [`AIRTUG`] = false,
    [`CAMPER`] = false,
    [`HYDRA`] = false,
    [`OPPRESSOR`] = false,
    [`technical3`] = false,
    [`insurgent3`] = false,
    [`apc`] = false,
    [`tampa3`] = false,
    [`trailersmall2`] = false,
    [`halftrack`] = false,
    [`hunter`] = false,
    [`vigilante`] = false,
    [`akula`] = false,
    [`barrage`] = false,
    [`khanjali`] = false,
    [`caracara`] = false,
    [`blimp3`] = false,
    [`menacer`] = false,
    [`oppressor2`] = false,
    [`scramjet`] = false,
    [`strikeforce`] = false,
    [`cerberus`] = false,
    [`cerberus2`] = false,
    [`cerberus3`] = false,
    [`scarab`] = false,
    [`scarab2`] = false,
    [`scarab3`] = false,
    [`rrocket`] = false,
    [`ruiner2`] = false,
    [`deluxo`] = false,


-- fast cars need tuning

    [`voltic`] = true,  
    [`ninef`] = true,  
    [`ninef2`] = true, 
    [`jester`] = true,   
    
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}

Config.Teleports = {
    --Elevator @ labs
    [1] = {
        [1] = {
            coords = vector4(-151.58, -987.86, 29.37, 341.65),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vector4(-149.99, -983.71, 181.18, 141.59),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Down'
        },
    },
    [2] = {
        [1] = {
            coords = vector4(-151.85, -988.1, 181.18, 284.17),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vector4(-151.83, -988.17, 187.42, 342.78),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Down'
        },
    },
}

Config.CarWash = { -- carwash
    [1] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(25.29, -1391.96, 29.33),
    },
    [2] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(174.18, -1736.66, 29.35),
    },
    [3] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(-74.56, 6427.87, 31.44),
    },
    [5] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(1363.22, 3592.7, 34.92),
    },
    [6] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(-699.62, -932.7, 19.01),
    }
}
