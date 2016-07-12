local Person = require("app.entity.Person");

local Enemy = class("Enemy",Person);

function Enemy:ctor()
	Enemy.super:ctor();
	self.m_res_anims = "";
end

-- 帧动画
function Enemy:show(x,y,anchorX,anchorY,root)
	if not self.m_isPlaying then 
		self.m_sprite = display.newSprite("enemy/" .. self.m_res_anims .. "1.png");
		self.m_sprite:pos(x,y);
		self.m_sprite:setAnchorPoint(cc.p(anchorX,anchorY));
		self.m_sprite:addTo(root);

		self.m_anim = cc.Animation:create();

		for i = 1, 4 do 
			self.m_anim:addSpriteFrameWithFile("enemy/" .. self.m_res_anims .. i .. ".png")
		end

		self.m_anim:setDelayPerUnit(0.15);

		self.m_sprite:playAnimationForever(self.m_anim);
		self.m_isPlaying = true;

		return self.m_sprite;
	end
end



return Enemy;	