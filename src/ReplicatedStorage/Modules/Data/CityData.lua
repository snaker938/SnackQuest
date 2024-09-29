local Module = {}

-- Sample city names. These will repeat indefinitely after 100 cities.
Module.CityNames = {
    "San Francisco", "New York", "Paris", "Tokyo", "Berlin", "London", "Sydney", "Rome", "Moscow", "Dubai",
    -- More city names up to 100 cities in total
}

-- Different types of restaurants for each category
Module.SmallStands = {
    { Name = "Lemonade Stand", Stations = 1, MaxLevel = 25 },
    { Name = "Popcorn Cart", Stations = 1, MaxLevel = 25 },
    { Name = "Ice Cream Stand", Stations = 1, MaxLevel = 25 },
    { Name = "Hotdog Stand", Stations = 1, MaxLevel = 25 },
    { Name = "Snack Shack", Stations = 1, MaxLevel = 25 },
    -- Add more small stands here
}

Module.BigStands = {
    { Name = "BBQ Stand", Stations = 2, MaxLevel = 50 },
    { Name = "Hotpot Booth", Stations = 2, MaxLevel = 50 },
    { Name = "Taco Truck", Stations = 2, MaxLevel = 50 },
    { Name = "Pasta Stand", Stations = 2, MaxLevel = 50 },
    { Name = "Juice Bar", Stations = 2, MaxLevel = 50 },
    -- Add more big stands here
}

Module.Trucks = {
    { Name = "Food Truck", Stations = 3, MaxLevel = 75 },
    { Name = "Pizza Van", Stations = 3, MaxLevel = 75 },
    { Name = "Burger Bus", Stations = 3, MaxLevel = 75 },
    { Name = "Coffee Truck", Stations = 3, MaxLevel = 75 },
    { Name = "BBQ Truck", Stations = 3, MaxLevel = 75 },
    -- Add more trucks here
}

Module.SmallRestaurants = {
    { Name = "Cafe", Stations = 4, MaxLevel = 150 },
    { Name = "Diner", Stations = 5, MaxLevel = 150 },
    { Name = "Sushi Bar", Stations = 6, MaxLevel = 150 },
    { Name = "Pizzeria", Stations = 7, MaxLevel = 150 },
    { Name = "Bistro", Stations = 4, MaxLevel = 150 },
    { Name = "Sandwich Shop", Stations = 5, MaxLevel = 150 },
    { Name = "Taco Joint", Stations = 6, MaxLevel = 150 },
    -- Add more small restaurants here
}

Module.BigRestaurants = {
    { Name = "Steakhouse", Stations = 10, MaxLevel = 250 },
    { Name = "Seafood Restaurant", Stations = 10, MaxLevel = 250 },
    { Name = "Buffet", Stations = 10, MaxLevel = 250 },
    { Name = "Fine Dining", Stations = 10, MaxLevel = 250 },
    { Name = "Luxury Restaurant", Stations = 10, MaxLevel = 250 },
    -- Add more big restaurants here
}

Module.RestaurantImageIds = {
    [1] = 84095458041020, -- Picture ID for Lemonade Stand
    -- Add more picture IDs here
}

function Module.GetRestaurantImageId(restaurantNumber)
    return Module.RestaurantImageIds[restaurantNumber]
end

-- Function to get the city name based on city number
function Module.GetCityName(cityNumber)
    local cityIndex = (cityNumber - 1) % #Module.CityNames + 1 -- Cycles through city names
    return Module.CityNames[cityIndex]
end

-- Function to get the restaurant data based on city number and restaurant number
function Module.GetRestaurantData(cityNumber, restaurantNumber)
    -- Define the progression structure
    if restaurantNumber == 1 then
        return Module.SmallStands[(cityNumber - 1) % #Module.SmallStands + 1]
    elseif restaurantNumber == 2 then
        return Module.BigStands[(cityNumber - 1) % #Module.BigStands + 1]
    elseif restaurantNumber == 3 then
        return Module.Trucks[(cityNumber - 1) % #Module.Trucks + 1]
    elseif restaurantNumber >= 4 and restaurantNumber <= 6 then
        -- Vary between 4 and 7 stations for small restaurants
        return Module.SmallRestaurants[(cityNumber - 1) % #Module.SmallRestaurants + 1]
    elseif restaurantNumber == 7 then
        return Module.BigRestaurants[(cityNumber - 1) % #Module.BigRestaurants + 1]
    else
        return nil -- No restaurant for invalid restaurantNumber
    end
end

function Module.GetCurrentRestaurantName(cityNumber, restaurantNumber)
    local restaurantData = Module.GetRestaurantData(cityNumber, restaurantNumber)
    return restaurantData.Name
end

-- Function to get the total number of restaurants in a city (either 6 or 7 depending on the city)
function Module.GetTotalRestaurantsInCity(cityNumber)
    if cityNumber % 10 == 0 then
        return 6 -- Every 10th city only has 6 restaurants
    else
        return 7 -- Default cities have 7 restaurants
    end
end

-- Function to get the next restaurant or city for progression
function Module.GetNextRestaurant(currentCity, currentRestaurant)
    local totalRestaurants = Module.GetTotalRestaurantsInCity(currentCity)
    if currentRestaurant < totalRestaurants then
        return {
            NextCity = currentCity,
            NextRestaurant = currentRestaurant + 1,
        }
    else
        -- Move to the next city after completing all restaurants
        return {
            NextCity = currentCity + 1,
            NextRestaurant = 1,
        }
    end
end

-- Example: Returns a full breakdown of a city's restaurants (for debugging or UI)
function Module.GetCityData(cityNumber)
    local cityData = {}
    cityData.CityName = Module.GetCityName(cityNumber)
    cityData.Restaurants = {}

    for i = 1, Module.GetTotalRestaurantsInCity(cityNumber) do
        table.insert(cityData.Restaurants, Module.GetRestaurantData(cityNumber, i))
    end

    return cityData
end

-- For testing purposes, this function will print out the data for the first few cities
function Module.DebugCityData()
    for cityNumber = 1, 5 do
        local cityData = Module.GetCityData(cityNumber)
        print("City: " .. cityData.CityName)
        for i, restaurant in ipairs(cityData.Restaurants) do
            print("  Restaurant " .. i .. ": " .. restaurant.Name .. " (Stations: " .. restaurant.Stations .. ", Max Level: " .. restaurant.MaxLevel .. ")")
        end
    end
end

return Module
