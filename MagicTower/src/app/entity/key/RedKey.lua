-- 红钥匙
local BaseProp = require("app.entity.BaseProp");

local RedKey = class("RedKey",BaseProp);

function RedKey:ctor()
	RedKey.super:ctor();
	self.m_propId = 3 ; -- 物品id
	self.m_res = "keys/red_key.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性
end


return RedKey;