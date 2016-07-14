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

	self.m_playerSprite = {};

	for i = 1 , #players do 
		local player = Player.new();
		self.m_playerSprite[i] = player:show(players[i].x,players[i].y,0,0,map,"up");
		self.m_playerSprite[i]:setVisible(false);
	-- 	local values = players[i]
	-- 	local downSprite = display.newSprite("actors/actor_down1.png");
	-- 	downSprite:pos(values.x,values.y);
	-- 	downSprite:setAnchorPoint(cc.p(0.5,0.5))
	-- 	downSprite:addTo(map);


		-- skeletonB:show(values.x,values.y,0,0,map);
	end

	self.m_playerSprite[62]:setVisible(true);

end

function RoomScene:onEnter()

end

function RoomScene:dtor()

end

return RoomScene;