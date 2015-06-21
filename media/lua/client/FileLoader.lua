FileLoader = {};

local STORY_TAGS = { '<title>', '<type>', '<x>', '<y>', '<z>' };
local MOD_ID = 'RMMuldraughTales';
local STORY_LIST = 'StoryList.txt';

local stories;

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
                file.content = file.content .. '\n';
            end
        end

        print(string.format('Loaded: %s', filepath));

        -- Convert coordinates from string to number.
        file.x = tonumber(file.x);
        file.y = tonumber(file.y);
        file.z = tonumber(file.z);

        return file;
    else
        print(string.format('Can\'t read story from %s.', filepath));
    end
end

local function loadStories()
    local list = getStoryList(MOD_ID, STORY_LIST);
    local stories = {};

    for i = 1, #list do
        stories[#stories + 1] = loadStory(MOD_ID, list[i]);
    end

    return stories;
end

local function init()
    stories = loadStories();
end

function FileLoader.getStories()
    return stories;
end

Events.OnGameBoot.Add(init);
