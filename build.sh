#!/usr/bin/env bash
function print_line() {
	local char="${1:--}"
	local cols="${2:-${COLUMNS:-$(tput cols)}}"
	printf '%*s\n' "$(( cols / ${#char} ))" "" | tr " " "${char}"
}

function print_block() {
	local text="${1}"
	local cols="${2:-${COLUMNS:-$(tput cols)}}"

	print_line "-"
	printf '| %s%*s |\n' "${text}" "$(( cols - ${#text} - 4 ))" ""
	print_line "-"
}

function build() {
	cd src/ || exit 1
	print_block "script_processed.lua"
	eval "$(luarocks path --lua-version=5.1)"
	if [[ -n "${1}" ]]; then
		luajit ../../LuaMacro/luam -l macros.class script.lua++ -o "${1}"
	elif command -v bat &> /dev/null; then
		luajit ../../LuaMacro/luam -d -l macros.class script.lua++ | bat -pp --theme=Dracula --tabs=4 --language=lua
	else
		luajit ../../LuaMacro/luam -d -l macros.class script.lua++
	fi
	print_line "-"
}

build "$@"
