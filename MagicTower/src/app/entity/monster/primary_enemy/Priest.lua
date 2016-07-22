-- 法师Priest
local Enemy = require("app.entity.monster.Enemy");

local Priest = class("Priest",Enemy);

function Priest:ctor()
	Priest.super:ctor();

	self.m_res_anims = "primary_enemy/master";

	self.m_attack = 32 -- 攻击力
	self.m_defense = 8; -- 防御力
	self.m_coin = 5; --金币数
	self.m_life = 60; -- 生命

	self.m_name = priest;

	self.m_enemyId = 5;
end

return Priest;