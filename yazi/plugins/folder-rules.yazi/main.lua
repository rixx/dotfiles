local function setup()
	local home = os.getenv("HOME")
	local tmp_dir = home .. "/tmp"
	local downloads_dir = tmp_dir .. "/downloads"

	ps.sub("cd", function()
		local cwd = tostring(cx.active.current.cwd)
		if cwd == tmp_dir or cwd == downloads_dir or cwd:sub(1, #downloads_dir + 1) == downloads_dir .. "/" then
			ya.emit("sort", { "mtime", reverse = true, dir_first = false })
		else
			ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
		end
	end)
end

return { setup = setup }
