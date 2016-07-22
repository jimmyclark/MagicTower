-- 墙
local Wall = class("Wall");

function Wall:ctor()
	self.m_sprite = nil;
	self.m_isSolid = true; -- 是否实体(不透明)

	self.m_width = 0;
	self.m_height = 0;
end

-- 帧动画
function Wall:show(x,y,anchorX,anchorY,root)
	self.m_sprite = display.newSprite("walls/bg_wall2.png");
	self.m_sprite:pos(x,y);
	self.m_sprite:setAnchorPoint(cc.p(anchorX,anchorY));
	self.m_sprite:addTo(root);

	self.m_width = self.m_sprite:getContentSize().width;
	self.m_height = self.m_sprite:getContentSize().height;

	return self.m_sprite;
end

function Wall:getWidthAndHeight()
	return self.m_width,self.m_height;
end

return Wall;	