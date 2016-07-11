require("utils.UICreator");

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	local titleNames = {"T","h","e"," ","l","e","g","a","n","d"," ","o","f"," ","M","a","g","i","c","T","o","w","e","r"};

	self.m_titles = {};
	self.m_actions = {};

	local screenWScale = display.width/CONFIG_SCREEN_HEIGHT;
	local screenHScale = display.height/CONFIG_SCREEN_WIDTH;

	for i=1,#titleNames do
		local y = math.random(-5,5);
		self.m_titles[i] = UICreator.createFontText(titleNames[i],40,display.CENTER,display.cx-350+(30*i),display.top-200*screenHScale+y,255,255,0,"fonts/UIFont.fnt");
    	self.m_titles[i]:addTo(self);
    	self.m_actions[i] = cc.TintBy:create(2, math.random(128,255), math.random(128,255), math.random(128,255));
    	self.m_titles[i]:runAction(cc.RepeatForever:create(self.m_actions[i]));
	end

	local startGame = UICreator.createText("Start Game",35,display.CENTER,display.cx,display.cy,128,255,128);
	self.m_startGameBtn = UICreator.createBtnText(nil,false,display.cx,display.top-350*screenHScale,display.CENTER,200,200,startGame,"fonts/arial.fnt");
	self.m_startGameBtn:addTo(self);

	self.m_startGameBtn:onButtonPressed(function(event)
		event.target:setScale(1.2);
		event.target:setOpacity(128);
	end);

	self.m_startGameBtn:onButtonRelease(function(event)
		event.target:setScale(1.0);
		event.target:setOpacity(255);
	end);

	self.m_startGameBtn:onButtonClicked(function(event)
		print("go to roomScene");
		local roomScene = require("app.scenes.RoomScene").new()
   	    display.replaceScene(roomScene, "fade", 0.6, display.COLOR_WHITE)

	end);

	local loadGame = UICreator.createText("Load Game",35,display.CENTER,display.cx,display.cy,128,128,128);
	self.m_loadGameBtn = UICreator.createBtnText(nil,false,display.cx,display.top-480*screenHScale,display.CENTER,200,200,loadGame,"fonts/arial.fnt");
	self.m_loadGameBtn:addTo(self);

	self.m_loadGameBtn:onButtonPressed(function(event)
		event.target:setScale(1.2);
		event.target:setOpacity(128);
	end);

	self.m_loadGameBtn:onButtonRelease(function(event)
		event.target:setScale(1.0);
		event.target:setOpacity(255);
	end);

	self.m_loadGameBtn:onButtonClicked(function(event)
		print("load Game");
	end);

	self.m_loadGameBtn:setButtonEnabled(false);

	local rankGame = UICreator.createText("Rank",35,display.CENTER,display.cx,display.cy,128,255,128);
	self.m_rankBtn = UICreator.createBtnText(nil,false,display.cx,display.top-610*screenHScale,display.CENTER,200,200,rankGame,"fonts/arial.fnt");
	self.m_rankBtn:addTo(self);

	self.m_rankBtn:onButtonPressed(function(event)
		event.target:setScale(1.2);
		event.target:setOpacity(128);
	end);

	self.m_rankBtn:onButtonRelease(function(event)
		event.target:setScale(1.0);
		event.target:setOpacity(255);
	end);

	self.m_rankBtn:onButtonClicked(function(event)
		print("rank Game");
	end);

	local exitGame = UICreator.createText("Exit Game",35,display.CENTER,display.cx,display.cy,128,255,128);
	self.m_exitGameBtn = UICreator.createBtnText(nil,false,display.cx,display.top-740*screenHScale,display.CENTER,200,200,exitGame,"fonts/arial.fnt");
	self.m_exitGameBtn:addTo(self);

	self.m_exitGameBtn:onButtonPressed(function(event)
		event.target:setScale(1.2);
		event.target:setOpacity(128);
	end);

	self.m_exitGameBtn:onButtonRelease(function(event)
		event.target:setScale(1.0);
		event.target:setOpacity(255);
	end);

	self.m_exitGameBtn:onButtonClicked(function(event)
		-- os.exit();
	end);

	self.m_exitGameBtn:setVisible(false);

	if device.platform ~= "android" then 
		self.m_exitGameBtn:setVisible(true);
	end

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
