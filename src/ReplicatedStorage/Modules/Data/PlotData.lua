local Module = {}

-- PlotData table storing both position and orientation for each plot
Module.PlotData = {
    [1] = {
        Position = Vector3.new(377.824, 35.401, 171.608),
        Orientation = Vector3.new(0, 90, 0)
    },
    [2] = {
        Position = Vector3.new(524.724, 35.401, 24.908),
        Orientation = Vector3.new(0, -180, 0)
    },
    [3] = {
        Position = Vector3.new(377.824, 35.401, -122.492),
        Orientation = Vector3.new(0, 90, 0)
    },
    [4] = {
        Position = Vector3.new(231.324, 35.401, 24.908),
        Orientation = Vector3.new(0, -180, 0)
    }
}

-- Function to get plot data for a specific plot number
function Module.GetPlotData(plotNumber, dataType)
    local plot = Module.PlotData[plotNumber]

    if not plot then
        return nil -- Return nil if the plot number is invalid
    end

    if dataType == "position" then
        return plot.Position
    elseif dataType == "orientation" then
        return plot.Orientation
    else
        return nil -- Return nil if an invalid data type is passed
    end
end

return Module
