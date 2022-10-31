local Lambda = {}
do
	function Lambda:__call(...)
		return self:fn(...)
	end

	function Lambda:__tostring()
		return self.signature
	end

	local mt = {}
	mt.__index = mt
	setmetatable(Lambda, mt)

	function mt:__call(fn, signature)
		local obj = {}
		obj.fn = fn
		obj.signature = signature
		setmetatable(obj, self)
		return obj
	end
end

local f = Lambda(function(_self_0, x) return x * x end, "function(x) return x * x end")

local g = Lambda(function(_self_0, a, b) return a + b end, "function(a, b) return a + b end")

local h = Lambda(function(_self_0) return "foo\nbar" end, "function() return \"foo\\nbar\" end")

local long = Lambda(function(_self_0) return "Multiple lines are valid, too!" end, "function() return \"Multiple lines are valid, too!\" end")

local function do_smth(fn)
	return fn(7)
end

print(f(5))
print(do_smth(Lambda(function(_self_0, x) return x * 2 end, "function(x) return x * 2 end")))
print(f)
