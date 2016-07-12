-- SkeletonA
local Enemy = require("app.entity.Enemy");

local SkeletonA = class("SkeletonA",Enemy);

function SkeletonA:ctor()
	SkeletonA.super:ctor();

	self.m_res_anims = "primary_enemy/skeleton_enhance";

	self.m_attack = 20 -- 攻击力
	self.m_defense = 5; -- 防御力
	self.m_coin = 3; --金币数
	self.m_life = 100; -- 生命
end

return SkeletonA;