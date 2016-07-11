local BaseDoor = require("app.entity.BaseDoor");

local YelloDoor = class("YelloDoor",BaseDoor);

function YelloDoor:ctor()
	YelloDoor.super:ctor();
	self.m_isPinTu = true;
	self.m_resFiles = {"door/door.png"};

	self.m_resFilesH = {};

	self.m_resFilesH[1] = {x = 0,y = 0};
	self.m_resFilesH[2] = {x = 0,y = 33};
	self.m_resFilesH[3] = {x = 0,y = 65};
	self.m_resFilesH[4] = {x = 0,y = 97};

	self.m_defaultShow = {x = 0,y = 0};

end

return YelloDoor;