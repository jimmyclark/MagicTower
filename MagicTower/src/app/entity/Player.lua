local Person = require("app.entity.Person");

local Player = class("Player",Person);

function Player:ctor()
	Player.super:ctor();
	self.m_res_anims = "";

	self.m_upPlayerFile = "actor_up";
	self.m_downPlayerFile = "actor_down";
	self.m_leftPlayerFile = "actor_left";
	self.m_rightPlayerFile = "actor_right";

	self.m_upId = 1;
	self.m_rightId = 1;
	self.m_downId = 1;
	self.m_leftId = 1;
end

-- 帧动画
function Player:show(x,y,anchorX,anchorY,root,direction)
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
	return self.m_sprite;
end



return Player;	