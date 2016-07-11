local Person = require("app.entity.Person");

local Enemy = class("Enemy",Person);

function Enemy:ctor()
	Enemy.super:ctor();
end

return Enemy;