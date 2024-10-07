local reg = {}

reg.entities = {
    keepah = {
        type = Isaac.GetEntityTypeByName("Shop Parrot"),
        variant = Isaac.GetEntityVariantByName("Shop Parrot"),
    },
}

reg.sounds = {
    keepah = Isaac.GetSoundIdByName("keepah_chirp"),
    keepah_panic = Isaac.GetSoundIdByName("keepah_panic"),
}

return reg