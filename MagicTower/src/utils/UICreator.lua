require("utils.UIConfig")
--[[
	ClassName   :     UICreator.lua
	description :  	create ui more fast
	author 		:   	ClarkWu
]]
UICreator = {};

--[[
	@function 	:  createText
	@param 		:  text   -- 文本内容
				   size   -- 文本大小
				   align  -- 对齐方式
				   x,y 	  -- x,y 坐标
	description :  创建普通文本
	return 		:  UILabel对象
]]
function UICreator.createText(text,size,align,x,y,r,g,b,fontName)
	local text = cc.ui.UILabel.new({
            UILabelType = UIConfig.LABEL.TTF_FONT,
            text = text, 
            size = size,
            font = fontName,
            color = cc.c3b(r,g,b)
            })
        :align(align,x, y);
    return text;
end

function UICreator.createFontText(text,size,align,x,y,r,g,b,fontName)
	local text = cc.ui.UILabel.new({
        UILabelType = UIConfig.LABEL.BM_FONT,
        text = text,
        font = fontName,
        size = size,
        color = cc.c3b(r,g,b),
    }):align(align,x,y);
    return text;
end

--[[
	@function 	: createImg
	@param 		: imageName 	-- 图片名称
				  isScale9OrNot -- 是否是9宫图
				  x,y 			-- x,y坐标
				  width			-- 宽度
				  height 		-- 高度
	description : 创建图片
	return 		: 图片精灵
]]
function UICreator.createImg(imageName,isScale9OrNot,x,y,width,height)
	if isScale9OrNot then 
		local image = display.newScale9Sprite(imageName);
		image:setContentSize(width,height);
		image:pos(x,y);
		return image;
	end
end

--[[
	@function 	: createUIImage
	@param 		: imageName 	-- 图片名称
				  x,y 			-- x,y坐标
				  width			-- 宽度
				  height 		-- 高度
				  align 		-- 对齐方式
				  isScale9OrNot -- 是否可以缩放
	description : 创建图片
	return 		: 图片
]]
function UICreator.createUIImage(imageName,x,y,width,height,align,isScale9OrNot)
	local image = cc.ui.UIImage.new(imageName,{scale9 = isScale9OrNot or false})
        :align(align,x,y);
    if width or height then
    	image:setLayoutSize(width,height);
    end
    return image;
end

--[[
	@function 	: createBtnText
	@param 		: imageName 	-- 图片名称
				  isScale9OrNot -- 是否是9宫图
				  x,y 			-- x,y坐标
				  align 		-- 对齐方式
				  width			-- 宽度
				  height 		-- 高度
				  label 		-- 文字
	description : 创建按钮文本
	return 		: 按钮
]]
function UICreator.createBtnText(imageName,isScale9OrNot,x,y,align,width,height,label)

	local button;
	if imageName then 
		button = cc.ui.UIPushButton.new(imageName, {scale9 = isScale9OrNot or false})
	else
		button = cc.ui.UIPushButton.new();
	end
	if width and height then
    	button:setButtonSize(width, height);
	end
	if label then
       button:setButtonLabel(UIConfig.BUTTON.STATE_NORMAL, label)
    end
    button:align(align,x,y);
    return button;
end

--[[
	@function 	: createLine
	@param 		: x1,y1 	-- 起始点坐标
				  isScale9OrNot -- 是否是9宫图
				  x,y 			-- x,y坐标
				  align 		-- 对齐方式
				  width			-- 宽度
				  height 		-- 高度
				  label 		-- 文字
	description : 创建线条
	return  	: 线条
]]
function UICreator.createLine(x1,y1,x2,y2,r,g,b,a,borderWidth)
	local line = display.newLine(
		{{x1,y1},{x2,y2}},
		{borderColor=cc.c4f(r,g,b,a)},
		{borderWidth=borderWidth});
	return line;
end

--[[
	@function 	: createPageView
	@param		: viewRect 	    页面控件的显示区域 cc.rect(起始(x,y,宽度，高度)) 	
				  columnNum  	每一页的列数
				  rowNum 		每一页的行数
				  paddingRect 	{
				  				-   left 左边间隙
							    -   right 右边间隙
							    -   top 上边间隙
							    -   bottom 下边间隙
							    }
				  columnSpace   列之间的间隙
				  rowSpace 		行之间的间隙
				  isCircle		页面是否循环,默认为false
	description : 创建页面
	return 		: 页面
]]
function UICreator.createPageView(viewRect,columnNum,rowNum,paddingRect,columnSpace,rowSpace,isCircle)
	local pageView = cc.ui.UIPageView.new {
        viewRect = viewRect,
        column = columnNum, row = rowNum,
        padding = paddingRect,
        columnSpace = columnSpace, rowSpace = rowSpace,bCirc = isCircle};
    return pageView;
end

--[[
	@function 	: createListView
	@param		: direction 	列表控件的滚动方向，默认为垂直方向
				  itemAlign  	listViewItem中content的对齐方式，默认为垂直居中
				  viewRect 		列表控件的显示区域
				  scrollbarImgH 水平方向的滚动条
				  scrollbarImgV 垂直方向的滚动条
				  bg  			背景图
				  bgScale9   	背景图是否可缩放
				  r,g,b,a 		背景颜色
	description : 创建列表ListView
	return 		: 列表ListView
]]
function UICreator.createListView(direction,itemAlign,viewRect,scrollbarImgH,scrollbarImgV,bg,bgScale9,r,g,b,a,isAsysc)
	local listView = cc.ui.UIListView.new {
		direction = direction,
		alignment = itemAlign,
		viewRect = viewRect,
		scrollbarImgH = scrollbarImgH,
		scrollbarImgV = scrollbarImgV,
		bg = bg,
		bgScale9 = bgScale9 or false,
		bgColor = cc.c4b(r,g,b,a),
		async = isAsysc or false
	};
    return listView;
end

--[[
	@function 	: createScrollView
	@param		: direction 	滚动控件的滚动方向，默认为垂直与水平方向都可滚动
				  viewRect 		列表控件的显示区域
				  scrollbarImgH 水平方向的滚动条
				  scrollbarImgV 垂直方向的滚动条
				  bg 			背景图
				  bgScale9 		是否可缩放
				  r,g,b,a 		背景颜色
	description : 创建列表ScrollView
	return 		: 列表ScrollView
]]
function UICreator.createScrollView(direction,viewRect,scrollbarImgH,scrollbarImgV,bg,bgScale9,r,g,b,a)
	local scrollView = cc.ui.UIScrollView.new{
		direction = direction,
		viewRect = viewRect,
		scrollbarImgH = scrollbarImgH,
		scrollbarImgV = scrollbarImgV,
		bgColor = cc.c4b(r,g,b,a),
		bg = bg,
		bgScale9 = bgScale9 or false
	};
	return scrollView;
end

--[[
	@function 	: createUICheckBox
	@param		: offImages 	off模式的图片
				  onImages 		on模式的图片
				  align 		对齐方式
				  x,y 		 	x,y坐标
				  label 		文字 
	description : 创建选择框CheckBox
	return 		: 选择框CheckBox
]]
function UICreator.createUICheckBox(offImages,onImages,align,x,y,label)
	local params = {};
	if type(offImages) == "table" then 
		params.off = offImages.off;
		params.off_pressed = offImages.off_pressed;
		params.off_disabled = offImages.off_disabled
	else
		params.off = offImages;
	end

	if type(onImages) == "table" then 
		params.on = onImages.on;
		params.on_pressed = onImages.on_pressed;
		params.on_disabled = onImages.on_disabled
	else
		params.on = onImages;
	end

	local checkBoxBtn = cc.ui.UICheckBoxButton.new(params)
						:align(align,x,y)
						:setButtonLabel(label);
    return checkBoxBtn;
end

--[[
	@function 	: createCheckBoxGroup
	@param		: direction     方向
				  align 		对齐方式
				  x,y 		 	x,y坐标
	description : 创建选择框CheckBox组
	return 		: 选择框CheckBox组
]]
function UICreator.createCheckBoxGroup(direction,align,x,y)
	local group = cc.ui.UICheckBoxButtonGroup.new(direction)
					:align(align,x, y);
	return group;
end

--[[
	@function 	: createUISlider
	@param		: direction     方向
				  barImages 	滑块图片
				  buttonImages  按钮图片
				  isScale9OrNot 是否缩放
				  value 		当前值
				  align 		对齐方式
				  x,y 		 	x,y坐标
				  max,min		最大值，最小值
				  touchInButton 是否只在触摸在滑动块上时才有效，默认为真
	description : 创建选择框CheckBox组
	return 		: UISlider滑块
]]
function UICreator.createUISlider(direction,barImages,buttonImages,isScale9OrNot,barWidth,barHeight,value,align,x,y,max,min,touchInButton)
	local images = {
		bar = barImages.bar,
		bar_pressed = barImages.bar_pressed,
		bar_disabled = barImages.bar_disabled,
		button_pressed = buttonImages.button_pressed,
		button = buttonImages.button,
		button_disabled = buttonImages.button_disabled,
	};
	local uiSlider = cc.ui.UISlider.new(direction, images, {scale9 = isScale9OrNot,max = max,min = min,touchInButton = touchInButton})
        :setSliderSize(barWidth, barHeight)
        :setSliderValue(value)
        :align(align, x, y);
    return uiSlider;
end

--[[
	@function 	: createEditBox
	@param		: inputType     	1或nil 表示创建editbox输入控件
				  					2 表示创建textfield输入控件
				  imageName 		输入框的图像，可以是图像名或者是 Sprite9Scale 显示对象。
				  imagePressedName  输入状态时输入框显示的图像（可选）
				  imageDisabledName 禁止状态时输入框显示的图像（可选）
				  x,y 		 		x,y坐标（可选)
				  width 			输入框宽度
				  height 			输入框高度
				  listener 			回调函数
				  placeHolder		占位符(可选)
				  text 				输入文字(可选)
				  font 				字体
				  fontSize 			字体大小
				  maxLength 		最大长度
				  passwordEnable	开启密码模式
				  passwordChar 		密码代替字符
	description : 创建输入框EditBox
	return 		: UIInput 输入框
]]
function UICreator.createEditBox(inputType,imageName,imagePressedName,imageDisabledName,x,y,width,height,listener,
						placeHolder,text,font,fontSize,maxLength,passwordEnable,passwordChar)
	local input = cc.ui.UIInput.new({
		image = imageName,
		imagePressed = imagePressedName,
		imageDisabled = imageDisabledName,
        size = cc.size(width, height),
        x = x,
        y = y,
        listener = listener,
        maxLength = maxLength,
        UIInputType = inputType,
        text = text,
        font = font,
        fontSize = fontSize,
        passwordEnable = passwordEnable or false,
        passwordChar = passwordChar or "",
	});
	-- input:setReturnType(inputType);
	input:setPlaceHolder(placeHolder);
	-- input:setMaxLength(5);
	-- input:setFontSize(fontSize);
	return input;
end

--[[
	@function 	: createBoundingBox
	@param		: parent 在谁的上面画
				  target 子控件是谁，在谁的外面画
				  color cc.c4f 颜色
	description : 创建某个控件的外部边框
	@return 	: 边框
]]
function UICreator.createBoundingBox(parent, target, color)
    local cbb = target:getCascadeBoundingBox();
    local left, bottom, width, height = cbb.origin.x, cbb.origin.y, cbb.size.width, cbb.size.height;
    local points = {
        {left, bottom},
        {left + width, bottom},
        {left + width, bottom + height},
        {left, bottom + height},
        {left, bottom},
    };
    local box = display.newPolygon(points, {borderColor = color});
    parent:addChild(box, 1000);
    return box;
end