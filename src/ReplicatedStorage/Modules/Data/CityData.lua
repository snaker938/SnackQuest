local Module = {}

Module.RestaurantMaxLevels = {
    SmallStand = 25,
    BigStand = 50,
    Truck = 75,
    SmallRestaurant = 150,
    BigRestaurant = 250
}

Module.NumStations = {
    SmallStand = 1,
    BigStand = 2,
    Truck = 4,
    SmallRestaurant = nil, -- This will use the function to calculate the number of stations (5-7)
    BigRestaurant = 10
}

Module.Cities = {
    { Name = "London", ImageId = 0, Restaurants = { "Lemonade Stand" } },
    { Name = "Paris", ImagId = 0, Restaurants = { "French Bistro" } }
}


Module.SmallStands = {
    { Name = "Lemonade Stand", ImageId = 8409545804102, FoodStations = { "Lemonade" } },
    { Name = "Popcorn Cart", ImageId = 0, FoodStations = { "Popcorn" } }
}

Module.BigStands = {
    { Name = "BBQ Stand", ImageId = 0, FoodStations = { "BBQ" } },
    -- { Name = "Hotpot Booth", ImageId = 0, FoodStations = { "Hotpot" } },
    { Name = "Sushi Stand", ImageId = 0, FoodStations = { "Sushi" } }

}

Module.Trucks = {
    { Name = "Food Truck", ImageId = 0, FoodStations = { "Special Combo" } },
    { Name = "Pizza Van", ImageId = 0, FoodStations = { "Cheese Pizza" } },
    { Name = "Sushi Truck" , ImageId = 0, FoodStations = { "Sushi Platter" } }
}

Module.SmallRestaurants = {
    { Name = "Cafe", ImageId = 0, FoodStations = { "Pancakes" } },
    { Name = "Diner", ImageId = 0, FoodStations = { "Bacon and Eggs" } },
    { Name = "Bistro", ImageId = 0, FoodStations = { "Steak Frites" } },
    {Name = "Pancake House", ImageId = 0, FoodStations = { "Pancakes" } }
}

Module.BigRestaurants = {
    { Name = "Steakhouse", ImageId = 0, FoodStations = { "Steak and Eggs" } },
    { Name = "French Bistro", ImageId = 0, FoodStations = { "Beef Bourguignon" } },
}

-- Function to get the name of a city based on its number
function Module.GetCityName(cityNumber)
    return Module.Cities[cityNumber].Name
end

-- Hash-like function to get a consistent number between 5 and 7 based on restaurant name
function Module.GetVarRestaurantStations(restaurantName)
    local sum = 0
    for i = 1, #restaurantName do
        sum = sum + restaurantName:byte(i)
    end
    return (sum % 3) + 5 -- Generates a number between 5 and 7
end

-- Function to get the number of stations for a restaurant
function Module.GetNumRestaurantStations(restaurantName)
    -- First check if it's a known category like SmallStand, BigStand, etc.
    for _, restaurant in ipairs(Module.SmallStands) do
        if restaurant.Name == restaurantName then
            return Module.NumStations.SmallStand
        end
    end

    for _, restaurant in ipairs(Module.BigStands) do
        if restaurant.Name == restaurantName then
            return Module.NumStations.BigStand
        end
    end

    for _, restaurant in ipairs(Module.Trucks) do
        if restaurant.Name == restaurantName then
            return Module.NumStations.Truck
        end
    end

    for _, restaurant in ipairs(Module.SmallRestaurants) do
        if restaurant.Name == restaurantName then
            return Module.GetVarRestaurantStations(restaurantName) -- Dynamic number between 5 and 7
        end
    end

    for _, restaurant in ipairs(Module.BigRestaurants) do
        if restaurant.Name == restaurantName then
            return Module.NumStations.BigRestaurant
        end
    end

    -- Default if restaurant is not found
    warn("Restaurant not found: " .. restaurantName)
    return nil
end


-- Function to get the base name of a restaurant
function Module.AreRestaurantsSimilar(restaurantName1, restaurantName2)
    -- Convert to lower case and split names into words
    local function getWords(name)
        name = name:lower():gsub("^%s*(.-)%s*$", "%1")
        local words = {}
        for word in name:gmatch("%S+") do
            words[word] = true
        end
        return words
    end

    local words1 = getWords(restaurantName1)
    local words2 = getWords(restaurantName2)

    -- Check for any common words
    for word in pairs(words1) do
        if words2[word] then
            return true -- Restaurants are similar
        end
    end
    return false -- Restaurants are not similar
end

-- Function to get the category of a restaurant
function Module.GetRestaurantCategory(restaurantName)
    for _, restaurant in ipairs(Module.SmallStands) do
        if restaurant.Name == restaurantName then
            return "SmallStands"
        end
    end

    for _, restaurant in ipairs(Module.BigStands) do
        if restaurant.Name == restaurantName then
            return "BigStands"
        end
    end

    for _, restaurant in ipairs(Module.Trucks) do
        if restaurant.Name == restaurantName then
            return "Trucks"
        end
    end

    for _, restaurant in ipairs(Module.SmallRestaurants) do
        if restaurant.Name == restaurantName then
            return "SmallRestaurants"
        end
    end

    for _, restaurant in ipairs(Module.BigRestaurants) do
        if restaurant.Name == restaurantName then
            return "BigRestaurants"
        end
    end

    return nil -- Not found
end

-- Function to get the list of restaurants in a city
function Module.GetCityRestaurants(cityNumber)
    local cityData = Module.Cities[cityNumber]
    if not cityData then
        warn("City not found: " .. cityNumber)
        return nil
    end

    local cityName = cityData.Name
    local cityRestaurants = {} -- Indexed by position (1-7)
    local overrides = cityData.Restaurants or {}
    local assignedSmallRestaurantPositions = {}
    local overrideCounts = {
        SmallStands = 0,
        BigStands = 0,
        Trucks = 0,
        SmallRestaurants = 0,
        BigRestaurants = 0
    }

    -- First, process overrides and check for conflicts and counts
    for _, restaurantName in ipairs(overrides) do
        local category = Module.GetRestaurantCategory(restaurantName)
        local position = nil

        if category == "SmallStands" then
            position = 1
            overrideCounts.SmallStands = overrideCounts.SmallStands + 1
            if overrideCounts.SmallStands > 1 then
                warn("Too many SmallStand overrides in city " .. cityName)
            end
        elseif category == "BigStands" then
            position = 2
            overrideCounts.BigStands = overrideCounts.BigStands + 1
            if overrideCounts.BigStands > 1 then
                warn("Too many BigStand overrides in city " .. cityName)
            end
        elseif category == "Trucks" then
            position = 3
            overrideCounts.Trucks = overrideCounts.Trucks + 1
            if overrideCounts.Trucks > 1 then
                warn("Too many Truck overrides in city " .. cityName)
            end
        elseif category == "SmallRestaurants" then
            overrideCounts.SmallRestaurants = overrideCounts.SmallRestaurants + 1
            if overrideCounts.SmallRestaurants > 3 then
                warn("Too many SmallRestaurant overrides in city " .. cityName)
            end
            for _, pos in ipairs({4, 5, 6}) do
                if not assignedSmallRestaurantPositions[pos] then
                    position = pos
                    assignedSmallRestaurantPositions[pos] = true
                    break
                end
            end
            if not position then
                warn("No available SmallRestaurant position for overridden restaurant " .. restaurantName .. " in city " .. cityName)
            end
        elseif category == "BigRestaurants" then
            position = 7
            overrideCounts.BigRestaurants = overrideCounts.BigRestaurants + 1
            if overrideCounts.BigRestaurants > 1 then
                warn("Too many BigRestaurant overrides in city " .. cityName)
            end
        else
            warn("Unknown category for restaurant " .. restaurantName)
        end

        if position then
            -- Check for conflicts with already assigned restaurants
            for assignedPos, assignedRestaurantName in pairs(cityRestaurants) do
                if Module.AreRestaurantsSimilar(restaurantName, assignedRestaurantName) then
                    -- Overriding restaurant takes priority
                    -- Attempt to find a replacement for the conflicting restaurant
                    local assignedCategory = Module.GetRestaurantCategory(assignedRestaurantName)
                    local replacementFound = false
                    local restaurantList = Module[assignedCategory]
                    table.sort(restaurantList, function(a, b) return a.Name < b.Name end)
                    for i = 1, #restaurantList do
                        local index = ((cityNumber + assignedPos + i - 2) % #restaurantList) + 1
                        local potentialRestaurant = restaurantList[index]
                        local potentialName = potentialRestaurant.Name
                        if not Module.AreRestaurantsSimilar(restaurantName, potentialName) and potentialName ~= assignedRestaurantName then
                            cityRestaurants[assignedPos] = potentialName
                            replacementFound = true
                            break
                        end
                    end
                    if not replacementFound then
                        warn("No suitable replacement found for restaurant " .. assignedRestaurantName .. " in city " .. cityName)
                    end
                    break
                end
            end

            -- Assign the overriding restaurant
            cityRestaurants[position] = restaurantName
            if category == "SmallRestaurants" then
                assignedSmallRestaurantPositions[position] = true
            end
        end
    end

    -- Fill in the rest of the positions
    local positions = {
        {pos = 1, category = "SmallStands"},
        {pos = 2, category = "BigStands"},
        {pos = 3, category = "Trucks"},
        {pos = 4, category = "SmallRestaurants"},
        {pos = 5, category = "SmallRestaurants"},
        {pos = 6, category = "SmallRestaurants"},
        {pos = 7, category = "BigRestaurants"},
    }

    for _, info in ipairs(positions) do
        local pos = info.pos
        local category = info.category

        if not cityRestaurants[pos] then
            local restaurantList = Module[category]
            table.sort(restaurantList, function(a, b) return a.Name < b.Name end)
            local found = false

            for i = 1, #restaurantList do
                local index = ((cityNumber + pos + i - 2) % #restaurantList) + 1
                local restaurant = restaurantList[index]
                local restaurantName = restaurant.Name

                -- Check for conflicts with already assigned restaurants
                local conflict = false
                for _, assignedRestaurantName in pairs(cityRestaurants) do
                    if Module.AreRestaurantsSimilar(restaurantName, assignedRestaurantName) then
                        conflict = true
                        break
                    end
                end

                if not conflict then
                    cityRestaurants[pos] = restaurantName
                    if category == "SmallRestaurants" then
                        assignedSmallRestaurantPositions[pos] = true
                    end
                    found = true
                    break
                end
            end

            if not found then
                warn("No suitable restaurant found for position " .. pos .. " in city " .. cityName)
            end
        end
    end

    return cityRestaurants
end

-- function Module.GetCityRestaurants(cityNumber)
--     local cityData = Module.Cities[cityNumber]
--     if not cityData then
--         warn("City not found: " .. cityNumber)
--         return nil
--     end

--     local cityName = cityData.Name
--     local cityRestaurants = {} -- Indexed by position (1-7)
--     local overrides = cityData.Restaurants or {}
--     local assignedCategories = {}
--     local assignedSmallRestaurantPositions = {}
--     local overrideCounts = {
--         SmallStands = 0,
--         BigStands = 0,
--         Trucks = 0,
--         SmallRestaurants = 0,
--         BigRestaurants = 0
--     }

--     -- First, process overrides and check for conflicts and counts
--     for _, restaurantName in ipairs(overrides) do
--         local category = Module.GetRestaurantCategory(restaurantName)
--         local position = nil

--         if category == "SmallStands" then
--             position = 1
--             overrideCounts.SmallStands = overrideCounts.SmallStands + 1
--             if overrideCounts.SmallStands > 1 then
--                 warn("Too many SmallStand overrides in city " .. cityName)
--             end
--         elseif category == "BigStands" then
--             position = 2
--             overrideCounts.BigStands = overrideCounts.BigStands + 1
--             if overrideCounts.BigStands > 1 then
--                 warn("Too many BigStand overrides in city " .. cityName)
--             end
--         elseif category == "Trucks" then
--             position = 3
--             overrideCounts.Trucks = overrideCounts.Trucks + 1
--             if overrideCounts.Trucks > 1 then
--                 warn("Too many Truck overrides in city " .. cityName)
--             end
--         elseif category == "SmallRestaurants" then
--             overrideCounts.SmallRestaurants = overrideCounts.SmallRestaurants + 1
--             if overrideCounts.SmallRestaurants > 3 then
--                 warn("Too many SmallRestaurant overrides in city " .. cityName)
--             end
--             for _, pos in ipairs({4, 5, 6}) do
--                 if not assignedSmallRestaurantPositions[pos] then
--                     position = pos
--                     assignedSmallRestaurantPositions[pos] = true
--                     break
--                 end
--             end
--             if not position then
--                 warn("No available SmallRestaurant position for overridden restaurant " .. restaurantName .. " in city " .. cityName)
--             end
--         elseif category == "BigRestaurants" then
--             position = 7
--             overrideCounts.BigRestaurants = overrideCounts.BigRestaurants + 1
--             if overrideCounts.BigRestaurants > 1 then
--                 warn("Too many BigRestaurant overrides in city " .. cityName)
--             end
--         else
--             warn("Unknown category for restaurant " .. restaurantName)
--         end

--         if position then
--             -- Check for conflicts with already assigned restaurants
--             for assignedPos, assignedRestaurantName in pairs(cityRestaurants) do
--                 if Module.AreRestaurantsSimilar(restaurantName, assignedRestaurantName) then
--                     -- Overriding restaurant takes priority
--                     -- Attempt to find a replacement for the conflicting restaurant
--                     local assignedCategory = Module.GetRestaurantCategory(assignedRestaurantName)
--                     local replacementFound = false
--                     local restaurantList = Module[assignedCategory]
--                     table.sort(restaurantList, function(a, b) return a.Name < b.Name end)
--                     for i = 1, #restaurantList do
--                         local index = ((cityNumber + assignedPos + i - 2) % #restaurantList) + 1
--                         local potentialRestaurant = restaurantList[index]
--                         local potentialName = potentialRestaurant.Name
--                         if not Module.AreRestaurantsSimilar(restaurantName, potentialName) and potentialName ~= assignedRestaurantName then
--                             cityRestaurants[assignedPos] = potentialName
--                             assignedCategories[potentialName] = assignedCategory
--                             replacementFound = true
--                             break
--                         end
--                     end
--                     if not replacementFound then
--                         warn("Warning 1: No suitable replacement found for restaurant " .. assignedRestaurantName .. " in city " .. cityName)
--                     end
--                     break
--                 end
--             end

--             -- Assign the overriding restaurant
--             cityRestaurants[position] = restaurantName
--             assignedCategories[restaurantName] = category
--             if category == "SmallRestaurants" then
--                 assignedSmallRestaurantPositions[position] = true
--             end
--         end
--     end

--     -- Fill in the rest of the positions
--     local positions = {
--         {pos = 1, category = "SmallStands"},
--         {pos = 2, category = "BigStands"},
--         {pos = 3, category = "Trucks"},
--         {pos = 4, category = "SmallRestaurants"},
--         {pos = 5, category = "SmallRestaurants"},
--         {pos = 6, category = "SmallRestaurants"},
--         {pos = 7, category = "BigRestaurants"},
--     }

--     for _, info in ipairs(positions) do
--         local pos = info.pos
--         local category = info.category

--         if not cityRestaurants[pos] then
--             local restaurantList = Module[category]
--             table.sort(restaurantList, function(a, b) return a.Name < b.Name end)
--             local found = false

--             for i = 1, #restaurantList do
--                 local index = ((cityNumber + pos + i - 2) % #restaurantList) + 1
--                 local restaurant = restaurantList[index]
--                 local restaurantName = restaurant.Name

--                 -- Check for conflicts with already assigned restaurants
--                 local conflict = false
--                 for assignedPos, assignedRestaurantName in pairs(cityRestaurants) do
--                     if Module.AreRestaurantsSimilar(restaurantName, assignedRestaurantName) then
--                         conflict = true
--                         break
--                     end
--                 end

--                 if not conflict then
--                     cityRestaurants[pos] = restaurantName
--                     assignedCategories[restaurantName] = category
--                     if category == "SmallRestaurants" then
--                         assignedSmallRestaurantPositions[pos] = true
--                     end
--                     found = true
--                     break
--                 end
--             end

--             if not found then
--                 -- Attempt to find a replacement for the conflicting restaurant
--                 local conflictingRestaurant = nil
--                 for i = 1, #restaurantList do
--                     local index = ((cityNumber + pos + i - 2) % #restaurantList) + 1
--                     local restaurant = restaurantList[index]
--                     local restaurantName = restaurant.Name

--                     -- Check if the restaurant conflicts and could not be assigned
--                     for assignedPos, assignedRestaurantName in pairs(cityRestaurants) do
--                         if Module.AreRestaurantsSimilar(restaurantName, assignedRestaurantName) then
--                             conflictingRestaurant = restaurantName
--                             break
--                         end
--                     end
--                     if conflictingRestaurant then
--                         break
--                     end
--                 end

--                 if conflictingRestaurant then
--                     warn("Warning 2: No suitable replacement found for restaurant " .. conflictingRestaurant .. " in city " .. cityName)
--                 else
--                     warn("No suitable restaurant found for position " .. pos .. " in city " .. cityName)
--                 end
--             end
--         end
--     end

--     return cityRestaurants
-- end








return Module
