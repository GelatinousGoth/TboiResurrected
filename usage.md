## Adding a Mod
### Basic steps:

- Place all the **.lua** files inside of the ***resurrected_modpack*** folder, or any of it's sub-folders.

    - Optionally you can choose to merge all the .lua files into the main.lua file or keep the original project structure, however extra steps need to be taken to ensure that mod comprised of multiple files work properly.
    - If you choose not to keep the original structure, it is still suggested to place all the .lua files inside a new folder with the same name that's going to be given to the main.lua file

- Rename the **main.lua** file (usually the name of the source mod or a name that describes what the purpose of the mod).

- Add `local TR_Manager = require("resurrected_modpack.manager")` at the beginning of the main.lua file.
- Find the `RegisterMod()` function and replace it with `TR_Manager:RegisterMod()`

### Adding a Shader:

Normally shaders are added using the `MC_GET_SHADER_PARAMS` callback, however they are prone to cause issues especially if not dealt with properly. As such if a shader is added using this callback a Warning will now be printed on boot.

To avoid problems with shaders the `TR_Manager:RegisterShader()` function should be used instead.

To properly Register a shader you must follow these steps:

- Find the original implementation of the shader, It will look something like this:

```lua
function mod:ShaderFunction(name)
    if name == "ShaderName" then
        --- Shader Logic here
    end
end

mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.ShaderFunction)
```

- Remove the `name == "Shader"` if condition leaving only the logic.
- Remove the `AddCallback` function that adds the function to MC_GET_SHADER_PARAMS.
- Understand the what shader parameters can be used as Default and create a `DefaultShaderParams` table.
- call `TR_Manager:RegisterShader()` with parameters `mod, "ShaderName", DefaultShaderParams, mod.ShaderFunction`.

This will guarantee that, in case of an error in the original function, the shader will at least get the default parameters and be able to properly be executed.

### Enable/Disable Mod:

Each Mod can be Disabled or Enabled as long as at least one Callback is Recorded for that specific Mod

⚠️**NOTE**: A callback is registered when the `mod:AddCallback` function is used

When a mod is toggled the program follows this procedure:

- Execute `pre_enable/disable_mod`, if it exists.

- If the function exists and returns **true** then the following steps will not be considered.

- **Add**/**Remove** all callbacks registered by the mod.

- Execute `post_enable/disable_mod`, if it exists.

In general the **Post** Methods should be used when the default method correctly Toggles the mod, but additional steps need to be taken; whilst the **Pre** Methods should be used if the Toggling needs more in depth customization.

both the methods can be added anywhere by creating an appropriately named function in the **mod** table.

```lua
local mod = TR_Manager:RegisterMod("MyMod", 1)
function mod.post_disable_mod()
    -- Your Code Here
end
```