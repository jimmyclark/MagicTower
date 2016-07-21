local RoomScene = class("RoomScene",function()
	return display.newScene("RoomScene");
end)

Wall = require("app.entity.wall.Wall");

UpStair = require("app.entity.stairs.UpStair");
DownStair = require("app.entity.stairs.DownStair");

RedDrink = require("app.entity.drink.RedDrink");
BlueDrink = require("app.entity.drink.BlueDrink");

YellowKey = require("app.entity.key.YelloKey");
BlueKey = require("app.entity.key.BlueKey");
RedKey = require("app.entity.key.RedKey");

YellowDoor = require("app.entity.door.YellowDoor");
BlueDoor = require("app.entity.door.BlueDoor");
RedDoor = require("app.entity.door.RedDoor");

AttackProp = require("app.entity.AttackProp");
DefenseProp = require("app.entity.DefenseProp");

LittleSpider = require("app.entity.monster.primary_enemy.LittleSpider");
Priest = require("app.entity.monster.primary_enemy.Priest");
RedSlime = require("app.entity.monster.primary_enemy.RedSlime")
GreenSlime = require("app.entity.monster.primary_enemy.GreenSlime")
SkeletonA = require("app.entity.monster.primary_enemy.SkeletonA")
SkeletonB = require("app.entity.monster.primary_enemy.SkeletonB")

Player = require("app.entity.Player")

function RoomScene:ctor()
	self.m_colmap = {}; -- map映射表[x*y] = 对应的位置

	self.m_currentFloor = 1; -- 当前楼层

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
	-- 加载地图
	self.m_map = cc.TMXTiledMap:create("map/floor1.tmx");
	self.m_map:setPosition(display.cx ,display.cy)
	self.m_map:setAnchorPoint(cc.p(0.5,0.5));
	self:addChild(self.m_map);

	-- 加载墙壁
	self:drawWall();

	-- 加载楼梯
	self:drawStairs();

	-- 加载药水
	self:drawLiquid();

	-- 绘制门
	self:drawDoors();

	-- 绘制钥匙
	self:drawKeys();

	-- 绘制怪物
	self:drawMonster();

	-- 加载精灵
	self:loadSprite();

	-- 绘制特殊道具
	self:drawAttackAndDefense();

end

function RoomScene:onEnter()

end

function RoomScene:dtor()

end

function RoomScene:onLeftResponse()
	-- local x,y = self.m_player:getCurrentPos();
	-- local w,h = self.m_player:getWidthHeight();
	-- print(x,y,w,h);
	-- print("aaa")
	-- for k,v in pairs(self.m_walls) do 
	-- 	print(k,v)
	-- end

	-- if self.m_walls[(x-w)*y] == 1 then 
	-- 	return;
	-- end
	local x, y = self.m_player:getCurrentPos();

print("colMap:" .. #self.m_colmap)
print(x*y)
	for k , v in pairs(self.m_colmap) do 
		print(k,v)
	end
	if self.m_colmap[x * y] and self.m_colmap.m_isSolid then 
		return;
	end

	self.m_player:onLeftClick();
end

function RoomScene:onRightResponse()
	self.m_player:onRightClick();
	print(self.m_player:getWidthHeight(),self.m_player:getCurrentPos())
end

function RoomScene:onUpResponse()
	self.m_player:onUpClick();
	print(self.m_player:getWidthHeight(),self.m_player:getCurrentPos())
end

function RoomScene:onDownResponse()
	self.m_player:onDownClick();

	print(self.m_player:getWidthHeight(),self.m_player:getCurrentPos())
end

----------------------------------------------------- 加载ui ----------------------------------------------
-- 绘制墙
function RoomScene:drawWall()
	local walls = self.m_map:getObjectGroup("bg_wall"):getObjects();
	for _,values in pairs(walls) do
		local wall = Wall.new();
		wall:show(values.x,values.y,0,0,self.m_map);

		self.m_colmap[values.x*values.y] = wall;
	end	
end

-- 绘制上下楼梯
function RoomScene:drawStairs()
	local up_stairs = self.m_map:getObjectGroup("up_floor"):getObjects();
	for _,values in pairs(up_stairs) do
		local stairs = UpStair.new();
		stairs:show(values.x,values.y,0,0,self.m_map);

		self.m_colmap[values.x*values.y] = stairs;  
	end	

	local down_stairs = self.m_map:getObjectGroup("down_floor"):getObjects();
	for _,values in pairs(down_stairs) do 
		local stairs = DownStair.new();
		stairs:show(values.x,values.y,0,0,self.m_map);

		self.m_colmap[values.x*values.y] = stairs;
	end
end

-- 绘制药水
function RoomScene:drawLiquid()
	local red_liquid = self.m_map:getObjectGroup("red_drink"):getObjects();
	for _,values in pairs(red_liquid) do
		local redDrink = RedDrink.new();
		redDrink:show(values.x,values.y,0,0,self.m_map);
		self.m_colmap[values.x*values.y] = redDrink;  
	end

	local blue_liquid = self.m_map:getObjectGroup("blue_drink"):getObjects();
	for _,values in pairs(blue_liquid) do 
		local blueDrink = BlueDrink.new();
		blueDrink:show(values.x,values.y,0,0,self.m_map);
		self.m_colmap[values.x*values.y] = blueDrink;
	end	

end

-- 绘制钥匙
function RoomScene:drawKeys()
	-- 黄钥匙
	if self.m_map:getObjectGroup("yellow_key") then 
		local yellow_key = self.m_map:getObjectGroup("yellow_key"):getObjects();
		for _,values in pairs(yellow_key) do 
			local yellowKey = YellowKey.new();
			yellowKey:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = yellowKey;
		end
	end

	-- 蓝钥匙
	if self.m_map:getObjectGroup("blue_key") then 
		local blue_key = self.m_map:getObjectGroup("blue_key"):getObjects();
		for _,values in pairs(blue_key) do 
			local blueKey = BlueKey.new();
			blueKey:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = blueKey;
		end	
	end

	-- 红钥匙
	if self.m_map:getObjectGroup("red_key") then 
		local red_key = self.m_map:getObjectGroup("red_key"):getObjects();
		for _,values in pairs(red_key) do 
			local redKey = RedKey.new();
			redKey:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = redKey;
		end	
	end
end

-- 绘制门
function RoomScene:drawDoors()
	-- 黄门
	if self.m_map:getObjectGroup("yellow_door") then 
		local yellow_doors = self.m_map:getObjectGroup("yellow_door"):getObjects();
		for _,values in pairs(yellow_doors) do 
			local yellow_door = YellowDoor.new();
			yellow_door:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = yellow_door;
		end	
	end

	-- 蓝门
	if self.m_map:getObjectGroup("blue_door") then 
		local blue_doors = self.m_map:getObjectGroup("blue_door"):getObjects();
		for _,values in pairs(blue_doors) do 
			local blue_door = BlueDoor.new();
			blue_door:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = blue_door;
		end	
	end

	-- 红门
	if self.m_map:getObjectGroup("red_door") then 
		local red_doors = self.m_map:getObjectGroup("red_door"):getObjects();
		for _,values in pairs(red_doors) do 
			local red_door = RedDoor.new();
			red_door:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = red_door;
		end	
	end
end

-- 绘制精灵
function RoomScene:loadSprite()
	local players = self.m_map:getObjectGroup("track"):getObjects();

	for _,v in pairs(players) do 
		self.m_player = Player.new();
		self.m_playerSprite = self.m_player:show(v.x,v.y,0,0,self.m_map,"up");
	end
end

-- 绘制攻击和防御
function RoomScene:drawAttackAndDefense()
	local attacks = self.m_map:getObjectGroup("attack"):getObjects();

	for _,values in pairs(attacks) do 
		local attack = AttackProp.new();
		attack:show(values.x,values.y,0,0,self.m_map);
		self.m_colmap[values.x*values.y] = attack;
	end

	local defenses = self.m_map:getObjectGroup("defense"):getObjects();

	for _,values in pairs(defenses) do 
		local defense = DefenseProp.new();
		defense:show(values.x,values.y,0,0,self.m_map);
		self.m_colmap[values.x*values.y] = defense;
	end
end

-- 绘制怪物
function RoomScene:drawMonster()
	if tonumber(self.m_currentFloor) <= 10 then 
		self:drawYellowSlime();
		self:drawRedSlime();
		self:drawBat();
		self:drawPriest();
		self:drawSkeletonA();
		self:drawSkeletonB();
	end
end

-- 1F ~ 10F
-- 绘制绿色Slime
function RoomScene:drawYellowSlime()
	if self.m_map:getObjectGroup("green_slime") then 
		local green_slime = self.m_map:getObjectGroup("green_slime"):getObjects();
		for _,values in pairs(green_slime) do 
			local greenSlime = GreenSlime.new();
			greenSlime:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = greenSlime;
		end	
	end
end

-- 绘制红色Slime
function RoomScene:drawRedSlime()
	if self.m_map:getObjectGroup("red_slime") then 
		local red_slime = self.m_map:getObjectGroup("red_slime"):getObjects();
		for _,values in pairs(red_slime) do 
			local redSlime = RedSlime.new();
			redSlime:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = redSlime;
		end	
	end
end

-- 绘制Bat
function RoomScene:drawBat()
	if self.m_map:getObjectGroup("litter_spider") then 
		local little_spider = self.m_map:getObjectGroup("litter_spider"):getObjects();
		for _,values in pairs(little_spider) do 
			local spider = LittleSpider.new();
			spider:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = spider;
		end	
	end
end

-- 绘制法师
function RoomScene:drawPriest()
	if self.m_map:getObjectGroup("master") then 
		local priest = self.m_map:getObjectGroup("master"):getObjects();
		for _,values in pairs(priest) do 
			local priest = Priest.new();
			priest:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = priest;
		end	
	end
end

-- 绘制Skeleton A
function RoomScene:drawSkeletonA()
	if self.m_map:getObjectGroup("skeleton A") then 
		local skeletons = self.m_map:getObjectGroup("skeleton A"):getObjects();
		for _,values in pairs(skeletons) do 
			local skeletonA = SkeletonA.new();
			skeletonA:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = skeletonA;
		end	
	end
end

-- 绘制Skeleton B
function RoomScene:drawSkeletonB()
	if self.m_map:getObjectGroup("skeleton B") then 
		local skeletons = self.m_map:getObjectGroup("skeleton B"):getObjects();
		for _,values in pairs(skeletons) do 
			local skeletonB = SkeletonB.new();
			skeletonB:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y] = skeletonB;
		end	
	end
end



return RoomScene;