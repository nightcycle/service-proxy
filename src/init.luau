--!strict
return function<T>(
	getService: () -> T,
	excludegetfenv: boolean?
): T & {
	_getfenv: (...any) -> { [string]: any },
}
	-- Create the metatable
	local meta = {}
	function meta:__index(key: any): any
		local service: any = getService()
		return service[key]
	end

	function meta:__newindex(key: any, val: any?): nil
		local service: any = getService()
		service[key] = val
		return nil
	end

	function meta:__call(...): any
		local service: any = getService()
		return service(...)
	end

	function meta._getfenv(...)
		if excludegetfenv then
			return {}
		else
			return getfenv(...)
		end
	end

	-- Create the proxy table
	local proxy = {}
	setmetatable(proxy, meta)

	return proxy :: any
end
