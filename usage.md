## Adding a Mod
### Basic steps:

- Place all the **.lua** files inside of the ***resurrected_modpack*** folder, or any of it's sub-folders.

    - Optionally you can choose to merge all the .lua files into the main.lua file or keep the original project structure, however extra steps need to be taken to ensure that mod comprised of multiple files work properly.

- Rename the **main.lua** file (usually the name of the source mod or a name that describes what the purpose of the mod).

- Open the renamed **main.lua** file and replace the ***mod = RegisterMod()*** line with ***mod = require("resurrected_modpack.mod_reference")***

    - if the original mod variable was a **global** variable, or if the mod reference is ever copied to a global variable (like ***FiendFolio = mod***) then [additional steps](#global_mod_reference) need to be taken.

- Add a line ***mod.CurrentModName = "modName"***

- Check for any instances of the **AddCallback**, **AddPriorityCallback** or **RemoveCallback** function that happens to be executed at run-time, rather than on mod load.
    - If any of them are found then follow the transformation guidelines within this [section](#runtime_callbacks)

- Check if the **json** library is used, this can be done by searching for any instance of ***require()***
    - If there are any, replace all instances of the **json** variable with **mod.json**
    - Then follow the guidelines proposed by the [Save Data](#save_data) section.

### Handle Unique situations:

#### Global ModReferences <a id="global_mod_reference"></a>

The first thing that needs to be done is finding out **Why** the mod reference is global:

- The mod reference is global because it needs to be **passed to other lua files** (usually you will find in other lua files the lines ***mod = FiendFolio***)
    - In this case simply replace all instances of the global mod reference with ***require("resurrected_modpack.mod_reference")***
- The mod reference is global because it **allows other mods to access it's features**
    - In this case you need to find all the functions/variables that are exposed to other mods and replace all instances of the mod reference which *do not belong to this group* with a local mod reference (whilst also renaming each of this instance).
    - Then proceed to create a new table which has the name of the original mod reference, like this:***FiendFolio = {}***

#### Run-Time Callbacks <a id="runtime_callbacks"></a>

**modName** defines the Table in which the callback has to be recorded/deleted.
**lockCallbackRecord** defines wether or not the callback has to be recorded/deleted (false) or not (true)

If these are not specified within the Add or Remove function then the **mod.CurrentModName** and **mod.LockCallbackRecord** variables are used instead.

- **AddCallback**: ***mod:AddCallback(callbackId, callbackFn, entityId)*** becomes ***mod:AddCallback(callbackId, callbackFn, entityId, modName, lockCallbackRecord)***
    - In those situation in which *entityId* is not present within the original source code simply replace it with **nil**
- **AddPriorityCallback**: ***mod:AddPriorityCallback(callbackId, priority, callbackFn, entityId)*** becomes ***mod:AddPriorityCallback(callbackId, priority, callbackFn, entityId, modName, lockCallbackRecord)***
    - In those situation in which *entityId* is not present within the original source code simply replace it with **nil**
- **RemoveCallback**: ***mod:RemoveCallback(callbackId, callbackFn)*** becomes ***mod:RemoveCallback(callbackId, callbackFn, modName, lockCallbackRecord)***

#### Save Data <a id="save_data"></a>

There is not really a sure fire way of handling mods with Save Data, as they are a case by case scenario.

- The first thing to do is finding the functions that handle **Loading** and **Saving** Data.
     They can both be easily found by searching for the **mod:LoadData()** (or **Isaac.LoadModData()**) and **mod:SaveData()** (or **Isaac.SaveModData()**) functions, respectively.

- The **Loading** function is most likely fine the way it is, with the only minor adjustment being that must be taken from the respective mod's decoded table (which should be SaveData.Mods[**\<modName\>**], with modName being the string used for mod.CurrentModName)

- The **Saving** function needs to be remove from the AddCallback function, and renamed to **mod.Mods[\<modName\>].SaveData** and the data that is either decoded by *json.decode()* or passed to the *mod.SaveData()* function must be returned, instead, in the form of a table.