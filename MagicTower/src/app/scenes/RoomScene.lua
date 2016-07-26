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

AttackProp = require("app.entity.prop.AttackProp");
DefenseProp = require("app.entity.prop.DefenseProp");
JumpProp = require("app.entity.prop.JumpProp");

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

	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods();

	self:createBgLayer();

	self:createMainLayer();

	self:createLeftContent();


end

kGameWall 	   = 0;  -- 普通墙壁
kGameUpStair   = 1 ; -- 向上楼梯
kGameDownStair = -1; -- 向下楼梯
kGameDoor  	   = 2;  -- 房间门
kGameKey 	   = 3;  -- 房间钥匙
kGameDrink 	   = 4;  -- 药水
kGamePropAttack= 5;  -- 攻击
kGamePropDefen = 6;  -- 防御

function RoomScene:createBgLayer()
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

	-- 绘制攻击和防御
	self:drawAttackAndDefense();

	-- 绘制特殊道具
	self:drawSpeicalProp();

end

function RoomScene:createLeftContent()
	self.m_leftBg = cc.LayerColor:create(cc.c4b(255, 255, 255, 128));
	local width = self.m_map:getContentSize().width;
	local height = self.m_map:getContentSize().height;
	self.m_leftBg:setContentSize(width/2,height);
	self.m_leftBg:setPosition(display.cx - width , display.cy/3 + 7*display.contentScaleFactor);
	self.m_leftX = display.cx - width;
	self.m_leftY = display.cy/3 + 7*display.contentScaleFactor + height;
	self.m_leftBg:setAnchorPoint(cc.p(0.5,0.5))
	self.m_leftBg:addTo(self);

	self:createPerson();
end

function RoomScene:createPerson()
	self.m_photo = display.newSprite("user.jpg");
	local w = self.m_photo:getContentSize().width;
	local h = self.m_photo:getContentSize().height;
	local y = self.m_leftY - h /2 - 5*display.contentScaleFactor;
	self.m_photo:setPosition(self.m_leftX + w, y);
	self.m_photo:addTo(self);

	y = y - h * 5/6;

	-- Floor
	self.m_floorTitle = UICreator.createFontText(
		"Floor",20,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,self.m_leftX + w/3 + 40 * display.contentScaleFactor ,y ,255,255,0,"fonts/UIFont.fnt");
	self.m_floorTitle:addTo(self);

	w = self.m_floorTitle:getContentSize().width;

	-- Floor 1
	self.m_floorText = UICreator.createText(
		self.m_currentFloor .. "",35,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,self.m_leftX + w + 60 * display.contentScaleFactor,y + 8 * display.contentScaleFactor,0,0,0);
	self.m_floorText:addTo(self);

	h = self.m_floorTitle:getContentSize().height;

	y = y - h * 3/4;

	-- Life
	self.m_lifeIcon = display.newSprite("player/life.png");
	local x = self.m_leftX + w/2;
	self.m_lifeIcon:setPosition(x,y + 8 * display.contentScaleFactor);
	self.m_lifeIcon:addTo(self);

	local lifeText = self.m_player:getLife();
	self.m_lifeText = UICreator.createText(
		lifeText,25,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x + 80 * display.contentScaleFactor,y + 8 * display.contentScaleFactor,0,0,0);
	self.m_lifeText:addTo(self);

	h = self.m_lifeText:getContentSize().height;

	y = y - h * 1.2 ;

	-- Attack
	self.m_attackIcon = display.newSprite("player/attack.png");
	self.m_attackIcon:setPosition(x,y + 8 * display.contentScaleFactor);
	self.m_attackIcon:addTo(self);

	local attackText = self.m_player:getAttack();
	self.m_attackText = UICreator.createText(
			attackText,25,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x + 80 * display.contentScaleFactor,y + 8 * display.contentScaleFactor,0,0,0);
	self.m_attackText:addTo(self);

	y = y - h * 1.2 ;

	-- Defense
	self.m_defenseIcon = display.newSprite("player/defense.png");
	self.m_defenseIcon:setPosition(x,y + 8 * display.contentScaleFactor);
	self.m_defenseIcon:addTo(self);	

	local defenseText = self.m_player:getDefense();
	self.m_defenseText = UICreator.createText(
		defenseText,25,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x + 80 * display.contentScaleFactor,y + 8 * display.contentScaleFactor,0,0,0);
	self.m_defenseText:addTo(self);

	y = y - h * 1.2 ;

	-- 金币
	self.m_coinIcon = display.newSprite("prop/prop_coin.png");
	self.m_coinIcon:setPosition(x,y + 8 * display.contentScaleFactor);
	self.m_coinIcon:addTo(self);	

	local coinText = self.m_player:getCoin();
	self.m_coinText = UICreator.createText(
		coinText,25,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x + 80 * display.contentScaleFactor,y + 8 * display.contentScaleFactor,0,0,0);
	self.m_coinText:addTo(self);	

	y = y - h * 1.5 ;

	x = self.m_leftX + w/5;

	-- 黄钥匙
	self.m_yellowKey = display.newSprite("keys/yellow_key.png");
	self.m_yellowKey:setPosition(x , y + 8 * display.contentScaleFactor);
	self.m_yellowKey:addTo(self);

	local yellowText = self.m_player:getYelloKeys();
	self.m_yellowText = UICreator.createText(
		yellowText,25,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x + 30 * display.contentScaleFactor,y + 4 * display.contentScaleFactor,255,0,0);
	self.m_yellowText:addTo(self);	

	x = self.m_leftX + w * 0.8;

	-- 蓝钥匙
	self.m_blueKey = display.newSprite("keys/blue_key.png");
	self.m_blueKey:setPosition(x , y + 8 * display.contentScaleFactor);
	self.m_blueKey:addTo(self);

	local blueText = self.m_player:getBlueKeys();
	self.m_blueText = UICreator.createText(
		blueText,25,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x + 30 * display.contentScaleFactor,y + 4 * display.contentScaleFactor,255,0,0);
	self.m_blueText:addTo(self);

	x = self.m_leftX + w * 1.4;

	-- 红钥匙
	self.m_redKey = display.newSprite("keys/red_key.png");
	self.m_redKey:setPosition(x , y + 8 * display.contentScaleFactor);
	self.m_redKey:addTo(self);

	local redText = self.m_player:getRedKeys();
	self.m_redText = UICreator.createText(
		redText,25,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x + 30 * display.contentScaleFactor,y + 4 * display.contentScaleFactor,255,0,0);
	self.m_redText:addTo(self);		

	y = y - h * 1.5 ;

	-- Message
	x = self.m_leftX + w;
	self.m_messageText = UICreator.createText(
		"",15,cc.VERTICAL_TEXT_ALIGNMENT_CENTER,x ,y + 4 * display.contentScaleFactor,255,255,255);
	self.m_messageText:addTo(self);
end

function RoomScene:onEnter()

end

function RoomScene:dtor()

end

function RoomScene:onLeftResponse()
	if not self:logic("left") then 
		return ;
	end
end

function RoomScene:onRightResponse()
	if not self:logic("right") then 
		return ;
	end
end

function RoomScene:onUpResponse()
	if not self:logic("up") then 
		return ;
	end

end

function RoomScene:onDownResponse()
	if not self:logic("down") then 
		return ;
	end

end

----------------------------------------------------- 加载ui ----------------------------------------------
-- 绘制墙
function RoomScene:drawWall()
	local walls = self.m_map:getObjectGroup("bg_wall"):getObjects();
	for _,values in pairs(walls) do
		local wall = Wall.new();
		wall:show(values.x,values.y,0,0,self.m_map);

		if not self.m_wallWidth or not self.m_wallHeight then 
			self.m_wallWidth,self.m_wallHeight = wall:getWidthAndHeight();
		end

		self.m_colmap[values.x*values.y + values.x] = wall;
	end	
end

-- 绘制上下楼梯
function RoomScene:drawStairs()
	local up_stairs = self.m_map:getObjectGroup("up_floor"):getObjects();
	for _,values in pairs(up_stairs) do
		local stairs = UpStair.new();
		stairs:show(values.x,values.y,0,0,self.m_map);

		self.m_colmap[values.x*values.y + values.x] = stairs;  
	end	

	local down_stairs = self.m_map:getObjectGroup("down_floor"):getObjects();
	for _,values in pairs(down_stairs) do 
		local stairs = DownStair.new();
		stairs:show(values.x,values.y,0,0,self.m_map);

		self.m_colmap[values.x*values.y + values.x] = stairs;
	end
end

-- 绘制药水
function RoomScene:drawLiquid()
	local red_liquid = self.m_map:getObjectGroup("red_drink"):getObjects();
	for _,values in pairs(red_liquid) do
		local redDrink = RedDrink.new();
		redDrink:show(values.x,values.y,0,0,self.m_map);
		self.m_colmap[values.x*values.y + values.x] = redDrink;  
	end

	local blue_liquid = self.m_map:getObjectGroup("blue_drink"):getObjects();
	for _,values in pairs(blue_liquid) do 
		local blueDrink = BlueDrink.new();
		blueDrink:show(values.x,values.y,0,0,self.m_map);
		self.m_colmap[values.x*values.y+values.x] = blueDrink;
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
			self.m_colmap[values.x*values.y + values.x] = yellowKey;
		end
	end

	-- 蓝钥匙
	if self.m_map:getObjectGroup("blue_key") then 
		local blue_key = self.m_map:getObjectGroup("blue_key"):getObjects();
		for _,values in pairs(blue_key) do 
			local blueKey = BlueKey.new();
			blueKey:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y + values.x] = blueKey;
		end	
	end

	-- 红钥匙
	if self.m_map:getObjectGroup("red_key") then 
		local red_key = self.m_map:getObjectGroup("red_key"):getObjects();
		for _,values in pairs(red_key) do 
			local redKey = RedKey.new();
			redKey:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y + values.x] = redKey;
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
			self.m_colmap[values.x*values.y + values.x] = yellow_door;
		end	
	end

	-- 蓝门
	if self.m_map:getObjectGroup("blue_door") then 
		local blue_doors = self.m_map:getObjectGroup("blue_door"):getObjects();
		for _,values in pairs(blue_doors) do 
			local blue_door = BlueDoor.new();
			blue_door:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y + values.x] = blue_door;
		end	
	end

	-- 红门
	if self.m_map:getObjectGroup("red_door") then 
		local red_doors = self.m_map:getObjectGroup("red_door"):getObjects();
		for _,values in pairs(red_doors) do 
			local red_door = RedDoor.new();
			red_door:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y + values.x] = red_door;
		end	
	end
end

-- 绘制精灵
function RoomScene:loadSprite()
	local players = self.m_map:getObjectGroup("track"):getObjects();

	for _,v in pairs(players) do 
		self.m_player = Player.new(self);
		self.m_playerSprite = self.m_player:show(v.x,v.y,0,0,self.m_map,"up");
	end
end

-- 绘制攻击和防御
function RoomScene:drawAttackAndDefense()
	if self.m_map:getObjectGroup("attack") then 
		local attacks = self.m_map:getObjectGroup("attack"):getObjects();
		for _,values in pairs(attacks) do 
			local attack = AttackProp.new();
			attack:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y + values.x] = attack;
		end
	end

	if self.m_map:getObjectGroup("defense") then 
		local defenses = self.m_map:getObjectGroup("defense"):getObjects();

		for _,values in pairs(defenses) do 
			local defense = DefenseProp.new();
			defense:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y + values.x] = defense;
		end
	end
end

-- 绘制特殊道具
function RoomScene:drawSpeicalProp()
	if self.m_map:getObjectGroup("jump") then 
		local jumps = self.m_map:getObjectGroup("jump"):getObjects();

		for _,values in pairs(jumps) do 
			local jump = JumpProp.new();
			jump:show(values.x,values.y,0,0,self.m_map);
			self.m_colmap[values.x*values.y + values.x] = jump;
		end
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
			self.m_colmap[values.x*values.y + values.x] = greenSlime;
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
			self.m_colmap[values.x*values.y + values.x] = redSlime;
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
			self.m_colmap[values.x*values.y + values.x] = spider;
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
			self.m_colmap[values.x*values.y + values.x] = priest;
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
			self.m_colmap[values.x*values.y + values.x] = skeletonA;
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
			self.m_colmap[values.x*values.y + values.x] = skeletonB;
		end	
	end
end

-------------------------------------logic ---------------------------------------------
-- 主要逻辑处理
function RoomScene:logic(direction)
	if self.m_isLogic then 
		print("还有逻辑在处理")
		return;
	end

	if self.m_player.m_isAttacked then 
		print("在攻击状态");
		return;
	end

	self.m_isLogic = true;

	local x, y = self.m_player:getCurrentPos();

	if direction == "left" then 
		x = x - self.m_wallWidth;

	elseif direction == "right" then
		x = x + self.m_wallWidth;

	elseif direction == "up" then
		y = y + self.m_wallHeight;

	elseif direction == "down" then 
		y = y - self.m_wallHeight;
	end

	-- 墙壁
	if self.m_colmap[x * y + x] and self.m_colmap[x * y + x].m_isSolid then 
		print("is wall");
		self.m_player:setDirection(direction);
		self.m_isLogic = false;
		return false;
	end

	-- 楼梯
	if self.m_colmap[x * y + x] and self.m_colmap[x * y + x].m_isStair then 
		if self.m_colmap[x * y + x].m_direction == "up" then 
			print("向上一层")

		elseif self.m_colmap[x * y + x].m_direction == "down" then 
			print("向下一层");
		end
	end

	-- 门
	if self.m_colmap[x * y + x] and self.m_colmap[x * y + x].m_isDoor then 
		print("start the door");

		-- 黄门
		if self.m_colmap[x * y + x].m_doorId == 1 then 

			if self.m_player:getYelloKeys() <= 0 then 
				print("no yellow door");
				self.m_player:setDirection(direction)
				self.m_isLogic = false;
				return false;
			end

			self:dispatchEvent({name = Player.ACTION_CONSUME_KEY, style = kYellowKey,value = 1});

		-- 蓝门
		elseif self.m_colmap[x * y + x].m_doorId == 2 then 

			if self.m_player:getBlueKeys() <= 0 then 
				print("no blue door");
				self.m_player:setDirection(direction)
				self.m_isLogic = false;
				return false;
			end

			self:dispatchEvent({name = Player.ACTION_CONSUME_KEY, style = kBlueKey,value = 1});

		-- 红门
		elseif self.m_colmap[x * y + x].m_doorId == 3 then 
			if self.m_player:getRedKeys() <= 0 then 
				print("no red door");
				self.m_player:setDirection(direction)
				self.m_isLogic = false;
				return false;
			end

			self:dispatchEvent({name = Player.ACTION_CONSUME_KEY, style = kRedKey,value = 1});

		end

		self.m_player:setDirection(direction);

		local callBack = function()
			self.m_colmap[x * y + x]:setVisible(false);
			self:onDirectionClick(direction);
		end
		
		self.m_colmap[x * y + x]:play(callBack);
		return false;
	end
	
	-- 道具
	if self.m_colmap[x * y + x] and self.m_colmap[x * y + x].m_propId and tonumber(self.m_colmap[x * y + x].m_propId ) > 0 then
		print("道具" .. self.m_colmap[x * y + x].m_name) 
		-- 黄钥匙
		if self.m_colmap[x * y + x].m_propId == 1 then 
			self:dispatchEvent({name = Player.ACTION_ADD_KEY, style = kYellowKey,value = 1});

		-- 蓝钥匙
		elseif self.m_colmap[x * y + x].m_propId == 2 then  
			self:dispatchEvent({name = Player.ACTION_ADD_KEY, style = kBlueKey,value = 1});

		-- 红钥匙
		elseif self.m_colmap[x * y + x].m_propId == 3 then
			self:dispatchEvent({name = Player.ACTION_ADD_KEY, style = kRedKey,value = 1});

		-- 红药水,蓝药水
		elseif self.m_colmap[x * y + x].m_propId == 21 or self.m_colmap[x * y + x].m_propId == 22 then 
			self:dispatchEvent({name = Player.ACTION_ADD_LIFE,value = self.m_colmap[x * y + x]:getValue()});

		-- 攻击
		elseif self.m_colmap[x * y + x].m_propId == 11 then 
			self:dispatchEvent({name = Player.ACTION_ADD_ATTACK,value = self.m_colmap[x * y + x]:getValue()});

		-- 防御
		elseif self.m_colmap[x * y + x].m_propId == 12 then 
			self:dispatchEvent({name = Player.ACTION_ADD_DEFENSE,value = self.m_colmap[x * y + x]:getValue()});

		-- 特殊道具
		elseif self.m_colmap[x * y + x].m_propId > 100 then 
			self.m_player:setProp(self.m_colmap[x*y + x])
		end

		self.m_player:setDirection(direction);
		self.m_colmap[x * y + x]:setVisible(false);

		self.m_player:toString();
	end

	self:onDirectionClick(direction);	

	if self.m_colmap[x * y + x] and self.m_colmap[x*y + x].m_enemyId and tonumber(self.m_colmap[x * y + x].m_enemyId) > 0 then 
		self:attack(self.m_player,self.m_colmap[x * y + x],x,y);
	end

	return true;
end

function RoomScene:onDirectionClick(direction)
	local callBack = function()
		self.m_isLogic = false;
	end

	if direction == "left" then 
		self.m_player:onLeftClick(callBack);
	
	elseif direction == "right" then 
		self.m_player:onRightClick(callBack);

	elseif direction == "up" then 
		self.m_player:onUpClick(callBack);

	elseif direction == "down" then 
		self.m_player:onDownClick(callBack);
	end

end

function RoomScene:attack(player,enemy,x,y)
	if tonumber(player.m_attack < enemy.m_defense) then 
		-- 不能打
		print("打不过，毋庸置疑")
		return false;
	end

	player.m_isAttacked = true;

	self.m_isFirstOrNot = true;

	local attackCallBack = function()
		-- 第一个打的是人
		if self.m_isFirstOrNot then 
			local attackLife = player.m_attack - enemy.m_defense;
			
			if attackLife <= 0 then 
				attackLife = 0;
			end

			enemy.m_life = enemy.m_life - attackLife;

			if enemy.m_life < 0 then 
				enemy.m_life = 0;
			end

			local explosion = cc.ParticleFireworks:create();
			explosion:pos(x+16,y)
			-- explosion:setAnchorPoint(cc.p(0,0))
			explosion:setAutoRemoveOnFinish(true);
			explosion:setTotalParticles(30);
			-- explosion:setLife(1.0);
			explosion:setDuration(1);

			explosion:addTo(self.m_map);
		else
			
			local needLife = enemy.m_attack - player.m_defense;
			if needLife <= 0 then 
				needLife = 0;
			end

			self:dispatchEvent({name = Player.ACTION_MINUS_LIFE,value = needLife});
		end

		if player.m_life <= 0 then 
			player.m_life = 0;
			print("you died")
			player.m_sprite:stopAllActions();
			player.m_isAttacked = false;
		end

		if enemy.m_life <= 0 then 
			enemy.m_life = 0;
			print("enemy died");
			player.m_sprite:stopAllActions();
			enemy:died();
			player.m_isAttacked = false;

			self:dispatchEvent({name = Player.ACTION_ADD_COIN,value = enemy.m_coin});

		end

		print("m_life:" .. player.m_life)
		print("other_life" .. enemy.m_life);
		self.m_isFirstOrNot = not self.m_isFirstOrNot;
	end

	local callFunc = cc.CallFunc:create(function()
		attackCallBack();
	end);

	player.m_sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1),callFunc)));

end


function RoomScene:updateYellowKey(action)
	local nowKey = self.m_yellowText:getString();
	local yellowKeys = self.m_player:getYelloKeys();

	local i = nowKey;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_KEY then 
			i = i + 1;
		else
			i = i - 1;
		end

		if i < 0 then
			i = 0; 
		end

		self.m_yellowText:stopAllActions();

		self.m_yellowText:setString(i);

	end);

	local time = 2 / (yellowKeys - nowKey); 
	self.m_yellowText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)))

	
end

function RoomScene:updateBlueKey()
	local blueKeys = self.m_player:getBlueKeys();
	self.m_blueText:setString(blueKeys);
end

function RoomScene:updateRedKey()
	local redKeys = self.m_player:getRedKeys();
	self.m_redText:setString(redKeys);
end

function RoomScene:updateLife()
	local life = self.m_player:getLife();
	self.m_lifeText:setString(life);
end

function RoomScene:updateAttack()
	local attack = self.m_player:getAttack();
	self.m_attackText:setString(attack);
end

function RoomScene:updateDefense()
	local defense = self.m_player:getDefense();
	self.m_defenseText:setString(defense);
end

function RoomScene:updateCoin()
	local coin = self.m_player:getCoin();
	self.m_coinText:setString(coin);
end

function RoomScene:updateAttack(value)
	self.m_attackText:setString(value);
end

function RoomScene:updateDefense(value)
	self.m_defenseText:setString(value);
end

function RoomScene:updateCoin(value)
	self.m_coinText:setString(value);
end

return RoomScene;