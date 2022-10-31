local FooBar = (function(class_name)
	local _class_0
	local _base_0 = {

	name = "Tom",
	age = 34,

	say_hello = function(self)
		print("Hello, my name is "..self.name.." and I am "..tostring(self.age).." years old.")
	end,
}
	_base_0.__index = _base_0
	_class_0 = {
		__init = function(self) end,
		__base = _base_0,
		__name = "FooBar",
	}
	_class_0.__addr = tostring(_class_0):gsub("table:%s*", "")
	_base_0.__tostring = _base_0.__tostring or function(self)
		return "<".._class_0.__name.." object at "..self.__meta.mem_addr..">"
	end
	setmetatable(_class_0, {
		__index = _base_0,
		__call = function(cls, ...)
			local obj = {}
			local addr = tostring(obj):gsub("table:%s*", "")
			obj.__meta = {
				mem_addr = addr,
			}
			local _self_0 = setmetatable(obj, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end,
		__tostring = function(cls)
			return "<class '"..cls.__name.."'>"
		end,
	})
	_base_0.__class = _class_0
	return _class_0
end)()

local BizBaz = (function(class_name)
	local _class_0
	local _base_0 = {

	buzzer = "it buzzes",
}
	_base_0.__index = _base_0
	_class_0 = {
		__init = function(self) end,
		__base = _base_0,
		__name = "<annonymous>",
	}
	_class_0.__addr = tostring(_class_0):gsub("table:%s*", "")
	_base_0.__tostring = _base_0.__tostring or function(self)
		return "<".._class_0.__name.." object at "..self.__meta.mem_addr..">"
	end
	setmetatable(_class_0, {
		__index = _base_0,
		__call = function(cls, ...)
			local obj = {}
			local addr = tostring(obj):gsub("table:%s*", "")
			obj.__meta = {
				mem_addr = addr,
			}
			local _self_0 = setmetatable(obj, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end,
		__tostring = function(cls)
			return "<class '"..cls.__name.."'>"
		end,
	})
	_base_0.__class = _class_0
	return _class_0
end)()

do
	local a = FooBar()
	local b = FooBar()
	print(tostring(FooBar))
	print(tostring(a))
	print(tostring(b))

	a:say_hello()
end
