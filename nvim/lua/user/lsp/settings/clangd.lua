local function fileExists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end

	return false
end

local cmd = "clangd"
local msvc_clangd = os.getenv("CDC_MSVC_CLANGD")

-- local msvc_clangd = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\Llvm\\x64\\bin\\clangd.exe"
if msvc_clangd ~= nil and fileExists(msvc_clangd) then
	cmd = msvc_clangd
end

return {
	cmd = { cmd, "--clang-tidy" },
}
