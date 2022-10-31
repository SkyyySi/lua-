local require  = require
local tostring = tostring
local math = math
local setmetatable = setmetatable
local getmetatable = getmetatable
local type = type
local pairs = pairs
local print = print
local io = io

local macro = require("macro")

local block_openers = {
	["do"]       = 1,
	["then"]     = 2,
	["function"] = 3,
	["class"]    = 4,
}

macro.define("async", function(get, put)
	-- skip spaces and the `function` keyword
	get()
	get()

	local func_name
	do
		local t, v
		repeat
			t, v = get()
		until t ~= "space"
		if t ~= "(" then
			func_name = tostring(v)
		end
	end

	local body = ""
	do
		local level = 1

		while level > 0 do
			local t, v = get()
			local str_v = tostring(v)

			if block_openers[str_v] then
				level = level + 1
			elseif t == "end" then
				level = level - 1
			end

			if level > 0 then
				body = body .. v
			end
		end

		local ret = "_async_0(function"..body.."end)"
		if func_name then
			ret = func_name.." = "..ret
		end
	end
end)

macro.define("await", function(get, put)
	local async_expr

	while true do
		local t, v = get()

		if t == "iden" then
			async_expr = tostring(v)
			break
		end
	end

	return "_await_0("..async_expr..")"
end)
