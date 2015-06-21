require('FileLoader');

local MOD_MODULE = 'MuldraughTales.';

local TYPE_NOTE = 'Note';

local function spawnStory(story, container)
    local itemType = MOD_MODULE .. TYPE_NOTE;

    -- Create the item and store the story's id in its modData.
    local item    = container:AddItem(itemType);
    local modData = item:getModData();
    modData.storyContent = story.content;
    modData.title = story.title;
end

local function spawnSpecificStories(room, containerType, container)
    local x = container:getSourceGrid():getX();
    local y = container:getSourceGrid():getY();
    local z = container:getSourceGrid():getZ();

    local stories = FileLoader.getStories();
    for i = 1, #stories do
        local story = stories[i];
        if story.x == x and story.y == y and story.z == z then
            spawnStory(story, container);
        end
    end
end

Events.OnFillContainer.Add(spawnSpecificStories);
