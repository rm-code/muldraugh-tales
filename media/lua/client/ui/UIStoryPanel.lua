require('ISUI/ISPanel');
require('ISUI/ISRichTextPanel');
require('ISUI/ISCollapsableWindow');

UIStoryPanel = {};

function UIStoryPanel.new(title, text)
    local self = {};
    self.richtext = ISRichTextPanel:new(0, 0, 500, 500);
    self.richtext:initialise();
    self.richtext:setAnchorBottom(true);
    self.richtext:setAnchorRight(true);
    self.wrapped = self.richtext:wrapInCollapsableWindow();
    self.wrapped:setX((getCore():getScreenWidth() * 0.5) - (self.richtext.width * 0.5));
    self.wrapped:setY((getCore():getScreenHeight() * 0.5) - (self.richtext.height * 0.5));
    self.wrapped:setTitle(title);

    self.wrapped:addToUIManager();
    self.richtext:setWidth(self.wrapped:getWidth());
    self.richtext:setHeight(self.wrapped:getHeight() - 16);
    self.richtext:setY(16);
    self.richtext.autosetheight = false;
    self.richtext.clip = true;
    self.richtext:addScrollBars();

    self.richtext.textDirty = true;
    self.richtext.text = text;
    self.richtext:paginate();
    return self;
end
