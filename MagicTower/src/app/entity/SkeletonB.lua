-- SkeletonB
local Enemy = require("app.entity.Enemy");

local SkeletonB = class("SkeletonB",Enemy);

function SkeletonB:ctor()
	SkeletonB.super:ctor();

	self.m_res_anims = "primary_enemy/skeleton";

	self.m_attack = 20 -- 攻击力
	self.m_defense = 5; -- 防御力
	self.m_coin = 3; --金币数
	self.m_life = 100; -- 生命
end

return SkeletonB;