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

local function printf(fmt, ...)
	io.stdout:write(fmt:format(...))
end

local function strip(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

local function string_escape(s)
	return s:gsub("\a", [[\a]])
		:gsub("\b", [[\b]])
		:gsub("\f", [[\f]])
		:gsub("\n", [[\n]])
		:gsub("\r", [[\r]])
		:gsub("\t", [[\t]])
		:gsub("\v", [[\v]])
		:gsub("\\", [[\\]])
		:gsub("\"", [[\"]])
		:gsub("\'", [[\']])
end

local function lua_escape(s)
	return s:gsub("%%", "%%%%")
		:gsub("^%^", "%%^")
		:gsub("%$$", "%%$")
		:gsub("%(", "%%(")
		:gsub("%)", "%%)")
		:gsub("%.", "%%.")
		:gsub("%[", "%%[")
		:gsub("%]", "%%]")
		:gsub("%*", "%%*")
		:gsub("%+", "%%+")
		:gsub("%-", "%%-")
		:gsub("%?", "%%?")
end

macro.define_tokens { "=>" }

macro.define("=>", function(get, put)
	local index = get:placeholder(put)

	local args
	do
		local t, v
		local i = -3

		repeat
			t, v = get:peek(i, true)
			i = i - 1
		until t and t ~= "space"

		args = tostring(v)
	end

	if args == ")" then
		args = ""
		local t, v
		local i = -4

		local has_args = false

		while true do
			t, v = get:peek(i, true)
			i = i - 1
			local v_str = tostring(v)
			if v_str == "(" then
				if args:match("[^%s%)]") then
					has_args = true
				end
				args = "(_self_0, "..args
				break
			end
			args = v_str..args
		end

		if not has_args then
			args = "(_self_0)"
		end

		for j = i+3, -1 do
			get:patch(index + j, "")
		end
	else
		args = "(_self_0, "..args..")"

		get:patch(index + -1, "")
		get:patch(index + -2, "")
	end

	--[==[
	do
		local t, v
		t, v = get()
		printf("'%s' -> '%s'\n", t, v)
		--printf("'%s' -> '%s'\n", get:upto("\n"))
	end
	--]==]

	--[= =[
	local body = ""
	do
		local t, v
		local level = 0

		while true do
			t, v = get()
			if t == "{" then
				body = tostring(get:upto("}"))
				break
			end
		end
	end
	--]==]

	local func_signature = "function"..args.." return "..strip(body).." end"
	local ret = "Lambda("..func_signature..', "'..string_escape("function"..args:gsub("^%(_self_0", "(", 1):gsub("^%(, ", "(", 1).." return "..strip(body).." end")..'")'

	return ret
end)
