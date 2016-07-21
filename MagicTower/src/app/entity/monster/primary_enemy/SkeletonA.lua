-- SkeletonA
local Enemy = require("app.entity.monster.Enemy");

local SkeletonA = class("SkeletonA",Enemy);

function SkeletonA:ctor()
	SkeletonA.super:ctor();

	self.m_res_anims = "primary_enemy/skeleton_enhance";

	self.m_attack = 52 -- 攻击力
	self.m_defense = 12; -- 防御力
	self.m_coin = 8; --金币数
	self.m_life = 55; -- 生命
end

return SkeletonA;