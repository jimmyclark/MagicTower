-- Jump向上跳
local BaseProp = require("app.entity.prop.BaseProp");

local JumpProp = class("JumpProp",BaseProp);

function JumpProp:ctor()
	JumpProp.super:ctor();
	self.m_propId = 21 ; -- 物品id
	self.m_res = "prop/prop_jump.png"; -- 物品资源路径

	self.m_name = "jump";
end


return JumpProp;