-- 物品id
local BaseProp = class("BaseProp");

function BaseProp:ctor()
	self.m_propId = 0 ; -- 物品id
	self.m_res = ""; -- 物品资源路径
	self.m_extraValue = nil; -- 额外属性

	self.m_sprite = nil; -- 精灵
end

function BaseProp:show(x,y,anchorX,anchorY,root)
	if not self.m_sprite then 
		self.m_sprite = display.newSprite(self.m_res);
	end

	self.m_sprite:pos(x,y);
	self.m_sprite:setAnchorPoint(anchorX,anchorY);
	self.m_sprite:addTo(root);
	return self.m_sprite;
end

function BaseProp:getValue()
	return self.m_extraValue;
end

function BaseProp:setValue(value)
	self.m_extraValue = value;
end

function BaseProp:setVisible(isVisible) 
	self.m_sprite:setVisible(isVisible);
	self.m_propId = nil;
	self.m_name = "";
end

return BaseProp;