-- GreenSlime
local Enemy = require("app.entity.monster.Enemy");

local GreenSlime = class("GreenSlime",Enemy);

function GreenSlime:ctor()
	GreenSlime.super:ctor();

	self.m_res_anims = "primary_enemy/green_slame";

	self.m_attack = 18 -- 攻击力
	self.m_defense = 1; -- 防御力
	self.m_coin = 1; --金币数
	self.m_life = 35; -- 生命
end

return GreenSlime;