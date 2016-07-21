-- SkeletonB
local Enemy = require("app.entity.monster.Enemy");

local SkeletonB = class("SkeletonB",Enemy);

function SkeletonB:ctor()
	SkeletonB.super:ctor();

	self.m_res_anims = "primary_enemy/skeleton";

	self.m_attack = 42 -- 攻击力
	self.m_defense = 6; -- 防御力
	self.m_coin = 6; --金币数
	self.m_life = 50; -- 生命
end

return SkeletonB;