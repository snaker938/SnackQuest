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
    { Name = "Hotpot Booth", ImageId = 0, FoodStations = { "Spicy Hotpot" } },
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
    local overrides = cityData.Restaurants or {}

    -- Positions and their corresponding categories
    local positions = {
        [1] = "SmallStands",
        [2] = "BigStands",
        [3] = "Trucks",
        [4] = "SmallRestaurants",
        [5] = "SmallRestaurants",
        [6] = "SmallRestaurants",
        [7] = "BigRestaurants",
    }

    -- Initialize cityRestaurants with overrides
    local cityRestaurants = {}
    local usedRestaurantNames = {}

    -- Process overrides and assign them to their positions
    for _, restaurantName in ipairs(overrides) do
        local category = Module.GetRestaurantCategory(restaurantName)
        local position = nil
        local skipToNext = false

        if category == "SmallStands" then
            position = 1
        elseif category == "BigStands" then
            position = 2
        elseif category == "Trucks" then
            position = 3
        elseif category == "SmallRestaurants" then
            -- Assign to the first available small restaurant position
            for pos = 4, 6 do
                if not cityRestaurants[pos] then
                    position = pos
                    break
                end
            end
            if not position then
                warn("No available SmallRestaurant position for overridden restaurant " .. restaurantName .. " in city " .. cityName)
                skipToNext = true
            end
        elseif category == "BigRestaurants" then
            position = 7
        else
            warn("Unknown category for restaurant " .. restaurantName)
            skipToNext = true
        end

        if not skipToNext then
            -- Assign the overriding restaurant
            cityRestaurants[position] = restaurantName
            usedRestaurantNames[restaurantName] = true
        end
    end

    -- Function to attempt assignment with backtracking
    local function assignRestaurants(currentPos)
        -- If we've assigned all positions, return true
        if currentPos > 7 then
            return true
        end

        -- If the position is already assigned (probably by an override), proceed to next
        if cityRestaurants[currentPos] then
            -- Check for conflicts with already assigned restaurants
            local conflict = false
            for pos, assignedRestaurantName in pairs(cityRestaurants) do
                if pos ~= currentPos and Module.AreRestaurantsSimilar(cityRestaurants[currentPos], assignedRestaurantName) then
                    conflict = true
                    break
                end
            end

            if conflict then
                -- Cannot resolve conflict due to override; backtrack
                return false
            else
                -- Proceed to next position
                return assignRestaurants(currentPos + 1)
            end
        end

        local category = positions[currentPos]
        local restaurantList = Module[category]
        table.sort(restaurantList, function(a, b) return a.Name < b.Name end)

        for _, restaurant in ipairs(restaurantList) do
            local restaurantName = restaurant.Name

            -- Skip used restaurants
            if not usedRestaurantNames[restaurantName] then
                -- Check for conflicts with already assigned restaurants
                local conflict = false
                for _, assignedRestaurantName in pairs(cityRestaurants) do
                    if Module.AreRestaurantsSimilar(restaurantName, assignedRestaurantName) then
                        conflict = true
                        break
                    end
                end

                if not conflict then
                    -- Assign restaurant to current position
                    cityRestaurants[currentPos] = restaurantName
                    usedRestaurantNames[restaurantName] = true

                    -- Recurse to next position
                    if assignRestaurants(currentPos + 1) then
                        return true
                    end

                    -- Backtrack
                    cityRestaurants[currentPos] = nil
                    usedRestaurantNames[restaurantName] = nil
                end
            end
        end

        -- No valid assignment found for current position
        return false
    end

    -- Start the assignment process from position 1
    local success = assignRestaurants(1)
    if success then
        return cityRestaurants
    else
        warn("Could not assign restaurants for city " .. cityName .. " without conflicts.")
        return cityRestaurants -- Return the partial assignment
    end
end

return Module
