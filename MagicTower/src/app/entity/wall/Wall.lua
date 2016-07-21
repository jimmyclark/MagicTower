-- 墙
local Wall = class("Wall");

function Wall:ctor()
	self.m_sprite = nil;
	self.m_isSolid = true; -- 是否实体(不透明)
end

-- 帧动画
function Wall:show(x,y,anchorX,anchorY,root)
	self.m_sprite = display.newSprite("walls/bg_wall2.png");
	self.m_sprite:pos(x,y);
	self.m_sprite:setAnchorPoint(cc.p(anchorX,anchorY));
	self.m_sprite:addTo(root);

	return self.m_sprite;
end

return Wall;	