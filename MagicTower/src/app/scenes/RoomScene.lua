local RoomScene = class("RoomScene",function()
	return display.newScene("RoomScene");
end)

function RoomScene:ctor()
	self:createLeftLayer();

	self:createMainLayer();
end

kGameWall 	   = 0;  -- 普通墙壁
kGameUpStair   = 1 ; -- 向上楼梯
kGameDownStair = -1; -- 向下楼梯
kGameDoor  	   = 2;  -- 房间门
kGameKey 	   = 3;  -- 房间钥匙
kGameDrink 	   = 4;  -- 药水
kGamePropAttack= 5;  -- 攻击
kGamePropDefen = 6;  -- 防御

function RoomScene:createLeftLayer()
	local layer = display.newColorLayer(cc.c4b(0x8B,0x8B,0xBB, 255));
	layer:addTo(self);

end

function RoomScene:createMainLayer()
	local map = cc.TMXTiledMap:create("map/first_floor.tmx");
	self:addChild(map);

end

function RoomScene:onEnter()

end

function RoomScene:dtor()

end

return RoomScene;