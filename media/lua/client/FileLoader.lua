local STORY_TAGS = { '<title>', '<x>', '<y>', '<z>' };
local MOD_ID = 'RMMuldraughTales';
local STORY_FOLDER = '/stories/'

local function loadStory(id, filename)
    local filepath = STORY_FOLDER .. filename;
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

                    -- Store line using the tag as a key.
                    file[tag] = line;

                    hasTag = true;
                    break;
                end
            end

            if not hasTag then
                file.content = file.content .. '\n';
            end
        end

        return file;
    else
        print(string.format("Can't read story from %s.", filepath));
    end
end

local function loadStories()
    local file = loadStory(MOD_ID, 'Test.txt');
    print(file.title);
    print(file.x, file.y, file.z);
    print(file.content);
end

Events.OnGameBoot.Add(loadStories);
