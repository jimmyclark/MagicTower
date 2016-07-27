local Person = require("app.entity.Person");

local Player = class("Player",Person);

Player.ACTION_ADD_KEY = "action_addkey";
Player.ACTION_CONSUME_KEY = "action_consumekey";

Player.ACTION_ADD_LIFE = "action_addlife";
Player.ACTION_MINUS_LIFE = "action_minuslife";

Player.ACTION_ADD_ATTACK = "action_addAttack";
Player.ACTION_MINUS_ATTACK = "action_minusAttack";

Player.ACTION_ADD_DEFENSE = "action_addDefense";
Player.ACTION_MINUS_DEFENSE = "action_minusDefense";

Player.ACTION_ADD_COIN = "action_addCoin";
Player.ACTION_MINUS_COIN = "action_minusCoin";

kYellowKey 	= 1; -- 黄钥匙
kBlueKey 	= 2; -- 蓝钥匙
kRedKey 	= 3; -- 红钥匙

function Player:ctor(root)
	Player.super:ctor();

	self.m_upPlayerFile = "actor_up";
	self.m_downPlayerFile = "actor_down";
	self.m_leftPlayerFile = "actor_left";
	self.m_rightPlayerFile = "actor_right";

	self.m_upId = 1;
	self.m_rightId = 1;
	self.m_downId = 1;
	self.m_leftId = 1;

	self.m_scene = root;

	self.m_spriteX = 0;
	self.m_spriteY = 0;
	self.m_spriteW = 0;
	self.m_spriteH = 0;

	self.m_isPlaying = false; -- 是否在动

	self.m_moveTime = 0.5; -- 移动时间

	self.m_direction = "up"; -- 向上

	self.m_life = 1000; -- 血
	self.m_attack = 10; -- 攻击
	self.m_defense = 10; -- 防御
	self.m_coin = 0; -- 金币数

	self.m_yellowKeys = 10; -- 黄钥匙数
	self.m_blueKeys = 10; -- 蓝钥匙数
	self.m_redKeys = 10; -- 红钥匙数

	local shengSwallowProp = ShengSwallowProp.new();
	local shengShieldProp = ShengShieldProp.new();

	self.m_specialProps = {shengSwallowProp,shengShieldProp}; -- 特殊物品

	self.m_scene:addEventListener(self.ACTION_ADD_KEY, handler(self,self.onAddKey));
	self.m_scene:addEventListener(self.ACTION_CONSUME_KEY, handler(self,self.onConsumeKey));

	self.m_scene:addEventListener(self.ACTION_ADD_LIFE, handler(self,self.onAddLife));
	self.m_scene:addEventListener(self.ACTION_MINUS_LIFE, handler(self,self.onMinusLife));

	self.m_scene:addEventListener(self.ACTION_ADD_ATTACK, handler(self,self.onAddAttack));
	self.m_scene:addEventListener(self.ACTION_MINUS_ATTACK, handler(self,self.onMinusAttack));

	self.m_scene:addEventListener(self.ACTION_ADD_DEFENSE, handler(self,self.onAddDefense));
	self.m_scene:addEventListener(self.ACTION_MINUS_DEFENSE, handler(self,self.onMinusDefense));

	self.m_scene:addEventListener(self.ACTION_ADD_COIN, handler(self,self.onAddCoin));
	self.m_scene:addEventListener(self.ACTION_MINUS_COIN, handler(self,self.onMinusCoin));
end

-- 帧动画
function Player:show(x,y,anchorX,anchorY,root,direction)
	self.m_spriteX = x;
	self.m_spriteY = y;

	if direction == "left" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_leftPlayerFile .. self.m_leftId .. ".png");
		self.m_leftId = self.m_leftId + 1;

	elseif direction == "right" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_rightPlayerFile .. self.m_rightId .. ".png");
		self.m_rightId = self.m_rightId + 1;				

	elseif direction == "up" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_upPlayerFile .. self.m_upId .. ".png");
		self.m_upId = self.m_upId + 1;

	elseif direction == "down" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_downPlayerFile .. self.m_downId .. ".png");
		self.m_downId = self.m_downId + 1;
	end

	self.m_sprite:setAnchorPoint(anchorX,anchorY);
	self.m_sprite:pos(x,y);
	self.m_sprite:addTo(root);

	self.m_spriteW = self.m_sprite:getContentSize().width;
	self.m_spriteH = self.m_sprite:getContentSize().height;

	self.m_direction = direction;

	return self.m_sprite;
end


function Player:getWidth()
	return self.m_spriteW;
end

function Player:getHeight()
	return self.m_spriteH;
end

function Player:getWidthHeight()
	return self.m_spriteW,self.m_spriteH;
end

function Player:getCurrentPos()
	return self.m_spriteX,self.m_spriteY;
end

function Player:onLeftClick(callBack)
	if self.m_isPlaying then 
		return;
	end
	self.m_isPlaying = true;

	if (self.m_rightId % 2 ~= 0) and self.m_direction == "right" or 
	   (self.m_upId % 2 ~= 0)    and self.m_direction == "up" or 
	   (self.m_downId % 2 ~= 0)  and self.m_direction == "down" then 
		self.m_leftId = 1;

	elseif self.m_direction ~= "left" then 
		self.m_leftId = 2;
	end

	self.m_direction = "left";

	local action = cc.MoveBy:create(self.m_moveTime,cc.p(-self.m_spriteW,0));

	self.m_spriteX = self.m_spriteX - self.m_spriteW;

	self.m_sprite:setTexture("actors/" .. self.m_leftPlayerFile .. self.m_leftId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_leftId = self.m_leftId + 1;
		if self.m_leftId > 4 then 
			self.m_leftId = 1;
		end
		self.m_isPlaying = false;

		callBack();
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));

end

function Player:toString()
	local msg = "player-> life:" .. self.m_life .. "\t attack:" .. self.m_attack .. "\t defense:" .. self.m_defense 
		.. "\t yellowKeys:" .. self.m_yellowKeys .. "\t blueKeys:" .. self.m_blueKeys .. "\t redKeys:" .. self.m_redKeys .. "\n道具:"
		
	for i = 1,#self.m_specialProps do 
		msg = msg .. (self.m_specialProps[i].m_name)
	end

	return msg;
end

function Player:onRightClick(callBack)
	if self.m_isPlaying then 
		return;
	end

	self.m_isPlaying = true;

	if (self.m_leftId % 2 ~= 0) and self.m_direction == "left" or 
		(self.m_upId % 2 ~= 0)  and self.m_direction == "up" or 
		(self.m_downId % 2 ~= 0) and self.m_direction == "down" then 
		self.m_rightId = 1;

	elseif self.m_direction ~= "right" then 
		self.m_rightId = 2;
	end

	self.m_direction = "right";
	local action = cc.MoveBy:create(self.m_moveTime,cc.p(self.m_spriteW,0));

	self.m_spriteX = self.m_spriteX + self.m_spriteW;

	self.m_sprite:setTexture("actors/" .. self.m_rightPlayerFile .. self.m_rightId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_rightId = self.m_rightId + 1;
		if self.m_rightId > 4 then 
			self.m_rightId = 1;
		end
		self.m_isPlaying = false;
		callBack();
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));
end

function Player:onUpClick(callBack)
	if self.m_isPlaying then
		return;
	end
	self.m_isPlaying = true;

	if (self.m_leftId % 2 ~= 0) and self.m_direction == "left" or 
		(self.m_rightId % 2 ~= 0) and self.m_direction == "right" or 
		(self.m_downId % 2 ~= 0) and self.m_direction == "down" then 
		self.m_upId = 1;

	elseif self.m_direction ~= "up" then 
		self.m_upId = 2;
	end

	self.m_direction = "up";
	local action = cc.MoveBy:create(self.m_moveTime,cc.p(0,self.m_spriteH));

	self.m_spriteY = self.m_spriteY + self.m_spriteH;

	self.m_sprite:setTexture("actors/" .. self.m_upPlayerFile .. self.m_upId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_upId = self.m_upId + 1;
		if self.m_upId > 4 then 
			self.m_upId = 1;
		end
		self.m_isPlaying = false;
		callBack();
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));
end

function Player:onDownClick(callBack)
	if self.m_isPlaying then 
		return;
	end
	self.m_isPlaying = true;

	if (self.m_leftId % 2 ~= 0) and self.m_direction == "left" or 
		(self.m_rightId % 2 ~= 0) and self.m_direction == "right" or 
		(self.m_upId % 2 ~= 0) and self.m_direction == "up" then 
		self.m_downId = 1;

	elseif self.m_direction ~= "down" then 
		self.m_downId = 2;
	end

	self.m_direction = "down";
	local action = cc.MoveBy:create(self.m_moveTime,cc.p(0,-self.m_spriteH));

	self.m_spriteY = self.m_spriteY - self.m_spriteH;

	self.m_sprite:setTexture("actors/" .. self.m_downPlayerFile .. self.m_downId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_downId = self.m_downId + 1;
		if self.m_downId > 4 then 
			self.m_downId = 1;
		end
		self.m_isPlaying = false;
		callBack();
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));
end

function Player:clearAllDirections()

end

function Player:setLife(life)
	self.m_life = self.m_life + life;
end

function Player:getLife()
	return self.m_life;
end

function Player:setAttack(attack)
	self.m_attack = self.m_attack + attack;
end

function Player:getAttack()
	return self.m_attack;
end

function Player:setDefense(defense)
	self.m_defense = self.m_defense + defense;
end

function Player:getDefense()
	return self.m_defense;
end

function Player:setCoin(coin)
	self.m_coin = coin;
end

function Player:getCoin()
	return self.m_coin;
end

function Player:setYelloKeys(yellowKey)
	self.m_yellowKeys = self.m_yellowKeys + yellowKey;
end

function Player:getYelloKeys()
	return self.m_yellowKeys;
end

function Player:setBlueKeys(blueKey)
	self.m_blueKeys = self.m_blueKeys + blueKey;
end

function Player:getBlueKeys()
	return self.m_blueKeys;
end

function Player:setRedKeys(redKey)
	self.m_redKeys = self.m_redKeys + redKey;
end

function Player:getRedKeys()
	return self.m_redKeys;
end

function Player:setProp(prop)
	self.m_specialProps[#self.m_specialProps + 1] = publ_deepcopy(prop); 
end

function Player:removeProp(prop)
	for i = 1,#self.m_specialProps do 
		if self.m_specialProps[i].m_propId == prop.m_propId then 
			table.remove(self.m_specialProps[i]);
			return;
		end
	end
end

function Player:getProp()
	return self.m_specialProps;
end

function Player:setDirection(direction)
	self.m_sprite:setTexture("actors/actor_" .. direction .. "1.png" );
end

--深度拷贝一个table
function publ_deepcopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

--------------------------------------------事件--------------------------------------------------------
-- 加钥匙
function Player:onAddKey(event)
	if event.style == kYellowKey then 
		self.m_yellowKeys = self.m_yellowKeys + event.value;
		if self.m_scene then 
			self.m_scene:updateYellowKey(self.ACTION_ADD_KEY);
		end

	elseif event.style == kBlueKey then 
		self.m_blueKeys = self.m_blueKeys + event.value;

		if self.m_scene then 
			self.m_scene.updateBlueKey(self.ACTION_ADD_KEY);
		end

	elseif event.style == kRedKey then 
		self.m_redKeys = self.m_redKeys + event.value;

		if self.m_scene then 
			self.m_scene.updateRedKey(self.ACTION_ADD_KEY);
		end
	end
end

-- 消耗钥匙
function Player:onConsumeKey(event)
	if event.style == kYellowKey then 
		if self.m_yellowKeys > 0 then 
			self.m_yellowKeys = self.m_yellowKeys - event.value;
		end

		if self.m_yellowKeys < 0 then 
			self.m_yellowKeys = 0;
		end

		if self.m_scene then 
			self.m_scene:updateYellowKey(self.ACTION_CONSUME_KEY);
		end

	elseif event.style == kBlueKey then 
		if self.m_blueKeys > 0 then 
			self.m_blueKeys = self.m_blueKeys - event.value;
		end

		if self.m_blueKeys < 0 then 
			self.m_blueKeys = 0;
		end

		if self.m_scene then 
			self.m_scene.updateBlueKey(self.ACTION_CONSUME_KEY);
		end

	elseif event.style == kRedKey then 
		if self.m_redKeys > 0 then 
			self.m_redKeys = self.m_redKeys - event.value;
		end

		if self.m_redKeys < 0 then 
			self.m_redKeys = 0;
		end

		if self.m_scene then 
			self.m_scene.updateRedKey(self.ACTION_CONSUME_KEY);
		end
	end
end

-- 吃了血瓶，加血
function Player:onAddLife(event)
	if event.value then 
		self.m_life = self.m_life + event.value;
	end

	if self.m_life < 0 then 
		self.m_life = 0;
	end

	if self.m_scene then 
		self.m_scene:updateLife(self.ACTION_ADD_LIFE);
	end
end

-- 减血
function Player:onMinusLife(event)
	if event.value then 
		self.m_life = self.m_life - event.value;
	end

	if self.m_life <= 0 then 
		self.m_life = 0;
	end

	if self.m_scene then 
		self.m_scene:updateLife(self.ACTION_MINUS_LIFE);
	end
end

-- 加攻击
function Player:onAddAttack(event)
	if event.value then 
		self.m_attack = self.m_attack + event.value;
	end

	if self.m_attack < 0 then 
		self.m_attack = 0;
	end

	if self.m_scene then 
		self.m_scene:updateAttack(self.ACTION_ADD_ATTACK);
	end
end

-- 减攻击
function Player:onMinusAttack(event)
	if event.value then 
		self.m_attack = self.m_attack - event.value;
	end

	if self.m_attack < 0 then 
		self.m_attack = 0;
	end

	if self.m_scene then 
		self.m_scene:updateAttack(self.ACTION_MINUS_ATTACK);
	end
end

-- 加防御
function Player:onAddDefense(event)
	if event.value then 
		self.m_defense = self.m_defense + event.value;
	end

	if self.m_defense < 0 then 
		self.m_defense = 0;
	end

	if self.m_scene then 
		self.m_scene:updateDefense(self.ACTION_ADD_DEFENSE);
	end
end

-- 减攻击
function Player:onMinusDefense(event)
	if event.value then 
		self.m_defense = self.m_defense - event.value;
	end

	if self.m_defense < 0 then 
		self.m_defense = 0;
	end

	if self.m_scene then 
		self.m_scene:updateDefense(self.ACTION_MINUS_DEFENSE);
	end
end

-- 加金币
function Player:onAddCoin(event)
	if event.value then 
		self.m_coin = self.m_coin + event.value;
	end

	if self.m_coin < 0 then 
		self.m_coin = 0;
	end

	if self.m_scene then 
		self.m_scene:updateCoin(self.ACTION_ADD_COIN);
	end
end

-- 减金币
function Player:onMinusCoin(event)
	if event.value then 
		self.m_coin = self.m_coin - event.value;
	end

	if self.m_coin < 0 then 
		self.m_coin = 0;
	end

	if self.m_scene then 
		self.m_scene:updateCoin(self.ACTION_MINUS_COIN);
	end
end


return Player;	