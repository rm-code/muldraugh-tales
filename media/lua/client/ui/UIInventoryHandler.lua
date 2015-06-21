require('TimedActions/ISTimedActionQueue');
require('StoryHandling/StoryLoader');
require('UI/UIStoryManager');

-- ------------------------------------------------
-- Local Functions
-- ------------------------------------------------

---
-- @param items   - A table containing the clicked items / stack.
-- @param player  - The player who clicked the menu.
-- @param content - The story's text body.
-- @param title   - The story's title.
--
local function onReadNote(items, player, content, title)
    local panel = UIStoryPanel:new(title, content);
    panel:initialise();
    panel:addToUIManager();
end

---
-- @param player  - The player who clicked the menu.
-- @param context - The context menu to add a new option to.
-- @param items   - A table containing the clicked items / stack.
--
local function createMenu(player, context, items)
    player = getSpecificPlayer(player);

    if #items == 1 then -- We have either one clicked item or a folded stack of items.
        -- We iterate through the table of clicked items. We have
        -- to seperate between single items and folded
        for _, clickedItem in ipairs(items) do
            if instanceof(clickedItem, "InventoryItem") then -- We have a single clicked item.
                if clickedItem:getModule() == "MuldraughTales" then
                    local modData = clickedItem:getModData();
                    local title = modData.title;
                    local storyContent = modData.storyContent;

                    context:addOption("Read " .. title, items, onReadNote, player, storyContent, title);
                end

            elseif type(clickedItem) == "table" then -- We have a folded stack of items.
                -- We start to iterate at the second index to jump over the dummy
                -- item that is contained in the item-table.
                for i2 = 2, #clickedItem.items do
                    local item = clickedItem.items[i2];
                    if instanceof(item, "InventoryItem") then
                        if item:getModule() == "MuldraughTales" then
                            local modData = item:getModData();
                            local title = modData.title;
                            local storyContent = modData.storyContent;

                            context:addOption("Read " .. title, items, onReadNote, player, storyContent, title);
                        end
                    end
                end
            end
        end
    elseif #items > 1 then -- We have an unfolded stack or multiple stacks.
        for i, clickedItem in ipairs(items) do
            if type(clickedItem) == "table" then -- Multiple Folded stacks.
                for i2 = 2, #clickedItem.items do
                    local item = clickedItem.items[i2];
                    if instanceof(item, "InventoryItem") then
                        if item:getModule() == "MuldraughTales" then
                            local modData = item:getModData();
                            local title = modData.title;
                            local storyContent = modData.storyContent;

                            context:addOption("Read " .. title, items, onReadNote, player, storyContent, title);
                        end
                    end
                end

            elseif i > 1 and instanceof(clickedItem, "InventoryItem") then -- Unfolded stack.
                if clickedItem:getModule() == "MuldraughTales" then
                    local modData = item:getModData();
                    local title = modData.title;
                    local storyContent = modData.storyContent;

                    context:addOption("Read " .. title, items, onReadNote, player, storyContent, title);
                end
            end
        end
    end
end

-- ------------------------------------------------
-- Events
-- ------------------------------------------------

Events.OnPreFillInventoryObjectContextMenu.Add(createMenu);
