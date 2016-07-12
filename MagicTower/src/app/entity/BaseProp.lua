local BaseProp = class("BaseProp");

function BaseProp:ctor()
	self.m_propId = 0 ; -- 物品id
	self.m_res = ""; -- 物品资源路径
	self.m_extraValues = nil; -- 额外属性
	self.m_showTables = nil; -- 显示数组

	self.m_sprite = nil; -- 精灵
end

function BaseProp:play()
	
end

function BaseProp:show(x,y,anchorX,anchorY,root)
	if not self.m_sprite then 
		self.m_sprite = display.newSprite(self.m_res .. "1.png");
	end

	self.m_sprite:pos(x,y);
	self.m_sprite:setAnchorPoint(anchorX,anchorY);
	self.m_sprite:addTo(root);
	return self.m_sprite;
end

function BaseProp:getValues()
	return self.m_extraValues;
end

return BaseProp;