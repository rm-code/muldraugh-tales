require('StoryLoader');

local MOD_MODULE = 'MuldraughTales.';

local MAX_NOTES   = 11;
local MAX_LETTERS =  8;
local MAX_FLYERS  = 11;

local TYPE_NOTE   = "Note";
local TYPE_LETTER = "Letter";
local TYPE_FLYER  = "Flyer";
local TYPE_PHOTO  = "Polaroid";

local function spawnStory(story, container)
    local itemType;

    if story.type == TYPE_NOTE then
        itemType = MOD_MODULE .. TYPE_NOTE   .. (ZombRand(MAX_NOTES)   + 1);
    elseif story.type == TYPE_LETTER then
        itemType = MOD_MODULE .. TYPE_LETTER .. (ZombRand(MAX_LETTERS) + 1);
    elseif story.type == TYPE_FLYER then
        itemType = MOD_MODULE .. TYPE_FLYER  .. (ZombRand(MAX_FLYERS)  + 1);
    elseif story.type == TYPE_PHOTO then
        itemType = MOD_MODULE .. TYPE_PHOTO; 
    end

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

    local stories = StoryLoader.getStories();
    for i = 1, #stories do
        local story = stories[i];
        if story.x == x and story.y == y and story.z == z then
            spawnStory(story, container);
        end
    end
end

Events.OnFillContainer.Add(spawnSpecificStories);
