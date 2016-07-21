-- 药水
local Drink = class("Drink");

function Drink:ctor()
	self.m_value = 0; -- 药水恢复的值
	self.m_res = "";	
end

function Drink:show(x,y,anchorX,anchorY,root)
	self.m_sprite = display.newSprite(self.m_res);
	self.m_sprite:pos(x,y);
	self.m_sprite:setAnchorPoint(cc.p(anchorX,anchorY));
	self.m_sprite:addTo(root);

	return self.m_sprite;
end

function Drink:getValue()
	return self.m_value;
end

function Drink:setValue(value)
	self.m_value = value;
end

return Drink;	