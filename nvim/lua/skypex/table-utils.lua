--- map over a table's values
--- @generic T
--- @generic U
--- @param tbl table<T>
--- @param fn fun(value: T): U
--- @return table<U>
function table.map(tbl, fn)
	local result = {}

	for i, v in ipairs(tbl) do
		result[i] = fn(v)
	end

	return result
end

--- filter a table's value
--- @generic T
--- @param tbl table<T>
--- @param predicate fun(value: T): boolean
--- @return table<T>
function table.filter(tbl, predicate)
	local result = {}
	local count = 0

	for i, v in ipairs(tbl) do
		if predicate(v) then
			count = count + 1
			result[count] = v
		end
	end

	return result
end

--- aggregate a table to a single value
--- @generic T
--- @param tbl table<T>
--- @param initial T
--- @param fn fun(acc: T, new: T): T
--- @return table<T>
function table.fold(tbl, initial, fn)
	local acc = initial

	for _, v in ipairs(tbl) do
		acc = fn(acc, v)
	end

	return acc
end

--- add indexes to a tables values
--- @generic T
--- @param tbl table<T>
--- @return table<table<number, T>>
function table.enumerate(tbl)
	local result = {}

	for i, v in ipairs(tbl) do
		result[i] = { i, v }
	end

	return result
end

--- find a value matching a predicate in a table
--- @generic T
--- @param tbl table<T>
--- @param predicate fun(value: T): boolean
--- @return T|nil
function table.find(tbl, predicate)
	for _, v in ipairs(tbl) do
		if predicate(v) then
			return v
		end
	end

	return nil
end
