-- This is a sample custom writer for pandoc.  It produces output
-- that is very similar to that of pandoc's HTML writer.
-- There is one new feature: code blocks marked with class 'dot'
-- are piped through graphviz and images are included in the HTML
-- output using 'data:' URLs.
--
-- Invoke with: pandoc -t sample.lua
--
-- Note:  you need not have lua installed on your system to use this
-- custom writer.  However, if you do have lua installed, you can
-- use it to test changes to the script.  'lua sample.lua' will
-- produce informative error messages if your code contains
-- syntax errors.

-- Character escaping
local function escape(s, in_attribute)
  return s:gsub("[<>&\"']",
    function(x)
      if x == '<' then
        return '&lt;'
      elseif x == '>' then
        return '&gt;'
      elseif x == '&' then
        return '&amp;'
      elseif x == '"' then
        return '&quot;'
      elseif x == "'" then
        return '&#39;'
      else
        return x
      end
    end)
end

-- Helper function to convert an attributes table into
-- a string that can be put into HTML tags.
local function attributes(attr)
  local attr_table = {}
  for x,y in pairs(attr) do
    if y and y ~= "" then
      table.insert(attr_table, ' ' .. x .. '="' .. escape(y,true) .. '"')
    end
  end
  return table.concat(attr_table)
end

-- Run cmd on a temporary file containing inp and return result.
local function pipe(cmd, inp)
  local tmp = os.tmpname()
  local tmph = io.open(tmp, "w")
  tmph:write(inp)
  tmph:close()
  local outh = io.popen(cmd .. " " .. tmp,"r")
  local result = outh:read("*all")
  outh:close()
  os.remove(tmp)
  return result
end

-- Table to store footnotes, so they can be included at the end.
local notes = {}

-- Blocksep is used to separate block elements.
function Blocksep()
  return ""
end

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- This gives you a fragment.  You could use the metadata table to
-- fill variables in a custom lua template.  Or, pass `--template=...`
-- to pandoc, and pandoc will add do the template processing as
-- usual.
function Doc(body, metadata, variables)
  local buffer = {}
  local function add(s)
    table.insert(buffer, s)
  end
  local bootstrap = [=[
#!/bin/bash

ORIGINAL_DIR=$(pwd)
SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
cd $SCRIPT_DIR
if [ -f bootstrap.sh ]
then
  . bootstrap.sh
fi
]=]
  local version = [=[
gif=version.gif
echo "Generating IM \"$gif\" image"
convert -list configure | egrep 'LIB_VERSION_NUMBER|RELEASE_DATE' |\
tr -d '\012' | sed 's/LIB[^ ]* /IM v/;s/REL.* / /;s/,/./;s/,/./;s/,/-/' |\
  convert -background transparent -pointsize 18 label:@-  $gif
chmod 644 $gif
]=]
  add(bootstrap)
  add(body)
  add(version)
  add("cd $ORIGINAL_DIR")
  return table.concat(buffer,'\n')
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  return escape(s)
end

function Space()
  return " "
end

function LineBreak()
  return "\n"
end

function Emph(s)
  return ""
end

function Strong(s)
  return ""
end

function Subscript(s)
  return ""
end

function Superscript(s)
  return ""
end

function SmallCaps(s)
  return ""
end

function Strikeout(s)
  return ""
end

function Link(s, src, tit)
  return ""
end

function Image(s, src, tit)
  return ""
end

function Code(s, attr)
  return "<code" .. attributes(attr) .. ">" .. escape(s) .. "</code>"
end

function InlineMath(s)
  return ""
end

function DisplayMath(s)
  return ""
end

function Note(s)
  return ""
end

function Span(s, attr)
  return ""
end

function Cite(s, cs)
  return ""
end

function Plain(s)
  return s
end

function Para(s)
  return ""
end

-- lev is an integer, the header level.
function Header(lev, s, attr)
  return ""
end

function BlockQuote(s)
  return ""
end

function HorizontalRule()
  return ""
end

function RawBlock(s, attr)
    return ""
end

function CodeBlock(s, attr)
  -- If code block has class 'skip', then do not include
  if attr.class and string.match(' ' .. attr.class .. ' ',' skip ') then
    return "#" .. attributes(attr) .. "\n"
  elseif attr['data-capture-out'] then
      local f = attr['data-capture-out']
      return "#" .. f .. "\n" .. s ..
             " 1>" .. f .. " && convert label:@" .. f .. " " .. f .. ".gif\n"
  elseif attr['data-capture-err'] then
    local f = attr['data-capture-err']
    return "#" .. f .. "\n" .. s ..
           " 2>" .. f .. " || : && convert label:@" .. f .. " " .. f .. ".gif\n"
  elseif attr['data-postamble'] then
      local f = attr['data-postamble']
      return "# " .. attributes(attr) .. "\n" .. s .. "\n" .. f .. "\n"
  elseif attr['data-preamble'] then
      local f = attr['data-preamble']
      return "# " .. attributes(attr) .. "\n" .. f .. "\n" .. s .. "\n"
  else
    return "#" .. attributes(attr) .. "\n" .. s ..
           "\n"
  end
end

function BulletList(items)
  return ""
end

function OrderedList(items)
  return ""
end

-- Revisit association list STackValue instance.
function DefinitionList(items)
  return ""
end

function CaptionedImage(s)
    return ""
end

function RawInline(s)
    return ""
end

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
  return ""
end

function Div(s, attr)
  return ""
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index =
  function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
    return function() return "" end
  end
setmetatable(_G, meta)

