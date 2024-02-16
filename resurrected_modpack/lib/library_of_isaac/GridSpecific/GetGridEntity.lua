















function TSIL.GridSpecific.GetTrapdoors(trapdoorVariant)
    if not trapdoorVariant then
        trapdoorVariant = -1
    end

    local trapdoors = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_TRAPDOOR)

    if trapdoorVariant == -1 then
        return trapdoors
    else
        return TSIL.Utils.Tables.Filter(trapdoors, function (_, trapdoor)
            return trapdoor:GetVariant() == trapdoorVariant
        end)
    end
end