-- RedSlime
local Enemy = require("app.entity.monster.Enemy");

local RedSlime = class("RedSlime",Enemy);

function RedSlime:ctor()
	RedSlime.super:ctor();

	self.m_res_anims = "primary_enemy/red_slame";

	self.m_attack = 20 -- 攻击力
	self.m_defense = 2; -- 防御力
	self.m_coin = 2; --金币数
	self.m_life = 45; -- 生命

	self.m_name = "red slime";
	
	self.m_enemyId = 2;
end

return RedSlime;