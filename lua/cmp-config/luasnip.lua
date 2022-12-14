local status, ls = pcall(require, "luasnip")
if not status then
	vim.notify("没有找到 luasnip")
	return
end

local types = require("luasnip.util.types")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

ls.config.set_config({
	-- This tells LuaSnip to remember to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection
	history = false,

	-- This one is cool cause if you have dynamic snippets, it updates as you type!
	updateevents = "TextChanged,TextChangedI",

	-- Autosnippets:
	enable_autosnippets = true,

	--	ext_opts = {
	--		[types.choiceNode] = {
	--			active = {
	--				virt_text = { { "choiceNode", "Comment" } },
	--			},
	--		},
	--	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
})

-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

ls.add_snippets("all", {
	s("ternary", {
		-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
		i(1, "cond"),
		t(" ? "),
		i(2, "then"),
		t(" : "),
		i(3, "else"),
	}),
})

local mysplit = function(input_str, sep)
	if sep == nil then
		sep = "%s"
	end

	local tab = {}
	for str in string.gmatch(input_str, "([^" .. sep .. "]+)") do
		table.insert(tab, str)
	end

	for j = 1, #tab, 1 do
		if tab[j] ~= nil then
			return tab[j]
		end
	end

	return nil
end

local tag_position = function()
	local line = vim.api.nvim_get_current_line()
	local first_word = mysplit(line, " ")
	local last_char = string.sub(line, -1)

	if first_word == nil then
		first_word = "value"
	end

	first_word = first_word:match("^%s*(.-)%s*$")

	if last_char == "`" then
		return true, first_word
	else
		return false, first_word
	end
end

ls.add_snippets("go", {
	s("json", {
		d(1, function()
			local in_backquote, field_name = tag_position()
			if in_backquote then
				return sn(nil, { i(1, "json"), t(':"'), i(2, field_name), t('"') })
			end

			return sn(nil, { t("`"), i(1, "json"), t(':"'), i(2, field_name), t('"`') })
		end),
	}),
})
