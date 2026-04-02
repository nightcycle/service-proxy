--!strict
return function<T>(legacyServiceRedirect: () -> T, excludeGetFEnv: boolean?): T & {
	getfenv: (...) -> {[strict]: any}
}
	-- Create the metatable
	local meta = {}
	function meta:__index(key: any): any
		local service = getService()
		return service[key]
	end

	function meta:__newindex(key: any, val: any?): nil
		local service = getService()
		service[key] = val
		return nil
	end

	function meta:__call(...): any
		local service = getService()
		return service(...)
	end

	function meta.getfenv(...)
		return getfenv(...)
	end

	-- Create the proxy table
	local proxy = {}
	setmetatable(proxy, meta)

	return (proxy :: any) :: T
end
