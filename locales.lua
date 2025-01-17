Locales = {}

function _(str, ...)

	if Locales[Config.defaultlang] ~= nil then

		if Locales[Config.defaultlang][str] ~= nil then
			return string.format(Locales[Config.defaultlang][str], ...)
		else
			return 'Translation [' .. Config.defaultlang .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.defaultlang .. '] does not exist'
	end

end

function _U(str, ...)
	return tostring(_(str, ...):gsub("^%l", string.upper))
end