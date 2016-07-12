-- RedSlime
local Enemy = require("app.entity.Enemy");

local RedSlime = class("RedSlime",Enemy);

function RedSlime:ctor()
	RedSlime.super:ctor();

	self.m_res_anims = "primary_enemy/red_slame";

	self.m_attack = 20 -- 攻击力
	self.m_defense = 5; -- 防御力
	self.m_coin = 3; --金币数
	self.m_life = 100; -- 生命
end

return RedSlime;