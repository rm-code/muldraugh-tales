require('ISUI/ISPanel');
require('ISUI/ISRichTextPanel');
require('ISUI/ISCollapsableWindow');

UIStoryPanel = {};

function UIStoryPanel.new(title, text)
    local self = {};
    self.tut = ISRichTextPanel:new(0, 0, 500, 500);
    self.tut:initialise();
    self.tut:setAnchorBottom(true);
    self.tut:setAnchorRight(true);
    self.moreinfo = self.tut:wrapInCollapsableWindow();
    self.moreinfo:setX((getCore():getScreenWidth() * 0.5) - (self.tut.width * 0.5));
    self.moreinfo:setY((getCore():getScreenHeight() * 0.5) - (self.tut.height * 0.5));
    self.moreinfo:setTitle(title);

    self.moreinfo:addToUIManager();
    self.tut:setWidth(self.moreinfo:getWidth());
    self.tut:setHeight(self.moreinfo:getHeight() - 16);
    self.tut:setY(16);
    self.tut.autosetheight = false;
    self.tut.clip = true;
    self.tut:addScrollBars();

    self.tut.textDirty = true;
    self.tut.text = text;
    self.tut:paginate();
    return self;
end
