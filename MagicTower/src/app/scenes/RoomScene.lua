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

ShengSwallowProp = require("app.entity.prop.ShengSwallowProp");
ShengShieldProp = require("app.entity.prop.ShengShieldProp");

Message = require("app.message.Message");

Player = require("app.entity.Player")

function RoomScene:ctor()
	self.m_colmap = {}; -- map映射表[x*y] = 对应的位置

	self.m_currentFloor = 1; -- 当前楼层

	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods();

	self:createBgLayer();

	self:createMainLayer();

	self:createLeftContent();

	self:createRightContent();
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
	self.m_leftBg:setPosition(display.cx - width , display.cy - height/2);
	self.m_leftBg:setAnchorPoint(cc.p(0.5,1))
	self.m_leftBg:addTo(self);

	self:createPerson();
end

function RoomScene:createPerson()
	local width = self.m_leftBg:getContentSize().width;
	local height = self.m_leftBg:getContentSize().height;

	self.m_photo = display.newSprite("user.jpg");
	local w = self.m_photo:getContentSize().width;
	local h = self.m_photo:getContentSize().height;
	self.m_photo:setAnchorPoint(cc.p(0.5,1))
	self.m_photo:setPosition(width/2, height);
	self.m_photo:addTo(self.m_leftBg);

	local y = height - h - 40 * display.contentScaleFactor;

	-- Floor
	self.m_floorTitle = UICreator.createFontText(
		"Floor",20,cc.ui.TEXT_ALIGN_CENTER,width/2 - 20*display.contentScaleFactor,y ,255,255,0,"fonts/UIFont.fnt");
	self.m_floorTitle:addTo(self.m_leftBg);

	-- Floor 1
	self.m_floorText = UICreator.createText(
		self.m_currentFloor .. "",35,cc.ui.TEXT_ALIGN_CENTER,width/2 + 60 * display.contentScaleFactor,y + 5*display.contentScaleFactor,0,0,0);
	self.m_floorText:addTo(self.m_leftBg);

	h = self.m_floorTitle:getContentSize().height;

	y = y - 40 * display.contentScaleFactor;

	-- Life
	self.m_lifeIcon = display.newSprite("player/life.png");
	self.m_lifeIcon:setPosition(width/2 - 40 * display.contentScaleFactor,y);
	self.m_lifeIcon:addTo(self.m_leftBg);

	local lifeText = self.m_player:getLife();
	self.m_lifeText = UICreator.createText(
		lifeText,25,cc.ui.TEXT_ALIGN_CENTER,width/2 + 10 * display.contentScaleFactor,y,0,0,0);
	self.m_lifeText:addTo(self.m_leftBg);

	y = y - 40 * display.contentScaleFactor;

	-- Attack
	self.m_attackIcon = display.newSprite("player/attack.png");
	self.m_attackIcon:setPosition(width/2 - 40 * display.contentScaleFactor,y);
	self.m_attackIcon:addTo(self.m_leftBg);

	local attackText = self.m_player:getAttack();
	self.m_attackText = UICreator.createText(
			attackText,25,cc.ui.TEXT_ALIGN_CENTER,width/2 + 10 * display.contentScaleFactor,y,0,0,0);
	self.m_attackText:addTo(self.m_leftBg);

	y = y - 40 * display.contentScaleFactor;

	-- Defense
	self.m_defenseIcon = display.newSprite("player/defense.png");
	self.m_defenseIcon:setPosition(width/2 - 40 * display.contentScaleFactor,y);
	self.m_defenseIcon:addTo(self.m_leftBg);	

	local defenseText = self.m_player:getDefense();
	self.m_defenseText = UICreator.createText(
		defenseText,25,cc.ui.TEXT_ALIGN_CENTER,width/2 + 10 * display.contentScaleFactor,y,0,0,0);
	self.m_defenseText:addTo(self.m_leftBg);

	y = y - 40 * display.contentScaleFactor;

	-- 金币
	self.m_coinIcon = display.newSprite("prop/prop_coin.png");
	self.m_coinIcon:setPosition(width/2 - 40 * display.contentScaleFactor,y);
	self.m_coinIcon:addTo(self.m_leftBg);	

	local coinText = self.m_player:getCoin();
	self.m_coinText = UICreator.createText(
		coinText,25,cc.ui.TEXT_ALIGN_CENTER,width/2 + 10 * display.contentScaleFactor,y,0,0,0);
	self.m_coinText:addTo(self.m_leftBg);	

	y = y - 40 * display.contentScaleFactor;

	-- 黄钥匙
	self.m_yellowKey = display.newSprite("keys/yellow_key.png");
	self.m_yellowKey:setPosition(width/2 - 70 * display.contentScaleFactor , y);
	self.m_yellowKey:addTo(self.m_leftBg);

	local yellowText = self.m_player:getYelloKeys();
	self.m_yellowText = UICreator.createText(
		yellowText,20,cc.ui.TEXT_ALIGN_CENTER,width/2 - 50 * display.contentScaleFactor,y,255,0,0);
	self.m_yellowText:addTo(self.m_leftBg);	

	-- 蓝钥匙
	self.m_blueKey = display.newSprite("keys/blue_key.png");
	self.m_blueKey:setPosition(width/2 - 10 * display.contentScaleFactor , y);
	self.m_blueKey:addTo(self.m_leftBg);

	local blueText = self.m_player:getBlueKeys();
	self.m_blueText = UICreator.createText(
		blueText,20,cc.ui.TEXT_ALIGN_CENTER,width/2 + 10 * display.contentScaleFactor ,y,255,0,0);
	self.m_blueText:addTo(self.m_leftBg);

	-- 红钥匙
	self.m_redKey = display.newSprite("keys/red_key.png");
	self.m_redKey:setPosition(width/2 + 50 * display.contentScaleFactor , y);
	self.m_redKey:addTo(self.m_leftBg);

	local redText = self.m_player:getRedKeys();
	self.m_redText = UICreator.createText(
		redText,20,cc.ui.TEXT_ALIGN_CENTER,width/2 + 70 * display.contentScaleFactor , y,255,0,0);
	self.m_redText:addTo(self.m_leftBg);		

	y = y - 40 * display.contentScaleFactor;

	-- Message
	self.m_messageText = UICreator.createText(
		"",15,cc.ui.TEXT_ALIGN_CENTER, width/2,y,255,255,255);
	self.m_messageText:addTo(self.m_leftBg);
end

function RoomScene:createRightContent()
	self.m_rightBg = cc.LayerColor:create(cc.c4b(255, 255, 255, 128));

	local l_width = self.m_leftBg:getContentSize().width;
	local l_height = self.m_leftBg:getContentSize().height;
	local width = self.m_map:getContentSize().width;
	local height = self.m_map:getContentSize().height;
	self.m_rightBg:setContentSize(width/2,height);
	self.m_rightBg:setPosition(display.cx + width/2,  display.cy - height/2);
	self.m_rightBg:setAnchorPoint(cc.p(0.5,1))
	self.m_rightBg:addTo(self);

	-- 创建道具列表
	self:createProp();

	-- 创建Enemy列表
	self:createEnemy();
end

-- 创建道具
function RoomScene:createProp()
	local w = self.m_rightBg:getContentSize().width - 10 * display.contentScaleFactor;
	local h = self.m_rightBg:getContentSize().height;	

	-- Prop
	self.m_propTitle = UICreator.createFontText(
		"Prop",20,cc.ui.TEXT_ALIGN_CENTER,w/2,h,255,255,0,"fonts/UIFont.fnt");
	self.m_propTitle:setAnchorPoint(cc.p(0.5,1))
	self.m_propTitle:addTo(self.m_rightBg);

	-- local height = h - 160 * display.contentScaleFactor;
	local y = h - 60 * display.contentScaleFactor;
	-- -- prop bg
	self.m_propBg = UICreator.createImg("hud.png",true,w/2, y,w - 10 * display.contentScaleFactor , h /4);
	self.m_propBg:addTo(self.m_rightBg);
	self.m_propBg:setAnchorPoint(cc.p(0.5,1))

	-- Prop Page
	local viewRect = cc.rect(10*display.contentScaleFactor,0,w,h/4);
	local padding = {left = 20 ,right = 20,top = 0,bottom = 40};

	self.m_propList = UICreator.createPageView(viewRect,3,2,padding,20,20,false);
	self.m_propList:addTo(self.m_propBg);

    -- add items
    for i=1,#self.m_player.m_specialProps do
        local item = self.m_propList:newItem();
        local content

        local prop = self.m_player.m_specialProps[i];
        content = UICreator.createBtnText(prop.m_res,true,0,0,display.CENTER);
		content:onButtonClicked(function(event)
			print(prop.m_res)
		end);
 
        item:addChild(content)
        self.m_propList:addItem(item)        
    end

    self.m_propList:reload();
end

function RoomScene:createEnemy()
	local w = self.m_rightBg:getContentSize().width;
	local h = self.m_rightBg:getContentSize().height;	

    self.m_enemyTitle = UICreator.createFontText(
    	"Enemy",20,cc.ui.TEXT_ALIGN_CENTER,w/2,h/2,255,255,0,"fonts/UIFont.fnt");
    self.m_enemyTitle:addTo(self.m_rightBg);

    h = h/2 - 40 * display.contentScaleFactor;

    -- iconBg
    self.m_enemyIconMask = display.newSprite("headMask.png");
    self.m_enemyIconMask:pos(w/2,h)
    self.m_enemyIconMask:scale(0.5);
    self.m_enemyIconMask:addTo(self.m_rightBg);

    self.m_enemyIcon = display.newSprite("blank.png");
    self.m_enemyIcon:pos(w/2 - 2 * display.contentScaleFactor,h + 3 * display.contentScaleFactor)
    self.m_enemyIcon:addTo(self.m_rightBg);

 	h = h - 30 * display.contentScaleFactor;

    -- Name
    self.m_enemyNameTitle = UICreator.createText("Name:",20,cc.ui.TEXT_ALIGN_CENTER,w/3
     ,h,255,255,255);
    self.m_enemyNameTitle:addTo(self.m_rightBg);

    -- EnemyName Text
    self.m_enemyNameText = UICreator.createText("",18,cc.ui.TEXT_ALIGN_CENTER,w*2/3 + 3 * display.contentScaleFactor
    	,h,128,128,128);
    self.m_enemyNameText:addTo(self.m_rightBg);

    h = h - 30 * display.contentScaleFactor;

    -- Life
    self.m_enemyLifeTitle = UICreator.createText("Life:",20,cc.ui.TEXT_ALIGN_CENTER,w/3 + 3 * display.contentScaleFactor
     ,h,255,255,255);
    self.m_enemyLifeTitle:addTo(self.m_rightBg);

     -- Life Text
    self.m_enemyLifeText = UICreator.createText("0",20,cc.ui.TEXT_ALIGN_CENTER,w*2/3
    	,h,128,128,128);
    self.m_enemyLifeText:addTo(self.m_rightBg);

    h = h - 30 * display.contentScaleFactor;

    -- Attack
    self.m_enemyAttackTitle = UICreator.createText("Attack:",20,cc.ui.TEXT_ALIGN_CENTER,w/3 - 3 * display.contentScaleFactor
     ,h,255,255,255);
    self.m_enemyAttackTitle:addTo(self.m_rightBg);

     -- Attack Text
    self.m_enemyAttackText = UICreator.createText("0",20,cc.ui.TEXT_ALIGN_CENTER,w*2/3
    	,h,128,128,128);
    self.m_enemyAttackText:addTo(self.m_rightBg);

     h = h - 30 * display.contentScaleFactor;

    -- Defense
    self.m_enemyDefenseTitle = UICreator.createText("Defense:",20,cc.ui.TEXT_ALIGN_CENTER,w/3 - 3 * display.contentScaleFactor
     ,h,255,255,255);
    self.m_enemyDefenseTitle:addTo(self.m_rightBg);

     -- Defense Text
    self.m_enemyDefenseText = UICreator.createText("0",20,cc.ui.TEXT_ALIGN_CENTER,w*2/3
    	,h,128,128,128);
    self.m_enemyDefenseText:addTo(self.m_rightBg);
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

	self.m_messageText:setString("");
	self:clearEnemy();

	-- 墙壁
	if self.m_colmap[x * y + x] and self.m_colmap[x * y + x].m_isSolid then 
		self.m_messageText:setString(Message.TOUCH_WALL);

		self.m_player:setDirection(direction);
		self.m_isLogic = false;
		return false;
	end

	-- 楼梯
	if self.m_colmap[x * y + x] and self.m_colmap[x * y + x].m_isStair then 
		if self.m_colmap[x * y + x].m_direction == "up" then 
			self.m_messageText:setString(Message.UP_FLOOR);

		elseif self.m_colmap[x * y + x].m_direction == "down" then 
			self.m_messageText:setString(Message.DOWN_FLOOR);
		end
	end

	-- 门
	if self.m_colmap[x * y + x] and self.m_colmap[x * y + x].m_isDoor then 
		-- 黄门
		if self.m_colmap[x * y + x].m_doorId == 1 then 
			if self.m_player:getYelloKeys() <= 0 then 
				self.m_messageText:setString(Message.NOT_HAVE_YELLOW_KEY);
				self.m_player:setDirection(direction)
				self.m_isLogic = false;
				return false;
			end

			self.m_messageText:setString(Message.USE_YELLOW_KEY);
			self:dispatchEvent({name = Player.ACTION_CONSUME_KEY, style = kYellowKey,value = 1});

		-- 蓝门
		elseif self.m_colmap[x * y + x].m_doorId == 2 then 
			if self.m_player:getBlueKeys() <= 0 then 
				self.m_messageText:setString(Message.NOT_HAVE_BLUE_KEY);
				self.m_player:setDirection(direction)
				self.m_isLogic = false;
				return false;
			end

			self.m_messageText:setString(Message.USE_BLUE_KEY);
			self:dispatchEvent({name = Player.ACTION_CONSUME_KEY, style = kBlueKey,value = 1});

		-- 红门
		elseif self.m_colmap[x * y + x].m_doorId == 3 then 
			if self.m_player:getRedKeys() <= 0 then 
				self.m_messageText:setString(Message.NOT_HAVE_RED_KEY);
				self.m_player:setDirection(direction)
				self.m_isLogic = false;
				return false;
			end

			self.m_messageText:setString(Message.USE_RED_KEY);
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
			self:updatePropList();
		end

		self.m_player:setDirection(direction);
		self.m_messageText:setString(string.format(Message.GET_PROP_PREFIX,self.m_colmap[x * y + x].m_name));

		self.m_colmap[x * y + x]:setVisible(false);
	end

	if self.m_colmap[x * y + x] and self.m_colmap[x*y + x].m_enemyId and tonumber(self.m_colmap[x * y + x].m_enemyId) > 0 then 
		local enemy_attackLife =  self.m_colmap[x * y + x].m_attack - self.m_player.m_defense;
		local enemy_count = math.ceil(self.m_player.m_life/enemy_attackLife);

		local player_attackLife = self.m_player.m_attack - self.m_colmap[x*y + x].m_defense;
		local player_count = math.ceil(self.m_colmap[x*y + x].m_life / player_attackLife);
		if tonumber(self.m_player.m_attack) < tonumber(self.m_colmap[x * y + x].m_defense) or 
			enemy_count - player_count <= 0 and enemy_count > 0 then 
			-- 不能打
			self.m_messageText:setString(Message.ATTACK_NOT_BEAT);
			self.m_player:setDirection(direction);
			self:updateEnemy(self.m_colmap[x * y + x]);
			self.m_isLogic = false;
			return;
		end
	end

	self:onDirectionClick(direction);	
	
	if self.m_colmap[x * y + x] and self.m_colmap[x*y + x].m_enemyId and tonumber(self.m_colmap[x * y + x].m_enemyId) > 0 then 
		local callFunc = cc.CallFunc:create(function()
			self:attack(self.m_colmap[x * y + x],x,y);
		end);

		self:runAction(cc.Sequence:create(cc.DelayTime:create(1),callFunc));
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

function RoomScene:attack(enemy,x,y)
	local attackLife = self.m_player.m_attack - enemy.m_defense;

	self:updateEnemy(enemy);

	local count = math.floor(enemy.m_life/attackLife);

	if self.m_isLifeAction then 
		self.m_isLifeAction = false;
		self.m_lifeText:stopAllActions();
		local actualLife = self.m_player:getLife();
		self.m_lifeText:setString(actualLife);
		self:attack(enemy,x,y);
		return true;
	end

	self.m_player.m_isAttacked = true;

	if tonumber(enemy.m_life) - tonumber(attackLife) <= 0 then 
		self.m_messageText:setString(string.format(Message.ATTACK_SUCCESS,self.m_colmap[x * y + x].m_name,enemy.m_coin));
		enemy.m_life = 0;
		self:updateEnemy(enemy);
		enemy:died();
		self.m_player.m_isAttacked = false;
		self:dispatchEvent({name = Player.ACTION_ADD_COIN,value = enemy.m_coin});
		return true;
	end

	self.m_isFirstOrNot = true;

	local attackCallBack = function()
		-- 第一个打的是人
		if self.m_isFirstOrNot then 
			local attackLife = self.m_player.m_attack - enemy.m_defense;
			
			if attackLife <= 0 then 
				attackLife = 0;
			end

			enemy.m_life = enemy.m_life - attackLife;

			if enemy.m_life <= 0 then 
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

			self:updateEnemy(enemy);

			if enemy.m_life <= 0 then 
				enemy.m_life = 0;
				self.m_player.m_sprite:stopAllActions();
				self.m_messageText:setString(string.format(Message.ATTACK_SUCCESS,self.m_colmap[x * y + x].m_name,enemy.m_coin));

				enemy:died();
				self.m_player.m_isAttacked = false;
				self:dispatchEvent({name = Player.ACTION_ADD_COIN,value = enemy.m_coin});

				self.m_isFirstOrNot = true;
				return true;
			end

			self.m_messageText:setString(string.format(Message.ATTACK_ENEMY,self.m_colmap[x * y + x].m_name));

		else
			local needLife = enemy.m_attack - self.m_player.m_defense;
			if needLife <= 0 then 
				needLife = 0;
			end

			self:dispatchEvent({name = Player.ACTION_MINUS_LIFE,value = needLife});

			if self.m_player.m_life <= 0 then 
				self.m_player.m_life = 0;
				print("you died")
				self.m_player.m_sprite:stopAllActions();
				self.m_player.m_isAttacked = false;
				self.m_isFirstOrNot = true;
				return true;
			end
		end

		print("enemy.life:" .. enemy.m_life);
		print("player.life:" .. self.m_player.m_life);

		self.m_isFirstOrNot = not self.m_isFirstOrNot;
	end

	local callFunc = cc.CallFunc:create(function()
		attackCallBack();
	end);

	self.m_player.m_sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1),callFunc)));

end


function RoomScene:updateYellowKey(action)
	if self.m_isYellowKeyAction then 
		self.m_isYellowKeyAction = false;
		self.m_yellowText:stopAllActions();
		self:updateYellowKey(action);
		return;
	end

	self.m_isYellowKeyAction = true; -- 是否播放了黄色钥匙动画


	local nowKey = tonumber(self.m_yellowText:getString());
	local yellowKeys = self.m_player:getYelloKeys();

	if yellowKeys == nowKey then 
		print("两次值相同...");
		self.m_isYellowKeyAction = false;
		return;
	end

	local i = nowKey;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_KEY then 
			i = i + 1;
		else
			i = i - 1;
		end

		if i <= 0 then
			i = 0; 
			self.m_yellowText:stopAllActions();
			self.m_isYellowKeyAction = false;
		end
		
		if i >= yellowKeys then 
			i = yellowKeys;
			self.m_yellowText:stopAllActions();
			self.m_isYellowKeyAction = false;
		end

		self.m_yellowText:setString(i);

	end);

	local time = 1 / math.abs(yellowKeys - nowKey); 
	self.m_yellowText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)))

	
end

function RoomScene:updateBlueKey(action)
	if self.m_isBlueKeyAction then 
		self.m_isBlueKeyAction = false;
		self.m_blueText:stopAllActions();
		self:updateBlueKey(action);
		return;
	end

	self.m_isBlueKeyAction = true;

	local nowKey = tonumber(self.m_blueText:getString());
	local blueKeys = self.m_player:getBlueKeys();

	if tonumber(blueKeys) == tonumber(nowKey) then 
		print("两次值相同...");
		self.m_isBlueKeyAction = false;
		return;
	end

	local i = nowKey;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_KEY then
			i = i + 1; 
		else
			i = i - 1;
		end

		if i <= 0 then 
			i = 0;
			self.m_blueText:stopAllActions();
			self.m_isBlueKeyAction = false;
		end

		if i >= blueKeys then 
			i = blueKeys;
			self.m_blueText:stopAllActions();
			self.m_isBlueKeyAction = false;
		end

		self.m_blueText:setString(i);

	end);

	local time = 1 / math.abs(blueKeys - nowKey);
	self.m_blueText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)));
end

function RoomScene:updateRedKey(action)
	if self.m_isRedKeyAction then 
		self.m_isRedKeyAction = false;
		self.m_redText:stopAllActions();
		self:updateRedKey(action);
		return;
	end

	self.m_isRedKeyAction = true;

	local nowKey = tonumber(self.m_redText:getString());
	local redKeys = self.m_player:getRedKeys();

	if redKeys == nowKey then 
		print("两次值相同...");
		self.m_isRedKeyAction = false;
		return;
	end

	local i = nowKey;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_KEY then 
			i = i + 1;
		else
			i = i - 1;
		end

		if i <= 0 then 
			i = 0;
			self.m_redText:stopAllActions();
			self.m_isRedKeyAction = false;
		end

		if i >= redKeys then 
			i = redKeys;
			self.m_redText:stopAllActions();
			self.m_isRedKeyAction = false;
		end

		self.m_redText:setString(i);
	end);

	local time = 1 / math.abs(redKeys - nowKey);

	self.m_redText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)));

end

function RoomScene:updateLife(action)
	print("updateLife:" .. self.m_player:toString())
	if self.m_isLifeAction then 
		self.m_isLifeAction = false;
		self.m_lifeText:stopAllActions();
		self:updateLife(action);
		return;
	end

	self.m_isLifeAction = true;

	local nowLife = tonumber(self.m_lifeText:getString());
	local life = self.m_player:getLife();

	if nowLife == life then 
		print("两次值相同...");
		self.m_isLifeAction = false;
		return;
	end

	local i = nowLife;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_LIFE then 
			i = i + 1;
		else
			i = i - 1;
		end

		if i <= 0 then 
			i = 0;
			self.m_isLifeAction = false;
			self.m_lifeText:stopAllActions();
		end

		if i >= life then 
			i = life;
			self.m_isLifeAction = false;
			self.m_lifeText:stopAllActions();
		end
		
		self.m_lifeText:setString(i);
	end);

	local time = 1 / math.abs(life - nowLife);

	self.m_lifeText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)));

end

function RoomScene:updateAttack(action)
	if self.m_isAttackAction then 
		self.m_isAttackAction = false;
		self.m_attackText:stopAllActions();
		self:updateAttack(action);
		return;
	end

	self.m_isAttackAction = true;

	local nowAttack = tonumber(self.m_attackText:getString());
	local attack = self.m_player:getAttack();

	if nowAttack == attack then 
		print("两次值相同...");
		self.m_isAttackAction = false;
		return;
	end

	local i = nowAttack;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_ATTACK then 
			i = i + 1;
		else
			i = i - 1;
		end

		if i <= 0 then 
			i = 0;
			self.m_attackText:stopAllActions();
			self.m_isAttackAction = false;
		end

		if i >= attack then 
			i = attack;
			self.m_attackText:stopAllActions();
			self.m_isAttackAction = false;
		end

		self.m_attackText:setString(i);
	end);

	local time = 1 / math.abs(attack - nowAttack);

	self.m_attackText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)));
end

function RoomScene:updateDefense(action)
	if self.m_isDefenseAction then 
		self.m_isDefenseAction = false;
		self.m_defenseText:stopAllActions();
		self:updateDefense(action);
		return;
	end

	self.m_isDefenseAction = true;

	local nowDefense = tonumber(self.m_defenseText:getString());
	local defense = self.m_player:getDefense();

	if nowDefense == defense then 
		print("两次值相同...");
		self.m_isDefenseAction = false;
		return;
	end

	local i = nowDefense;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_DEFENSE then 
			i = i + 1;
		else
			i = i - 1;
		end

		if i <= 0 then 
			i = 0;
			self.m_defenseText:stopAllActions();
			self.m_isDefenseAction = false;
		end

		if i >= defense then 
			i = defense;
			self.m_defenseText:stopAllActions();
			self.m_isDefenseAction = false;
		end

		self.m_defenseText:setString(i);

	end);

	local time = 1 / math.abs(defense - nowDefense);

	self.m_defenseText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)));
end

function RoomScene:updateCoin(action)
	if self.m_isCoinAction then 
		self.m_isCoinAction = false;
		self.m_coinText:stopAllActions();
		self:updateCoin(action);
		return;
	end

	self.m_isCoinAction = true;

	local nowCoin = tonumber(self.m_coinText:getString());
	local coin = self.m_player:getCoin();

	if nowCoin == coin then 
		print("两次值相同...");
		self.m_isCoinAction = false;
		return;
	end

	local i = nowCoin;

	local callFunc = cc.CallFunc:create(function()
		if action == Player.ACTION_ADD_COIN then 
			i = i + 1;
		else
			i = i - 1;
		end

		if i <= 0 then 
			i = 0;
			self.m_coinText:stopAllActions();
			self.m_isCoinAction = false;
		end

		if i >= coin then 
			i = coin;
			self.m_coinText:stopAllActions();
			self.m_isCoinAction = false;
		end

		self.m_coinText:setString(i);
	end);

	local time = 1 / math.abs(coin - nowCoin);

	self.m_coinText:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(time),callFunc)));
end

function RoomScene:updateEnemy(enemy)
	if not enemy then 
		return;
	end
	self.m_enemyIcon:setTexture("enemy/".. enemy.m_res_anims .. "1.png")
	self.m_enemyNameText:setString(enemy.m_name);
	self.m_enemyAttackText:setString(enemy.m_attack);
	self.m_enemyDefenseText:setString(enemy.m_defense);
	self.m_enemyLifeText:setString(enemy.m_life);


end

function RoomScene:clearEnemy()
	self.m_enemyIcon:setTexture("blank.png")
	self.m_enemyNameText:setString("");
	self.m_enemyAttackText:setString(0);
	self.m_enemyDefenseText:setString(0);
	self.m_enemyLifeText:setString(0);
end

function RoomScene:updatePropList()
	-- 移除所有项
	self.m_propList:removeAllItems();

	 -- add items
    for i=1,#self.m_player.m_specialProps do
        local item = self.m_propList:newItem();
        local content

        local prop = self.m_player.m_specialProps[i];
        content = UICreator.createBtnText(prop.m_res,true,0,0,display.CENTER);
		content:onButtonClicked(function(event)
			print(prop.m_propId);
		end);
 
        item:addChild(content)
        self.m_propList:addItem(item)        
    end

	self.m_propList:reload();
end

return RoomScene;