local RoomScene = class("RoomScene",function()
	return display.newScene("RoomScene");
end)

LittleSpider = require("app.entity.LittleSpider");
YellowKey = require("app.entity.YelloKey");
Master = require("app.entity.Master");
RedSlime = require("app.entity.RedSlime")
GreenSlime = require("app.entity.GreenSlime")
SkeletonA = require("app.entity.SkeletonA")
SkeletonB = require("app.entity.SkeletonB")

Player = require("app.entity.Player")

function RoomScene:ctor()
	self.m_startSpriteIndex = 65;

	self:createLeftLayer();

	self:createMainLayer();
end

kGameWall 	   = 0;  -- 普通墙壁
kGameUpStair   = 1 ; -- 向上楼梯
kGameDownStair = -1; -- 向下楼梯
kGameDoor  	   = 2;  -- 房间门
kGameKey 	   = 3;  -- 房间钥匙
kGameDrink 	   = 4;  -- 药水
kGamePropAttack= 5;  -- 攻击
kGamePropDefen = 6;  -- 防御

function RoomScene:createLeftLayer()
	local layer = display.newColorLayer(cc.c4b(0x8B,0x8B,0xBB, 255));
	layer:addTo(self);

	layer:setTouchEnabled(true);

	layer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE);
	layer:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
		if event.name == "began" then 
			self.lastX = event.x;
			self.lastY = event.y;
			return true;

		elseif event.name == "ended" then
			if math.abs(event.x - self.lastX) <= 800 * display.contentScaleFactor  then 
				if event.y - self.lastY > 30 then
					self:onUpResponse();

				elseif self.lastY - event.y > 30 then 
					self:onDownResponse();
				end
			end

			if math.abs(event.y - self.lastY) <= 800 * display.contentScaleFactor then
				if event.x - self.lastX > 30 then 
					self:onRightResponse();
				elseif self.lastX - event.x > 30 then 
					self:onLeftResponse();
				end
			end

			return true;
		end
	end);

	layer:setKeypadEnabled(true);
	self:addNodeEventListener(cc.KEYPAD_EVENT,function(event)
		print("event.key" .. event.key)
	end);

end

function RoomScene:createMainLayer()
	local map = cc.TMXTiledMap:create("map/floor1.tmx");
	map:setPosition(display.cx ,display.cy)
	map:setAnchorPoint(cc.p(0.5,0.5));
	self:addChild(map);

	-- 初始化黄色的门
	local yelloDoors = map:getObjectGroup("yellow_door"):getObjects();

	for _,values in pairs(yelloDoors) do 
		local yellowKey = YellowKey.new();
		yellowKey:show(values.x,values.y,0,0,map);
	end

	-- 初始化怪物
	local spiders = map:getObjectGroup("litter_spider"):getObjects();
	for _,values in pairs(spiders) do 
		local little_spider = LittleSpider.new();
		little_spider:show(values.x,values.y,0,0,map);
	end

	-- master
	local masters = map:getObjectGroup("master"):getObjects();
	for _,values in pairs(masters) do 
		local master = Master.new();
		master:show(values.x,values.y,0,0,map);
	end

	-- red slime
	local redslimes = map:getObjectGroup("red_slime"):getObjects();
	for _,values in pairs(redslimes) do 
		local redslime = RedSlime.new();
		redslime:show(values.x,values.y,0,0,map);
	end

	-- green slime
	local greenslimes = map:getObjectGroup("green_slime"):getObjects();
	for _,values in pairs(greenslimes) do 
		local redslime = GreenSlime.new();
		redslime:show(values.x,values.y,0,0,map);
	end

	-- skeleton
	local skeletons = map:getObjectGroup("skeleton A"):getObjects();
	for _,values in pairs(skeletons) do 
		local skeletonA = SkeletonA.new();
		skeletonA:show(values.x,values.y,0,0,map);
	end

	local skeletonBs = map:getObjectGroup("skeleton B"):getObjects();
	for _,values in pairs(skeletonBs) do 
		local skeletonB = SkeletonB.new();
		skeletonB:show(values.x,values.y,0,0,map);
	end

	-- 绘制精灵
	local players = map:getObjectGroup("track"):getObjects();

	-- self.m_playerSprite = {};

	for _,v in pairs(players) do 
		self.m_player = Player.new();
		self.m_playerSprite = self.m_player:show(v.x,v.y,0,0,map,"up");
	end

end

function RoomScene:onEnter()

end

function RoomScene:dtor()

end

function RoomScene:onLeftResponse()
	self.m_player:onLeftClick();
end

function RoomScene:onRightResponse()
	self.m_player:onRightClick();
end

function RoomScene:onUpResponse()
	self.m_player:onUpClick();
end

function RoomScene:onDownResponse()
	self.m_player:onDownClick();
end

return RoomScene;