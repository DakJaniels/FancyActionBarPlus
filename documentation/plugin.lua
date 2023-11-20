---@class diff
---@field start  integer # The number of bytes at the beginning of the replacement
---@field finish integer # The number of bytes at the end of the replacement
---@field text   string  # What to replace
---@param  uri  string # The uri of file
---@param  text string # The content of file
---@return nil|diff[]
function OnSetText(uri, text)
    local diffs = {}
    local count = Count

    -- local variable
    for localPos, colonPos, typeName, finish in text:gmatch("()local%s+[%w_]+()%s*%:%s*([%w_]+)()") do
        table.insert(diffs, {
            start  = localPos,
            finish = localPos - 1,
            text   = ("---@type %s\n"):format(typeName),
        })
        table.insert(diffs, {
            start  = colonPos,
            finish = finish - 1,
            text   = "",
        })
    end

    -- function as parameter
    for funcPos, argsPos, args, argsFinish in text:gmatch("()function%s+[%w_]*%s*%(()([%w_%s:,]+:[%w_%s:,]+)()%)") do
        local appendText = ""
        local paramsInBrackets = ""
        for word, typeName in string.gmatch(args, "([%w_]+)%s*%:?%s*([%w_]*)") do
            if typeName == "" then
                typeName = "any"
            end
            appendText = appendText .. ("---@param %s %s\n"):format(word, typeName)
            paramsInBrackets = paramsInBrackets .. word .. ","
        end
        table.insert(diffs, {
            start  = funcPos,
            finish = funcPos - 1,
            text   = "\n" .. appendText,
        })
        table.insert(diffs, {
            start  = argsPos,
            finish = argsFinish - 1,
            text   = string.sub(paramsInBrackets, 1, -2),
        })
    end

    -- hstructure -> class
    for startStruct, structName, fields, endPos in text:gmatch("()hstructure%s+([%w_]+)%s+([%w_%s;:]+)[^%w_]end[^%w_]()") do
        if count(fields, "%f[%w_]end%f[^%w_]") == 0 then
            local appendText = ""
            for word, typeName in string.gmatch(fields, "([%w_]+)%s*%:%s*([%w_]+)") do
                appendText = appendText .. ("---@field %s %s\n"):format(word, typeName)
            end
            table.insert(diffs, {
                start  = startStruct,
                finish = endPos - 1,
                text   = ("---@class %s\n%s"):format(structName, appendText),
            })
        end
    end

    -- hmake -> type
    for start, typeName, finishStruct in text:gmatch("()hmake[ \t\v\r\f]+([%w_]+)()") do
        table.insert(diffs, {
            start  = start,
            finish = start - 1,
            text   = ("---@type %s\n"):format(typeName),
        })
        table.insert(diffs, {
            start  = start,
            finish = finishStruct - 1,
            text   = "",
        })
    end

    return diffs
end

--- @param base string: The string to search for occurrences of the pattern.
--- @param pattern string: The pattern to search for in the string.
--- @return number: The number of occurrences of the pattern in the string.
function Count(base, pattern)
    pattern = pattern or "%f[%w_]" -- Add default pattern if not provided
    return select(2, string.gsub(base, pattern, ""))
end
