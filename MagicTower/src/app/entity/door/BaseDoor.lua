-- 门基类
local BaseDoor = class("BaseDoor");

function BaseDoor:ctor()
	self.m_res = "";
	self.m_isDoor = true;
	self.m_name = "";	
end

function BaseDoor:show(x,y,anchorX,anchorY,root)
	self.m_sprite = display.newSprite("door/" .. self.m_res .. "1.png");
	self.m_sprite:pos(x,y);
	self.m_sprite:setAnchorPoint(cc.p(anchorX,anchorY));
	self.m_sprite:addTo(root);

	return self.m_sprite;
end

function BaseDoor:play(callBack)
	local callFunc = cc.CallFunc:create(callBack);

	local animation = cc.Animation:create();

	for i = 1,4 do 
		local name = "door/" .. self.m_res .. i .. ".png";
		animation:addSpriteFrameWithFile(name);
	end

	animation:setDelayPerUnit(2.8/14.0);

	local action = cc.Animate:create(animation);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));

	self.m_isDoor = false;
end

function BaseDoor:setVisible(isVisible)
	self.m_sprite:setVisible(isVisible);

end

return BaseDoor;	