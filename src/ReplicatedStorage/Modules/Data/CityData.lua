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
    { Name = "London", ImageId = 0, Restaurants = { "Lemonade Stand", "Fish and Chip Shop" } },
    { Name = "Paris", ImagId = 0, Restaurants = { "French Bistro" } }
}


Module.SmallStands = {
    { Name = "Lemonade Stand", ImageId = 8409545804102, FoodStation = { Name = "Lemonade", ImageId = 0 } },
    { Name = "Popcorn Cart", ImageId = 0, FoodStation = { Name = "Popcorn", ImageId = 0 } },
    { Name = "Ice Cream Stall", ImageId = 0, FoodStation = { Name = "Ice Cream", ImageId = 0 } },
    { Name = "Hot Dog Stand", ImageId = 0, FoodStation = { Name = "Hot Dogs", ImageId = 0 } },
    { Name = "Pretzel Cart", ImageId = 0, FoodStation = { Name = "Pretzels", ImageId = 0 } },
    { Name = "Smoothie Shack", ImageId = 0, FoodStation = { Name = "Smoothies", ImageId = 0 } },
    { Name = "Fruit Stand", ImageId = 0, FoodStation = { Name = "Fresh Fruit", ImageId = 0 } },
    { Name = "Juice Bar", ImageId = 0, FoodStation = { Name = "Fresh Juice", ImageId = 0 } },
    { Name = "Coffee Kiosk", ImageId = 0, FoodStation = { Name = "Coffee", ImageId = 0 } },
    { Name = "Donut Stand", ImageId = 0, FoodStation = { Name = "Donuts", ImageId = 0 } },
    { Name = "Churro Cart", ImageId = 0, FoodStation = { Name = "Churros", ImageId = 0 } },
    { Name = "Corn Roaster", ImageId = 0, FoodStation = { Name = "Roasted Corn", ImageId = 0 } },
    { Name = "Candy Floss Stall", ImageId = 0, FoodStation = { Name = "Candy Floss", ImageId = 0 } },
    { Name = "Bubble Tea Stand", ImageId = 0, FoodStation = { Name = "Bubble Tea", ImageId = 0 } },
    { Name = "Waffle Wagon", ImageId = 0, FoodStation = { Name = "Waffles", ImageId = 0 } },
    { Name = "Oyster Bar", ImageId = 0, FoodStation = { Name = "Fresh Oysters", ImageId = 0 } },
    { Name = "Crepe Cart", ImageId = 0, FoodStation = { Name = "Sweet Crepes", ImageId = 0 } },
    { Name = "Pancake Stand", ImageId = 0, FoodStation = { Name = "Mini Pancakes", ImageId = 0 } },
    { Name = "Nacho Stand", ImageId = 0, FoodStation = { Name = "Nachos", ImageId = 0 } },
    { Name = "Falafel Cart", ImageId = 0, FoodStation = { Name = "Falafels", ImageId = 0 } },
}

Module.BigStands = {
    { Name = "BBQ Stand", ImageId = 0, FoodStation = { Name = "BBQ", ImageId = 0 } },
    { Name = "Hotpot Booth", ImageId = 0, FoodStation = { Name = "Spicy Hotpot", ImageId = 0 } },
    { Name = "Sushi Stand", ImageId = 0, FoodStation = { Name = "Sushi", ImageId = 0 } },
    { Name = "Taco Stall", ImageId = 0, FoodStation = { Name = "Tacos", ImageId = 0 } },
    { Name = "Burger Grill", ImageId = 0, FoodStation = { Name = "Burgers", ImageId = 0 } },
    { Name = "Pasta Corner", ImageId = 0, FoodStation = { Name = "Pasta", ImageId = 0 } },
    { Name = "Salad Bar", ImageId = 0, FoodStation = { Name = "Salads", ImageId = 0 } },
    { Name = "Seafood Shack", ImageId = 0, FoodStation = { Name = "Seafood", ImageId = 0 } },
    { Name = "Kebab House", ImageId = 0, FoodStation = { Name = "Kebabs", ImageId = 0 } },
    { Name = "Crepe Stand", ImageId = 0, FoodStation = { Name = "Crepes", ImageId = 0 } },
    { Name = "Ramen Stall", ImageId = 0, FoodStation = { Name = "Ramen", ImageId = 0 } },
    { Name = "Paella Stand", ImageId = 0, FoodStation = { Name = "Paella", ImageId = 0 } },
    { Name = "Curry Corner", ImageId = 0, FoodStation = { Name = "Curry", ImageId = 0 } },
    { Name = "BBQ Rib Shack", ImageId = 0, FoodStation = { Name = "BBQ Ribs", ImageId = 0 } },
    { Name = "Dumpling House", ImageId = 0, FoodStation = { Name = "Dumplings", ImageId = 0 } },
    { Name = "Pho Stall", ImageId = 0, FoodStation = { Name = "Pho", ImageId = 0 } },
    { Name = "Burrito Bar", ImageId = 0, FoodStation = { Name = "Burritos", ImageId = 0 } },
    { Name = "Gourmet Hot Dog Stand", ImageId = 0, FoodStation = { Name = "Gourmet Hot Dogs", ImageId = 0 } },
    { Name = "Tapas Stall", ImageId = 0, FoodStation = { Name = "Tapas", ImageId = 0 } },
    { Name = "Fish and Chips Stand", ImageId = 0, FoodStation = { Name = "Fish and Chips", ImageId = 0 } },
}

Module.Trucks = {
    { Name = "Food Truck", ImageId = 0, FoodStation = { Name = "Special Combo", ImageId = 0 } },
    { Name = "Pizza Van", ImageId = 0, FoodStation = { Name = "Cheese Pizza", ImageId = 0 } },
    { Name = "Sushi Truck", ImageId = 0, FoodStation = { Name = "Sushi Platter", ImageId = 0 } },
    { Name = "BBQ Truck", ImageId = 0, FoodStation = { Name = "BBQ Ribs", ImageId = 0 } },
    { Name = "Dessert Truck", ImageId = 0, FoodStation = { Name = "Cupcakes", ImageId = 0 } },
    { Name = "Vegan Van", ImageId = 0, FoodStation = { Name = "Vegan Wraps", ImageId = 0 } },
    { Name = "Coffee Truck", ImageId = 0, FoodStation = { Name = "Espresso", ImageId = 0 } },
    { Name = "Taco Truck", ImageId = 0, FoodStation = { Name = "Loaded Tacos", ImageId = 0 } },
    { Name = "Ice Cream Truck", ImageId = 0, FoodStation = { Name = "Gelato", ImageId = 0 } },
    { Name = "Pasta Truck", ImageId = 0, FoodStation = { Name = "Gourmet Pasta", ImageId = 0 } },
    { Name = "Burger Bus", ImageId = 0, FoodStation = { Name = "Gourmet Burgers", ImageId = 0 } },
    { Name = "Crepe Mobile", ImageId = 0, FoodStation = { Name = "Savory Crepes", ImageId = 0 } },
    { Name = "Seafood Truck", ImageId = 0, FoodStation = { Name = "Shrimp Tacos", ImageId = 0 } },
    { Name = "Noodle Truck", ImageId = 0, FoodStation = { Name = "Stir Fry Noodles", ImageId = 0 } },
    { Name = "Falafel Truck", ImageId = 0, FoodStation = { Name = "Falafel Wraps", ImageId = 0 } },
    { Name = "Grilled Cheese Truck", ImageId = 0, FoodStation = { Name = "Grilled Cheese Sandwiches", ImageId = 0 } },
    { Name = "Poutine Wagon", ImageId = 0, FoodStation = { Name = "Poutine", ImageId = 0 } },
    { Name = "Juice Truck", ImageId = 0, FoodStation = { Name = "Fresh Smoothies", ImageId = 0 } },
    { Name = "Churro Truck", ImageId = 0, FoodStation = { Name = "Churros", ImageId = 0 } },
    { Name = "Waffle Truck", ImageId = 0, FoodStation = { Name = "Belgian Waffles", ImageId = 0 } },
}

Module.SmallRestaurants = {
    { Name = "Cafe", ImageId = 0, FoodStation = { Name = "Pancakes", ImageId = 0 } },
    { Name = "Diner", ImageId = 0, FoodStation = { Name = "Bacon and Eggs", ImageId = 0 } },
    { Name = "Bistro", ImageId = 0, FoodStation = { Name = "Steak Frites", ImageId = 0 } },
    { Name = "Pancake House", ImageId = 0, FoodStation = { Name = "Blueberry Pancakes", ImageId = 0 } },
    { Name = "Noodle Bar", ImageId = 0, FoodStation = { Name = "Ramen", ImageId = 0 } },
    { Name = "Sandwich Shop", ImageId = 0, FoodStation = { Name = "Club Sandwich", ImageId = 0 } },
    { Name = "Tapas Place", ImageId = 0, FoodStation = { Name = "Tapas Selection", ImageId = 0 } },
    { Name = "Soup Kitchen", ImageId = 0, FoodStation = { Name = "Tomato Soup", ImageId = 0 } },
    { Name = "Bagel Bakery", ImageId = 0, FoodStation = { Name = "Cream Cheese Bagel", ImageId = 0 } },
    { Name = "Salad Stop", ImageId = 0, FoodStation = { Name = "Caesar Salad", ImageId = 0 } },
    { Name = "Pizzeria", ImageId = 0, FoodStation = { Name = "Margherita Pizza", ImageId = 0 } },
    { Name = "Sushi Express", ImageId = 0, FoodStation = { Name = "Nigiri", ImageId = 0 } },
    { Name = "Burger Joint", ImageId = 0, FoodStation = { Name = "Cheeseburger", ImageId = 0 } },
    { Name = "Crepe Cafe", ImageId = 0, FoodStation = { Name = "Nutella Crepes", ImageId = 0 } },
    { Name = "Mexican Cantina", ImageId = 0, FoodStation = { Name = "Quesadillas", ImageId = 0 } },
    { Name = "BBQ Pit", ImageId = 0, FoodStation = { Name = "Pulled Pork Sandwich", ImageId = 0 } },
    { Name = "Fish and Chip Shop", ImageId = 0, FoodStation = { Name = "Fish and Chips", ImageId = 0 } },
    { Name = "Bakery", ImageId = 0, FoodStation = { Name = "Croissants", ImageId = 0 } },
    { Name = "Pasta Place", ImageId = 0, FoodStation = { Name = "Spaghetti Bolognese", ImageId = 0 } },
    { Name = "Vegetarian Cafe", ImageId = 0, FoodStation = { Name = "Veggie Burger", ImageId = 0 } },
}

Module.BigRestaurants = {
    { Name = "Steakhouse", ImageId = 0, FoodStation = { Name = "Steak and Eggs", ImageId = 0, Upgrades = { "" } } },
    { Name = "French Bistro", ImageId = 0, FoodStation = { Name = "Beef Bourguignon", ImageId = 0 } },
    { Name = "Italian Restaurant", ImageId = 0, FoodStation = { Name = "Lasagna", ImageId = 0 } },
    { Name = "Seafood Restaurant", ImageId = 0, FoodStation = { Name = "Grilled Salmon", ImageId = 0 } },
    { Name = "Sushi Bar", ImageId = 0, FoodStation = { Name = "Sashimi Platter", ImageId = 0 } },
    { Name = "Mexican Grill", ImageId = 0, FoodStation = { Name = "Fajitas", ImageId = 0 } },
    { Name = "Indian Cuisine", ImageId = 0, FoodStation = { Name = "Butter Chicken", ImageId = 0 } },
    { Name = "Chinese Buffet", ImageId = 0, FoodStation = { Name = "Dim Sum", ImageId = 0 } },
    { Name = "Brazilian Steakhouse", ImageId = 0, FoodStation = { Name = "Churrasco", ImageId = 0 } },
    { Name = "Mediterranean Restaurant", ImageId = 0, FoodStation = { Name = "Greek Salad", ImageId = 0 } },
    { Name = "Thai Palace", ImageId = 0, FoodStation = { Name = "Pad Thai", ImageId = 0 } },
    { Name = "Korean BBQ", ImageId = 0, FoodStation = { Name = "Korean BBQ", ImageId = 0 } },
    { Name = "German Beer Hall", ImageId = 0, FoodStation = { Name = "Bratwurst", ImageId = 0 } },
    { Name = "French Gourmet", ImageId = 0, FoodStation = { Name = "Coq au Vin", ImageId = 0 } },
    { Name = "Spanish Tapas", ImageId = 0, FoodStation = { Name = "Paella", ImageId = 0 } },
    { Name = "Moroccan Delight", ImageId = 0, FoodStation = { Name = "Tagine", ImageId = 0 } },
    { Name = "Japanese Teppanyaki", ImageId = 0, FoodStation = { Name = "Teppanyaki Grill", ImageId = 0 } },
    { Name = "Lebanese Restaurant", ImageId = 0, FoodStation = { Name = "Shawarma", ImageId = 0 } },
    { Name = "American Diner", ImageId = 0, FoodStation = { Name = "Ribs and Fries", ImageId = 0 } },
    { Name = "Middle Eastern Grill", ImageId = 0, FoodStation = { Name = "Falafel Platter", ImageId = 0 } },
}

----------------- Private Functions -----------------

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

-- Function to get the stations for all restaurants in a city
function Module.GetCityStations(cityNumber)
    -- Get the list of restaurants for the city
    local cityRestaurants = Module.GetCityRestaurants(cityNumber)
    if not cityRestaurants then
        warn("Could not retrieve restaurants for city number " .. cityNumber)
        return nil
    end

    local cityStations = {}
    local usedStationNames = {}

    -- Seed for deterministic selection based on cityNumber
    local citySeed = cityNumber * 10000

    -- Iterate over each restaurant position (1-7)
    for restaurantNum = 1, 7 do
        local restaurantName = cityRestaurants[restaurantNum]
        if restaurantName then
            -- Now proceed as before, using restaurantName
            local category = Module.GetRestaurantCategory(restaurantName)
            if not category then
                warn("Unknown category for restaurant " .. restaurantName)
                return nil
            end

            -- Get the restaurant data
            local restaurantData = nil
            for _, r in ipairs(Module[category]) do
                if r.Name == restaurantName then
                    restaurantData = r
                    break
                end
            end
            if not restaurantData then
                warn("Restaurant data not found for " .. restaurantName)
                return nil
            end

            -- Get the number of stations
            local numStations = Module.GetNumRestaurantStations(restaurantName)
            if not numStations then
                warn("Could not determine number of stations for " .. restaurantName)
                return nil
            end

            -- Initialize the list of stations for this restaurant
            local stations = {}

            -- Seed for deterministic selection based on cityNumber, restaurantName, and restaurantNum
            local seed = citySeed
            for i = 1, #restaurantName do
                seed = seed + restaurantName:byte(i)
            end
            seed = seed + restaurantNum * 100

            -- Function to get stations from a category, excluding used stations and own station
            local function getStationsFromCategory(categoryList, ownStationName)
                local stationList = {}
                for _, r in ipairs(categoryList) do
                    local fs = r.FoodStation
                    if fs.Name ~= ownStationName and not usedStationNames[fs.Name] then
                        table.insert(stationList, fs)
                    end
                end
                return stationList
            end

            local ownStation = restaurantData.FoodStation
            local ownStationName = ownStation.Name
            usedStationNames[ownStationName] = true -- Own station is already used

            if category == "SmallStands" then
                -- Small stand: one station, which is its own station
                stations[1] = ownStation

            elseif category == "BigStands" then
                -- Big stand: first station is small station, second is its own station
                local smallStations = getStationsFromCategory(Module.SmallStands, ownStationName)
                if #smallStations == 0 then
                    warn("No small stations available for big stand " .. restaurantName)
                    return nil
                end
                local index = (seed % #smallStations) + 1
                stations[1] = smallStations[index]
                usedStationNames[stations[1].Name] = true
                stations[2] = ownStation

            elseif category == "Trucks" then
                -- Truck: first station is small station, second is big station, third is another big station, fourth is its station
                local smallStations = getStationsFromCategory(Module.SmallStands, ownStationName)
                local bigStations = getStationsFromCategory(Module.BigStands, ownStationName)
                if #smallStations == 0 or #bigStations < 2 then
                    warn("Not enough stations available for truck " .. restaurantName)
                    return nil
                end
                local index = (seed % #smallStations) + 1
                stations[1] = smallStations[index]
                usedStationNames[stations[1].Name] = true

                index = ((seed + 1) % #bigStations) + 1
                stations[2] = bigStations[index]
                usedStationNames[stations[2].Name] = true

                -- Remove the used big station
                table.remove(bigStations, index)
                if #bigStations == 0 then
                    warn("Not enough big stations available for truck " .. restaurantName)
                    return nil
                end

                index = ((seed + 2) % #bigStations) + 1
                stations[3] = bigStations[index]
                usedStationNames[stations[3].Name] = true

                stations[4] = ownStation

            elseif category == "SmallRestaurants" then
                -- Small restaurant: variable number of stations (5-7)
                -- Pattern as specified
                local smallStations = getStationsFromCategory(Module.SmallStands, ownStationName)
                local bigStations = getStationsFromCategory(Module.BigStands, ownStationName)
                local truckStations = getStationsFromCategory(Module.Trucks, ownStationName)
                local smallRestaurantStations = getStationsFromCategory(Module.SmallRestaurants, ownStationName)
                if #smallStations == 0 or #bigStations < 2 or #truckStations == 0 then
                    warn("Not enough stations available for small restaurant " .. restaurantName)
                    return nil
                end

                stations[1] = smallStations[(seed % #smallStations) + 1]
                usedStationNames[stations[1].Name] = true

                stations[2] = bigStations[(seed + 1) % #bigStations + 1]
                usedStationNames[stations[2].Name] = true

                -- Remove used big station
                table.remove(bigStations, ((seed + 1) % #bigStations) + 1)
                if #bigStations == 0 then
                    warn("Not enough big stations available for small restaurant " .. restaurantName)
                    return nil
                end

                stations[3] = bigStations[(seed + 2) % #bigStations + 1]
                usedStationNames[stations[3].Name] = true

                stations[4] = truckStations[(seed + 3) % #truckStations + 1]
                usedStationNames[stations[4].Name] = true

                -- Fifth and sixth stations
                local possibleStations = {}
                for _, s in ipairs(truckStations) do
                    if not usedStationNames[s.Name] then table.insert(possibleStations, s) end
                end
                for _, s in ipairs(bigStations) do
                    if not usedStationNames[s.Name] then table.insert(possibleStations, s) end
                end
                for _, s in ipairs(smallRestaurantStations) do
                    if not usedStationNames[s.Name] then table.insert(possibleStations, s) end
                end

                local currentIndex = 5
                while currentIndex <= numStations - 1 and #possibleStations > 0 do
                    local index = ((seed + currentIndex) % #possibleStations) + 1
                    stations[currentIndex] = possibleStations[index]
                    usedStationNames[stations[currentIndex].Name] = true
                    table.remove(possibleStations, index)
                    currentIndex = currentIndex + 1
                end

                -- Final station is own station
                stations[numStations] = ownStation

            elseif category == "BigRestaurants" then
                -- Big restaurant: 10 stations
                local smallStations = getStationsFromCategory(Module.SmallStands, ownStationName)
                local bigStations = getStationsFromCategory(Module.BigStands, ownStationName)
                local truckStations = getStationsFromCategory(Module.Trucks, ownStationName)
                local smallRestaurantStations = getStationsFromCategory(Module.SmallRestaurants, ownStationName)
                if #smallStations == 0 or #bigStations < 4 or #truckStations == 0 then
                    warn("Not enough stations available for big restaurant " .. restaurantName)
                    return nil
                end

                stations[1] = smallStations[(seed % #smallStations) + 1]
                usedStationNames[stations[1].Name] = true

                stations[2] = bigStations[(seed + 1) % #bigStations + 1]
                usedStationNames[stations[2].Name] = true

                -- Remove used big station
                table.remove(bigStations, ((seed + 1) % #bigStations) + 1)

                stations[3] = bigStations[(seed + 2) % #bigStations + 1]
                usedStationNames[stations[3].Name] = true

                stations[4] = truckStations[(seed + 3) % #truckStations + 1]
                usedStationNames[stations[4].Name] = true

                -- Fifth to seventh stations
                local possibleStations = {}
                for _, s in ipairs(truckStations) do
                    if not usedStationNames[s.Name] then table.insert(possibleStations, s) end
                end
                for _, s in ipairs(bigStations) do
                    if not usedStationNames[s.Name] then table.insert(possibleStations, s) end
                end
                for _, s in ipairs(smallRestaurantStations) do
                    if not usedStationNames[s.Name] then table.insert(possibleStations, s) end
                end

                local currentIndex = 5
                while currentIndex <= 7 and #possibleStations > 0 do
                    local index = ((seed + currentIndex) % #possibleStations) + 1
                    stations[currentIndex] = possibleStations[index]
                    usedStationNames[stations[currentIndex].Name] = true
                    table.remove(possibleStations, index)
                    currentIndex = currentIndex + 1
                end

                -- Eighth and ninth stations are big stations
                local remainingBigStations = {}
                for _, s in ipairs(bigStations) do
                    if not usedStationNames[s.Name] then table.insert(remainingBigStations, s) end
                end
                if #remainingBigStations < 2 then
                    warn("Not enough big stations available for big restaurant " .. restaurantName)
                    return nil
                end

                stations[8] = remainingBigStations[(seed + 8) % #remainingBigStations + 1]
                usedStationNames[stations[8].Name] = true

                -- Remove used big station
                table.remove(remainingBigStations, ((seed + 8) % #remainingBigStations) + 1)
                stations[9] = remainingBigStations[(seed + 9) % #remainingBigStations + 1]
                usedStationNames[stations[9].Name] = true

                -- Final station is own station
                stations[10] = ownStation

            else
                warn("Unknown restaurant category for " .. restaurantName)
                return nil
            end

            -- Store the stations for this restaurant
            cityStations[restaurantNum] = stations

        else
            -- No restaurant assigned to this position
            cityStations[restaurantNum] = {}
        end
    end

    return cityStations
end


----------------- Public Functions -----------------
-- Function to get the restaurants and their stations for a city
function Module.GetCityStationsTable(cityNumber)
    -- Get the list of restaurants for the city
    local cityRestaurants = Module.GetCityRestaurants(cityNumber)
    if not cityRestaurants then
        warn("Could not retrieve restaurants for city number " .. cityNumber)
        return nil
    end

    -- Get the stations for all restaurants in the city
    local cityStations = Module.GetCityStations(cityNumber)
    if not cityStations then
        warn("Could not retrieve stations for city number " .. cityNumber)
        return nil
    end

    local stationsTable = {}

    -- Iterate over each restaurant position (1-7)
    for restaurantNum = 1, 7 do
        local restaurantName = cityRestaurants[restaurantNum]
        local stations = cityStations[restaurantNum]
        local stationNames = {}
        if stations then
            for i, station in ipairs(stations) do
                stationNames[i] = station.Name
            end
        end
        -- Store in the table
        stationsTable[restaurantNum] = {
            RestaurantName = restaurantName,
            Stations = stationNames
        }
    end

    -- Return the table instead of printing
    return stationsTable
end

-- Function to get the stations for a specific restaurant in a city
function Module.GetRestaurantStations(cityNumber, restaurantNum)
    local cityStations = Module.GetCityStations(cityNumber)
    if cityStations and cityStations[restaurantNum] then
        return cityStations[restaurantNum]
    else
        warn("Could not retrieve stations for restaurant number " .. restaurantNum .. " in city number " .. cityNumber)
        return nil
    end
end



return Module
