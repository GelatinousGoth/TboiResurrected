## Adding a Mod
### Basic steps:

- Place all the **.lua** files inside of the ***resurrected_modpack*** folder, or any of it's sub-folders.

    - Optionally you can choose to merge all the .lua files into the main.lua file or keep the original project structure, however extra steps need to be taken to ensure that mod comprised of multiple files work properly.

- Rename the **main.lua** file (usually the name of the source mod or a name that describes what the purpose of the mod).

- Open the renamed **main.lua** file and replace the `mod = RegisterMod()` line with `mod = require("resurrected_modpack.mod_reference")`

    - if the original mod variable was a **global** variable, or if the mod reference is ever copied to a global variable (like `FiendFolio = mod`) then [additional steps](#global_mod_reference) need to be taken.
    - for reference a **global** variable can be distinguished from a **local** variable by looking at it's first definition:
    ```lua
    local FiendFolio = RegisterMod("Fiend Folio", 1) -- Local variable
    FiendFolio = RegisterMod("FiendFolio", 1) -- Global variable
    ```
    - ⚠️`NOTE`: Because of how LUA tables work (and with mod reference being a table) when the `=` operator is used on a table this does not create a copy of a table but rather an **alias** to that table (in simpler terms you can now modify the table using both the original table name and the new table name).
    Because of this if a mod reference is defined as a **local** variable and then an alias is defined as a **global** variable, then the mod reference has become a **global** variable, and must be handled as such.
    ```lua
    local mod = RegisterMod("Fiend Folio", 1) -- ModReference defined as a local variable
    -- Code in between
    FiendFolio = mod -- Global Alias created, now the mod reference has essentially become a global variable
    ```
    - In order to easily find any occurrence of a global alias search for any instance of the `= mod` text and see if the variable that it is assigned to is either **global** or **local**.

- Add a line `mod.CurrentModName = "modName"` with modName being a string that uniquely identifies a mod from another.
    - the line can be placed anywhere, as long as it's before any **AddCallback** function.
    - modName does not have to be a specific string, the only important thing is that it is not the same as that of another mod within the pack.

- Check for any instances of the **AddCallback**, **AddPriorityCallback** or **RemoveCallback** function that happens to be executed at run-time, rather than on mod load.
    - If any of them are found then follow the transformation guidelines within this [section](#runtime_callbacks)

- Check if the **json** library is used, this can be done by searching for any instance of `require("json")`
    - If there are any, replace all instances of the **json** variable with **mod.json**
    - Then follow the guidelines proposed by the [Save Data](#save_data) section.

### Handle Unique situations:

#### Global ModReferences <a id="global_mod_reference"></a>

The first thing that needs to be done is finding out **Why** the mod reference is global:

- The mod reference is global because it needs to be **passed to other lua files** (this most likely found in situations in which multiple .lua files have been used).
    - First look trough the other .lua files and see how each of them adds a Callback (`AddCallback`, `AddPriorityCallback`, `RemoveCallback`), you should find the function being preceded by `<modReference>:` with \<modReference\> being the variable containing the mod reference.
    - Find the definition of the \<modReference\> within the file.
    - If you *find it* and it looks something like this: `<modReference> = FiendFolio`, then replace it with: `local <modReference> = require("resurrected_modpack.mod_reference")`.
    - If you *don't find it*, then create a new line (preferably at the beginning of the lua file) like this: `local <modReference> = require("resurrected_modpack.mod_reference")`.
- The mod reference is global because it **allows other mods to access it's features** (this can usually be inferred by the mod's workshop noting the presence of some sort of API features, or if the mod is listed as a requirement in another mod's workshop page).
    - In this case the name of the original modReference variable should not be altered, as it would break other mods, instead,  you need to separate the API exposed features from the callbacks that need to be executed.
    - First create a new mod reference variable like this: `local mod = require("resurrected_modpack.mod_reference")`
    - Then find all the functions that add a Callback (`AddCallback`, `AddPriorityCallback`, `RemoveCallback`) and replace the original modReference with the newly created modReference:
    ```lua
    FiendFolio:AddCallback() -- Original
    mod:AddCallback() -- New
    ```
    - After that, transform the original mod reference into a regular table like this: `FiendFolio = {}`

#### Run-Time Callback Update <a id="runtime_callbacks"></a>

First let's understand how to distinguish Callbacks added/removed on **Mod Load** or at **Run-Time**:

First of all a Callback is Added/Removed when this line of code is executed: `mod:AddCallback()`/`mod.AddPriorityCallback()` (`mod:RemoveCallback()` for when it is removed)

When the game boots up it executes all of the code contained within the **main.lua** of all the enabled mods. Every line of code that is executed during this moment will be considered as *being executed on* ***Mod Load***.

After every mod has been loaded, code that belongs to a mod will only be executed when the specific callback it was tied to is fired by the game. Every line of code that is executed during this moment will be considered as *being executed at* ***Run-Time***.

Now to identify wether the Callback command that adds or removes a callback is executed at Run-Time or not, you should follow this train of logic:

- If the command is found like this then the command is executed on **Mod Load**:
  
  ```lua
  local function Function1()
      -- code
  end

  local function Function2()
      -- code
  end

  local function Function3()
      -- code
  end

  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Function1) -- AddCallback is outside of any function
  ```

  - The only time this would not be the case is when a .lua file you are analyzing is *included* or *required* whilst **inside** of a *function*
  
    ```lua
    local function InitMod()
        require("path.to.lua_file")
    end
    ```
- Now if the command is contained within a *function* **It Depends** entirely on when the function that contains it is called:
    ```lua
        local function MyExampleFunction()
             mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Function1) -- We wanna find out when this line of code is executed
             -- This all depends on when MyExampleFunction() is called
        end

        MyExampleFunction() -- MyExampleFunction is Called on Mod Load

        mod:AddCallback(ModCallbacks.MC_POST_UPDATE, MyExampleFunction) -- MyExampleFunction is Called at Run-Time

        local function MyFunction()
            MyExampleFunction() -- It all depends on when MyFunction() is called
        end
    ```
If the function that contains `mod:AddCallback()` is called at both during Mod Load and during Run-Time, then know that the **AddCallback**, **AddPriorityCallback** or **RemoveCallback** should be transformed if the containing function is executed at least one during **Run-Time**.

Now the main question: **Why do all this?**

The original **AddCallback**, **AddPriorityCallback** and **Remove Callback** functions have all been overwritten to support the collection of mod callbacks inside of a table in order to ease certain procedures.

In order to implement this collection two additional parameters have been added to each of these functions: **modName** and **lockCallbackRecord** with:

**modName**: that defines the Table in which the callback has to be recorded/deleted.  
**lockCallbackRecord**: that defines wether or not the callback has to be recorded/deleted (**false**) or not (**true**)

However in order to pass these parameters we would need to edit every one of these function calls within the source code of the mod we would like to add like this:

```lua
    local modName = "Fiend Folio"
    local lockRecord = false

    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, MyFunction) -- Original
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, MyFunction, nil, modName, lockRecord) -- New

    mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, MyFunction) -- Original
    mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, MyFunction, nil, modName, lockRecord) -- New

    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, MyFunction) -- Original
    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, MyFunction, modName, lockRecord) -- New
```

Because this process would be tedious for each function call, another method to "add" this parameters was implemented:  
`mod.CurrentModName` and `mod.LockCallbackRecord`

The values present within these two variables will be used if the functions realizes that **modName** and **lockCallbackRecord** have not been passed to them, so that it becomes unnecessary to edit each function call.

However `mod.CurrentModName` and `mod.LockCallbackRecord` don't work on **Run-Time** function calls and as such these are the only ones that need to be manually edited.

So what needs to be done is:

- Look trough the various **AddCallback**, **AddPriorityCallback** and **Remove Callback** functions, and check if
any of them are executed at least once at **Run-Time**.

- Replace all those that were found, like this:

```lua
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, MyFunction) -- Original
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, MyFunction, nil, modName, lockRecord) -- New

    mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, MyFunction) -- Original
    mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, MyFunction, nil, modName, lockRecord) -- New

    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, MyFunction) -- Original
    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, MyFunction, modName, lockRecord) -- New
```

#### Save Data <a id="save_data"></a>

There is not really a sure fire way of handling mods with Save Data, as they are a case by case scenario, but this is the general procedure you should follow:

- The first thing to do is finding the functions that handle **Loading** and **Saving** Data.
     - They can both be easily found by searching for the **mod:LoadData()** (or **Isaac.LoadModData()**) and **mod:SaveData()** (or **Isaac.SaveModData()**) functions, respectively.

- The **Loading** function is most likely fine as is, with the only minor adjustment being that the data must be taken from the respective mod's decoded table (which should be DecodedTable.Mods[**\<modName\>**], with modName being the string used for mod.CurrentModName)

- The **Saving** function needs to be removed from any AddCallback function, and must be renamed to **mod.Mods[\<modName\>].SaveData**. Then look for the data that is either being decoded by *json.decode()* or that's passed to the *mod.SaveData()* function and, instead of saving it using those functions, return it in the form of a table.
