local Module = {}

-- Generic Upgrades --

Module.IncreaseCustomerCount = {
    Upgrades = {{Name = "Hand out flyers", BaseCost = 7, Increase = 1, ImageId = 0}, {Name = "Text your friends", BaseCost = 12, Increase = 1, ImageId = 0}}
}

Module.AddTable = {{Name = "Buy a table", BaseCost = 200, Increase = 4, ImageId = 0}, {Name = "Buy a table", BaseCost = 100, Increase = 2, ImageId = 0}}

Module.IncreaseCarCount = {{Name = "Free car wash", BaseCost = 100, Increase = 1, ImageId = 0}, {Name = "Valet service", BaseCost = 200, Increase = 1, ImageId = 0}}

-- If the type is nil, the upgrade will relate to the local type of the restaurant. For example, if the restaurant has waiters, it will increase the number of waiters, but if it uses baristas, it will increase the number of baristas.
Module.IncreaseStaffCount = {{Name = "Hire Steve", BaseCost = 100, Increase = 1, Type = "Chef", ImageId = 0}, {Name = "Hire Bob", BaseCost = 200, Increase = 1, Type = nil, ImageId = 0}}

Module.IncreaseProfit = {{Name = "Bigger portions", BaseCost = 100, Increase = 1, ImageId = 0}, {Name = "Better ingredients", BaseCost = 200, Increase = 5, ImageId = 0}}

Module.DecreasePreparationTime = {{Name = "Make in batches", BaseCost = 300, ImageId = 0}}

-- If the type is nil, the upgrade will relate to the local type of the restaurant. For example, if the restaurant has waiters, it will increase the speed of the waiters, but if it uses baristas, it will increase the speed of the baristas.
Module.IncreaseStaffSpeed = {{Name = "Better shoes", BaseCost = 100, Type = "Chef", ImageId = 0}, {Name = "Cleaner floors", BaseCost = 200, Type = nil, ImageId = 0}}

-----

return Module