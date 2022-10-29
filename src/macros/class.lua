local require  = require
local tostring = tostring
local math = math
local setmetatable = setmetatable
local type = type
local pairs = pairs

-- TODO: Indentation detection
-- TODO: Make the annonymous syntax the "default" (like how Lua
-- handles functions) and remove the neeles code duplication.

local function tts(t)
	local outstr = "{"

	for k, v in pairs(t) do
		outstr = ("%s %s = %s,"):format(outstr, k, v)
	end

	return outstr.." }"
end

local function strip(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

local block_openers = {
	["do"] = 1,
	["then"] = 2,
	["function"] = 3,
	["class"] = 4,
}

local macro = require("macro")

macro.define("class", function(get, put)
	local is_anon = false
	local params

	local function parse_params(v)
		local params_read = get:upto(")")
		params = v..strip(tostring(params_read))
	end

	local name
	do
		local t, v

		while not t or t == "space" do
			t, v = get()
		end

		if t == "iden" then
			name = v

			while t ~= "(" do
				t, v = get()
			end

			local nxt_t, nxt_v = get()

			if not nxt_t == ")" then
				parse_params(nxt_v)
			end
		elseif t == "(" then
			is_anon = true

			local nxt_t, nxt_v = get()

			if not nxt_t == ")" then
				parse_params("")
			end

			get()
		end
	end

	local body = "\n"
	do
		local level = 1
		while level > 0 do
			local t, v = get()

			if block_openers[v] then
				level = level + 1
			elseif v == "end" then
				level = level - 1
			end

			if level > 0 then
				body = body .. v
			end
		end
	end

	local namestr = strip(tostring(name))
	local ret
	if not is_anon then
		ret = ([[<@NAME@>
do
	local _class_0
	local _base_0 = {<@BODY@>}
	_base_0.__index = _base_0
	_class_0 = {
		__init = function(self) end,
		__base = _base_0,
		__name = "<@NAME@>",
	}
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
	<@NAME@> = _class_0
end]])
			:gsub("<@NAME@>", namestr)
			:gsub("<@BODY@>", body)
	else
		ret = ([[(function()
	local _class_0
	local _base_0 = {<@BODY@>}
	_base_0.__index = _base_0
	_class_0 = setmetatable({
		__init = function(self) end,
		__base = _base_0,
		__name = "<annonymous>",
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({}, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end,
		__tostring = function(cls)
			return "<class "..cls.__name..">"
		end,
	})
	_base_0.__class = _class_0
	return _class_0
end)()]])
		:gsub("<@BODY@>", body)
	end
	return ret
end)
