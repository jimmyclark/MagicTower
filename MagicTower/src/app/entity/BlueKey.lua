local BaseProp = require("app.entity.BaseProp");

local BlueKey = class("BlueKey",BaseProp);

function BlueKey:ctor()
	BlueKey.super:ctor();
	self.m_propId = 2 ; -- 物品id
	self.m_res = "door/blue_door.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性
end


return BlueKey;