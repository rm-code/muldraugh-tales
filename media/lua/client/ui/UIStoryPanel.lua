require('ISUI/ISPanel');
require('ISUI/ISRichTextPanel');
require('ISUI/ISButton');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

UIStoryPanel = ISPanel:derive('UIStoryPanel');

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CORE = getCore();
local SCREEN_W = CORE:getScreenWidth();
local SCREEN_H = CORE:getScreenHeight();

local PANEL_W = 400;
local PANEL_H = 600;

-- Screenposition (centered)
local PANEL_POS_X = SCREEN_W * 0.5 - PANEL_W * 0.5;
local PANEL_POS_Y = SCREEN_H * 0.5 - PANEL_H * 0.5;

-- ------------------------------------------------
-- Local Functions
-- ------------------------------------------------

local function update()
    SCREEN_W = CORE:getScreenWidth();
    SCREEN_H = CORE:getScreenHeight();

    PANEL_POS_X = SCREEN_W * 0.5 - PANEL_W * 0.5;
    PANEL_POS_Y = SCREEN_H * 0.5 - PANEL_H * 0.5;

    print("Updated values for UIStoryPanel");
end

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

function UIStoryPanel:initialise()
    ISPanel.initialise(self);
end

---
-- @param title
-- @param text
--
function UIStoryPanel:new(title, text)
    -- Create a rich text panel which will display the story's text.
    local textPanel = ISRichTextPanel:new(PANEL_POS_X, PANEL_POS_Y, PANEL_W, PANEL_H)
    textPanel:initialise();
    textPanel:instantiate();
    textPanel:setAnchorTop(true);
    textPanel:setAnchorBottom(true);
    textPanel:setAnchorRight(true);
    textPanel:setAnchorLeft(true);
    textPanel.text = text;
    textPanel.autosetheight = false;
    textPanel:setY(20);
    textPanel:setX(00);
    textPanel:setYScroll(0);
    textPanel.backgroundColor = { r = 0, g = 0, b = 0, a = 0.0 };
    textPanel:paginate();

    -- Create a collapsable window and attach the rich text panel to it.
    local colBox = ISCollapsableWindow:new(PANEL_POS_X, PANEL_POS_Y, PANEL_W, PANEL_H);
    colBox:initialise();
    colBox:setTitle(title);
    colBox:setAnchorTop(true);
    colBox:setAnchorBottom(true);
    colBox:setAnchorRight(true);
    colBox:setAnchorLeft(true);
    colBox:addChild(textPanel);
    colBox.nested = textPanel;
    colBox.minimumWidth = 400;
    colBox.minimumHeight = 200;

    -- Add scroll bars to the text panel.
    textPanel:addScrollBars();

    -- Remove the original text panel.
    if textPanel.javaObject then
        textPanel:removeFromUIManager();
    end

    return colBox;
end

-- ------------------------------------------------
-- Events
-- ------------------------------------------------

Events.OnResolutionChange.Add(update);
