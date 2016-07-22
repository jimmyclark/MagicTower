-- 楼梯
local Stair = class("Stair");

function Stair:ctor()
	self.m_res = "";	
	self.m_isStair = true;
	self.m_direction = "";
end

function Stair:show(x,y,anchorX,anchorY,root)
	self.m_sprite = display.newSprite(self.m_res);
	self.m_sprite:pos(x,y);
	self.m_sprite:setAnchorPoint(cc.p(anchorX,anchorY));
	self.m_sprite:addTo(root);

	return self.m_sprite;
end

return Stair;	