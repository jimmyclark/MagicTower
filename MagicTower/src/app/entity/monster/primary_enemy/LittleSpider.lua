-- 小蝙蝠Bat
local Enemy = require("app.entity.monster.Enemy");

local LittleSpider = class("LittleSpider",Enemy);

function LittleSpider:ctor()
	LittleSpider.super:ctor();

	self.m_res_anims = "primary_enemy/litter_spider";

	self.m_attack = 38 -- 攻击力
	self.m_defense = 3; -- 防御力
	self.m_coin = 3; --金币数
	self.m_life = 35; -- 生命
end

return LittleSpider;