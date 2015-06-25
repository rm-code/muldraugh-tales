StoryLoader = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local STORY_TAGS = { '<title>', '<type>', '<items>', '<x>', '<y>', '<z>' };
local MOD_ID = 'RMMuldraughTales';
local STORY_LIST = 'StoryList.txt';

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local stories;

-- ------------------------------------------------
-- Local Functions
-- ------------------------------------------------

---
-- Splits the item tag into a usable format. Items need to be saved in
-- the format [Module.Item, amountToSpawn].
--
-- @param str - The item string to process.
--
local function parseItems(str)
    local items = {};
    for snippet in string.gmatch(str, '%[.-]') do
        local item, amount = snippet:match('([^%[^,]+),([^,^%]]+)'); -- Remove brackets and split at comma.
        amount = tonumber(amount); -- We need an explicit type conversion to make it work with the Java side.
        items[item] = items[item] and items[item] + amount or amount;
    end
    return items;
end

---
-- Loads all story paths from a file and returns them in a sequence.
--
-- @param id - The mod id.
-- @param path - The path from which to load the file.
--
local function getStoryList(id, path)
    local reader = getModFileReader(id, path, false);
    if reader then
        local list = {};

        while true do
            line = reader:readLine();

            -- Checks if EOF is reached.
            if not line then
                reader:close();
                break;
            end

            list[#list + 1] = line;
        end

        return list;
    end
end

---
-- Loads a story and detects tags. Tags will be stored in the table using the
-- tag as a key (i.e. table.tag == foo). The text body of the story is stored
-- under the 'content' key.
--
-- @param id - The mod id.
-- @param filepath - The path from which to load a story.
--
local function loadStory(id, filepath)
    local reader = getModFileReader(id, filepath, false);

    if reader then
        local line;
        local file = {
            content = '',
        };

        while true do
            line = reader:readLine();

            -- Checks if EOF is reached.
            if not line then
                reader:close();
                break;
            end

            -- Look for tags.
            local hasTag;
            for i = 1, #STORY_TAGS do
                local tag = STORY_TAGS[i];

                -- Check if the line starts with the current tag.
                if line:sub(1, tag:len()) == tag then
                    -- Remove tag from line.
                    line = line:sub(tag:len() + 1);

                    -- Store line using the tag as a key after removing the < and > symbols.
                    tag = tag:gsub('[<>]', '');
                    file[tag] = line;

                    hasTag = true;
                    break;
                end
            end

            if not hasTag then
                file.content = file.content .. ' <LINE> ' .. line;
            end
        end

        print(string.format('Loaded: %s', filepath));

        -- Convert coordinates from string to number.
        file.x = tonumber(file.x);
        file.y = tonumber(file.y);
        file.z = tonumber(file.z);

        -- Replace items string with a table containing the actual spawn infos.
        if file.items then
            file.items = parseItems(file.items);
        end

        return file;
    else
        print(string.format('Can\'t read story from %s.', filepath));
    end
end

---
-- This function reads the list in which the paths of all stories to load are
-- contained. It then proceeds to load all stories and returns them in a table.
--
local function loadStories()
    local list = getStoryList(MOD_ID, STORY_LIST);
    local stories = {};

    for i = 1, #list do
        stories[#stories + 1] = loadStory(MOD_ID, list[i]);
    end

    return stories;
end

---
-- Loads all stories we need and stores them in the local 'stories' table.
--
local function init()
    stories = loadStories();
end

-- ------------------------------------------------
-- Getters
-- ------------------------------------------------

function StoryLoader.getStories()
    return stories;
end

-- ------------------------------------------------
-- Events
-- ------------------------------------------------

Events.OnGameBoot.Add(init);
