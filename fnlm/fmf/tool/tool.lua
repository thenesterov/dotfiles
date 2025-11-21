local function _1_()
  return __fnl_global___21_2fusr_2fbin_2ffennel
end
local function split(str, sep)
  local tbl_21_ = {}
  local i_22_ = 0
  for sym in string.gmatch(str, ("[^" .. sep .. "]+")) do
    local val_23_ = sym
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  return tbl_21_
end
local function last(seq)
  return seq[#seq]
end
local function slice(tbl, first, last0, step)
  local sliced = {}
  for i = (first or 1), (last0 or #tbl), (step or 1) do
    sliced[(#sliced + 1)] = tbl[i]
  end
  return sliced
end
local function print_table(t, indent)
  indent = (indent or "")
  if (type(t) ~= "table") then
    print((indent .. tostring(t)))
    return 
  else
  end
  print((indent .. "{"))
  for k, v in pairs(t) do
    local key_str = tostring(k)
    if (type(k) == "string") then
      key_str = ("\"" .. key_str .. "\"")
    else
    end
    io.write((indent .. "  [" .. key_str .. "] = "))
    if (type(v) == "table") then
      print_table(v, (indent .. "  "))
    else
      print(tostring(v))
    end
  end
  return print((indent .. "}"))
end
local function list_remove_value(list, value)
  for i, v in ipairs(list) do
    if (v == value) then
      table.remove(list, i)
      break
    else
    end
  end
  return nil
end
local function list_contains(list, value)
  for _, item in ipairs(list) do
    if (item == value) then
      return true
    else
    end
  end
  return false
end
local function is_list_empty(list)
  return (#list == 0)
end
local function fqn__3epath(name, include_source_file, env)
  local name_parts = split(name, "-")
  local env0 = (env or "")
  local _8_
  if include_source_file then
    local _9_
    if (env0 ~= "") then
      _9_ = ("." .. env0)
    else
      _9_ = ""
    end
    _8_ = (last(name_parts) .. _9_ .. ".fnl")
  else
    _8_ = ""
  end
  return (table.concat(name_parts, "/") .. "/" .. _8_)
end
local function file_write(path, content, parents)
  do
    local parents0 = (parents or false)
    local path_parts = split(path, "/")
    local path_dir = table.concat(slice(path_parts, 1, (#path_parts - 1)), "/")
    if parents0 then
      os.execute(("mkdir -p " .. path_dir))
    else
    end
  end
  local file = io.open(path, "w")
  file:write(content)
  return file:close()
end
local function file_read(path)
  local file = io.open(path, "rb")
  return file:read("*all")
end
local function save_module(module_name, processed)
  local module_path = (".fnlm/" .. fqn__3epath(module_name, true))
  return file_write(module_path, processed, true)
end
local function source_processor(source)
  local states
  local function _13_(char)
    if (char == "$") then
      return {next = "dollar", keep = {}}
    elseif (char == "\"") then
      return {next = "text", keep = {char}}
    elseif (char == ";") then
      return {next = "note", keep = {char}}
    else
      return {next = "normal", keep = {char}}
    end
  end
  local function _15_(char)
    if (char == "(") then
      return {next = "name", keep = {char}, ["start-collect"] = true}
    else
      return {next = "normal", keep = {"$", char}}
    end
  end
  local function _17_(char)
    if (char == " ") then
      return {next = "normal", keep = {char}, ["end-collect"] = true}
    elseif (char == ".") then
      return {next = "normal", keep = {char}, ["end-collect"] = true}
    elseif (char == ")") then
      return {next = "normal", keep = {char}, ["end-collect"] = true}
    else
      return {next = "name", keep = {char}}
    end
  end
  local function _19_(char)
    if (char == "\n") then
      return {next = "normal", keep = {char}}
    else
      return {next = "note", keep = {char}}
    end
  end
  local function _21_(char)
    if (char == "\"") then
      return {next = "normal", keep = {char}}
    else
      return {next = "text", keep = {char}}
    end
  end
  states = {normal = _13_, dollar = _15_, name = _17_, note = _19_, text = _21_}
  local buffer = {}
  local collected = {}
  local collected_buffer = {}
  local collecting = false
  local function keep(char)
    table.insert(buffer, char)
    if collecting then
      return table.insert(collected_buffer, char)
    else
      return nil
    end
  end
  local state = "normal"
  for char in source:gmatch(utf8.charpattern) do
    local action = states[state](char)
    if action["end-collect"] then
      collecting = false
      table.insert(collected, table.concat(collected_buffer))
      collected_buffer = {}
    else
    end
    for _, to_keep in pairs(action.keep) do
      keep(to_keep)
    end
    if action["start-collect"] then
      collecting = true
    else
    end
    state = action.next
  end
  local requires = {}
  for _, module in pairs(collected) do
    local module_path = string.gsub(module, "-", ".")
    local filename = last(split(module, "-"))
    local require_path = (module_path .. "." .. filename)
    local generated_require = string.format("(local %s (require \"%s\"))", module, require_path)
    table.insert(requires, generated_require)
  end
  return collected, (table.concat(requires, "\n") .. "\n\n" .. table.concat(buffer, ""))
end
local function bundle_module(module_name, visited, visiting)
  local visited0 = (visited or {})
  local visiting0 = (visiting or {})
  local content = file_read(fqn__3epath(module_name, true))
  local collected, processed = source_processor(content)
  for _, module in pairs(collected) do
    if list_contains(visiting0, module) then
      error(string.format("circular import: %s <=> %s", module, module_name))
    else
    end
    table.insert(visiting0, module)
    bundle_module(module, visited0, visiting0)
    list_remove_value(visiting0, module)
  end
  table.insert(visited0, module_name)
  return save_module(module_name, processed)
end
local command = arg[1]
if (command == "bundle") then
  local module_name = arg[2]
  local module_path = fqn__3epath(module_name, true)
  local command0 = "(cd .fnlm && fennel --compile --require-as-include %s) && rm -rf .fnlm"
  bundle_module(module_name)
  return os.execute(string.format(command0, module_path))
elseif (command == "run") then
  local module_name = arg[2]
  local module_path = fqn__3epath(module_name, true)
  local command0 = "(cd .fnlm && fennel %s) && rm -rf .fnlm"
  bundle_module(module_name)
  return os.execute(string.format(command0, module_path))
else
  return nil
end
