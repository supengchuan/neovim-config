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
	first_word = first_word:gsub("^%u", string.lower)

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
	s("swago", {
		t({
			"// @Summary      summary",
			"// @Description  description",
			"// @Tags         tag",
			"// @Accept       json",
			"// @Produce      json",
			'// @Param        val1   query  int  true  "used for calc"',
			'// @Param        val2   query  int  true  "used for calc"',
			'// @Success      200    {integer}   string   "test"',
			'// @Failure      400    {string}    string   "ok"',
			'// @Failure      404    {string}    string   "ok"',
			'// @Failure      500    {string}    string   "ok"',
			"// @Router       path [post]",
		}),
	}),
})

ls.add_snippets("sql", {
	s("table", {
		t("CREATE TABLE IF NOT EXISTS `"),
		i(1, "table_name"),
		t({ "` (", "\tid BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,", "\t" }),
		i(2, "other field"),
		t({ "", "\tPRIMARY KEY (id)", ") ENGINE=InnoDB AUTO_INCREMENT=1 default charset=utf8;" }),
	}),
})
