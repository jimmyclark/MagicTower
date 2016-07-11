local LittleSpider = require("app.entity.LittleSpider");

local LittleSpider = class("LittleSpider",LittleSpider);

function LittleSpider:ctor()
	LittleSpider.super:ctor();

	self.m_res = "enemy/littlespider.png";

	self.m_attack = 20 -- 攻击力
	self.m_defense = 5; -- 防御力
	self.m_coin = 3; --金币数
	self.m_life = 100; -- 生命

	
	
end

return LittleSpider;