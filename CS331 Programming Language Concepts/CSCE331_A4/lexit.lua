--Name : Hanting Yang
--CSCE331 Assignment 3
--2/19/2018
--lexit.lua
--Many variables and functions are from in-class example lexer.lua
--Tested with lexit_test.lua
--All tests passed


local lexit = {}

-- Public Constants

-- Numeric constants representing lexeme categories
lexit.KEY 		= 1
lexit.ID 		= 2
lexit.NUMLIT	= 3
lexit.STRLIT	= 4
lexit.OP		= 5
lexit.PUNCT		= 6
lexit.MAL 		= 7

-- catnames
-- Array of names of lexeme categories.
lexit.catnames = {
	"Keyword", 
	"Identifier",
	"NumericLiteral",
	"StringLiteral", 
	"Operator", 
	"Punctuation", 
	"Malformed",
}

-- Character-Type functions
--borrowed from lexer.lua

-- isLetter
-- Returns true if string c is a letter character, false otherwise.
local function isLetter(s)
	if s:len() ~= 1 then
		return false
	elseif s >= "A" and s <= "Z" then
		return true
	elseif s >= "a" and s <= "z" then 
		return true
	else 
		return false
	end
end

-- isDigit
-- Returns true if string c is a digit character, false otherwise.
local function isDigit(s)
	if s:len() ~= 1 then
		return false
	elseif s >= "0" and s <= "9" then
		return true
	else
		return false
	end
end

-- isWhitespace
-- Returns true if string c is a whitespace character, false otherwise.
local function isWhiteSpace(s)
	if s:len() ~= 1 then
		return false
	elseif s == " " or s == "\t" or s == "\n"
		or s == "\r" or s == "\f" or s == "\v" then
		return true
	else
		return false
	end
end

-- isIllegal
-- Returns true if string c is an illegal character, false otherwise.
local function isIllegal(s)
	if s:len() ~= 1 then 
		return false
	elseif isWhiteSpace(s) then
		return false
	elseif s >= " " and s <= "~" then 
		return false
	else 
		return true
	end
end

-- The Lexer

-- Intended for use in a for-in loop:
--     for lexstr, cat in lexer.lex(program) do
-- Here, lexstr is the string form of a lexeme, and cat is a number
-- representing a lexeme category.
function lexit.lex(program)
    -- *****local variables*****
--based on lexit.lua.
	local pos       -- Index of next character in program
	                -- INVARIANT: when getLexeme is called, pos is
	                --  EITHER the index of the first character of the
	                --  next lexeme OR program:len()+1
	local state     -- Current state for our state machine
	local ch        -- Current character
	local lexstr    -- The lexeme, so far
	local category  -- Category of lexeme, set when state set to DONE
	local handlers  -- Dispatch table; value created later
	local prevstr 	-- previous string
	local prevcat	-- previous category
    local prevchar  -- previous character
	local prevstate  -- previous state

    -- ***** States *****

    local DONE   = 0
    local START  = 1
    local LETTER = 2
    local DIGIT  = 3
    local PLUS   = 4
    local MINUS  = 5
    local OPERATORS = 6
    local EXPONENT = 7
    local QUOTES = 8

    -- borrowed from lexit.lua
    -- ***** Character-Related Utility Functions *****

    -- currChar
    -- Return the current character, at index pos in program. Return
    -- value is a single-character string, or the empty string if pos is
    -- past the end.
    local function currChar()
        return program:sub(pos, pos)
    end

    -- nextChar
    -- Return the next character, at index pos+1 in program. Return
    -- value is a single-character string, or the empty string if pos+1
    -- is past the end.
    local function nextChar()
        return program:sub(pos+1, pos+1)
    end

    local function nextNextChar()
        return program:sub(pos+2, pos+2)
    end

    -- drop1
    -- Move pos to the next character.
    local function drop1()
        pos = pos+1
    end

    -- add1
    -- Add the current character to the lexeme, moving pos to the next
    -- character.
    local function add1()
        lexstr = lexstr .. currChar()
        drop1()
    end

	--skipWhiteSpace
    -- Skip whitespace and comments, moving pos to the beginning of
    -- the next lexeme, or to program:len()+1.
    local function skipWhiteSpace()
    	while true do
    		while isWhiteSpace(currChar()) do
    			drop1() 
    		end
    		if currChar() ~= "#"  then -- Comment
    			break
    		end 
    		drop1()
    		while true do
    			if currChar() == "\n" or currChar() == "" then --End of comment
    				drop1()
    				break
    			end
    			drop1()
    		end
    	end
    end
	
	local function isDoubleOp(op)
        return
            op == "&&" or
            op == "||" or
            op == "!=" or
            op == "==" or
            op == "<=" or
            op == ">="
    end
	
	local function isOp(op)
        return
            op == "=" or
            op == "!" or
            op == ">" or
            op == "<" or
            op == "+" or
            op == "-" or
            op == "/" or
            op == "*" or
            op == "%" or
            op == "[" or
            op == "]" 
    end
	
	-- ***** State-Handler Functions *****

    -- A function with a name like handle_XYZ is the handler function
    -- for state XYZ
    local function handle_DONE()
        io.write("ERROR: 'DONE' state should not be handled\n")
        assert(0)
    end
	
	
	local function handle_START()
    	if isIllegal(ch) then
    		add1()
    		state = DONE
    		category = lexit.MAL
    	elseif isLetter(ch) or ch == "_" then
			prevchar = ch
	    	add1()
	    	state = LETTER
    	elseif isDigit(ch) then
			prevchar = ch
    		add1()
    		state = DIGIT
    	elseif ch == "+" then
            if nextChar() == "+" and isDigit(nextNextChar()) then
                add1()
                state = DONE
                category = lexit.OP
            else
        		add1()
        		state = PLUS
            end
    	elseif ch == "-" then
    		add1()
    		state = MINUS
    	elseif ch == "*" or ch == "/" or ch == "=" 
    		or ch == "&" or ch == "|" or ch == "!" or 
    		ch == "<" or ch == ">" or ch == "%" or ch == "[" 
    		or ch == "]" then
			prevchar = ch
    		add1()
    		state = OPERATORS
		elseif ch == '"' or ch == "'" then
            prevchar = ch
            add1()
            state = QUOTES
    	else
			prevchar = ch
    		add1()
    		state = DONE
    		category = lexit.PUNCT
    	end
    end

	-- determines if a lexeme is a keyword or identifier
    local function handle_LETTER()
    	if isLetter(ch) or isDigit(ch) or ch == "_" then 
    		  add1()
    	else
    		state = DONE
    		if lexstr == "cr" or lexstr == "def"
    			or lexstr == "else" or lexstr == "elseif" 
    			or lexstr == "end" or lexstr == "false" or lexstr == "if" 
    			or lexstr == "readnum" or lexstr == "return" 
    			or lexstr == "true" or lexstr == "while" 
    			or lexstr == "write" then
    				category = lexit.KEY
					prevstate = ""
    		else
				prevstate = lexit.ID
    			category = lexit.ID
    		end
    	end
    end

	--determines if a lexeme is a NumericLiteral, also check for exponents
    local function handle_DIGIT()
    	if isDigit(ch) then
            if prevchar == "e" and nextChar() == "e" or
            prevchar == "+" and nextChar() == "e" then
                add1()
                state = DONE
                category = lexit.NUMLIT
            else
    		  add1()
            end
    	elseif ch == "E" or ch == "e" then
            state = EXPONENT
   		elseif nextChar() == "." then
   			state = DONE
   			category = lexit.PUNCT
   		else
   			state = DONE
			prevstate = lexit.NUMLIT
   			category = lexit.NUMLIT
   		end
   	end
	
	-- handle plus 
	-- check the state of lexemes before and after the "+" character to determine 
	-- the state is operator or not
	-- also check the brackets
    local function handle_PLUS()
        if prevstate == lexit.ID or prevstate == lexit.NUMLIT
        or prevstr == "true" or prevstr == "false"
        or prevstr == ")" or prevstr == "]" then 
            if prevstr == "*" and not nextChar("+") then
                add1() 
                state = DIGIT
            elseif prevstr == "-" or prevstr == "+" or prevstr == "*" then
            	if isDigit(ch) then
            		add1()
            		state = DONE
            		category = lexit.NUMLIT
                else
	                state = DONE
	                category =lexit.OP
            	end
            elseif isDigit(ch) and prevchar == "("
            or ch == "+" and isDigit(nextChar()) then
                add1()
                state = DIGIT
            else
                state = DONE
                category = lexit.OP
            end
        elseif prevstr == "e" or prevstr == "E" then
            state = DONE
            category = lexit.OP
        elseif ch == "+" then
            if nextChar() == "=" or nextChar() == "+" 
            or nextChar() == "" then
                state = DONE
                category = lexit.OP
        	elseif isDigit(nextChar()) then
                prevchar = ch
        		add1()
        		state = DIGIT
        	else
	            add1()
	            state = DONE
	            category = lexit.OP
	        end
        elseif isDigit(ch) then            
            if prevchar == "]" or prevchar == ")" then
                state = DONE
                category = lexit.OP
            else
                add1()
                state = DIGIT
            end
        else
            state = DONE
            category = lexit.OP
        end
    end

	-- check the state of lexemes before and after the "-" character to determine 
	-- the state is operator or not
	-- also check the brackets
    local function handle_MINUS()
        if prevstate == lexit.ID or prevstate == lexit.NUMLIT
        or prevstr == "true" or prevstr == "false"
        and isDigit(ch) then
            if prevstr == "+" or prevstr == "-" or prevstr == "*" then
                if isDigit(nextChar()) then
                    add1()
                    state = DIGIT
                elseif prevstr == "-" or prevstr == "+" or prevstr == "*" then
            		if isDigit(ch) then
	            		add1()
	            		state = DONE
	            		category = lexit.NUMLIT
	                else
		                state = DONE
		                category =lexit.OP
	            	end
                else
                    add1()
                    state = DONE
                    category = lexit.NUMLIT
                end
            else
                state = DONE
                category = lexit.OP
            end
    	elseif prevstr == "e" or prevstr == "E" or
        ch == "-" or ch == "=" then
    		state = DONE
            category = lexit.OP
        elseif isDigit(ch) then
            if prevchar == "]" or prevchar == ")" then
                state = DONE
                category = lexit.OP
            else
    		    add1()
    			state = DIGIT
            end
        else
            state = DONE
            category = lexit.OP
        end
    end

	--handles double operators && || != == <= >= and operators = ! > < + - / * % [ ]
	--and determines they are legal or not
	local function handle_OPERATORS()  
        if isDoubleOp(lexstr .. ch) then
            add1()
            state = DONE
            category = lexit.OP
        elseif isOp(lexstr) then
            state = DONE
            category = lexit.OP
		else
			state = DONE
			category = lexit.PUNCT
        end
    end
	
	--determines a lexeme should be added to form a legal exponent or not
	local function  handle_EXPONENT()
        if nextChar() == "+" then
            if nextNextChar() == "e" or nextNextChar() == "" then
                state = DONE
                category = lexit.NUMLIT
            else
                add1()
                state = PLUS
            end
        elseif isDigit(nextChar()) then
            prevchar = ch
            add1()
            state = DIGIT
        else
            state = DONE
            category = lexit.NUMLIT
        end
    end
	
	--handles double quotes and single quotes
	--If it see a "or' character, adds characters behind it until it finds another " or'
	--Malformed for new line
    local function handle_QUOTES()
        if ch == "\n" then
            add1()
            state = DONE
            category = lexit.MAL
		elseif ch ~= prevchar and ch == "" then
            state = DONE
            category = lexit.MAL
        elseif ch ~= prevchar and ch ~= "" then
                add1()
        else
            add1()
            state = DONE
            category = lexit.STRLIT
        end
    end


    handlers = {
	    [DONE]=handle_DONE,
	    [START]=handle_START,
	    [LETTER]=handle_LETTER,
	    [DIGIT]=handle_DIGIT,
	    [PLUS]=handle_PLUS,
	    [MINUS]=handle_MINUS,
	    [OPERATORS]=handle_OPERATORS,
	    [EXPONENT]=handle_EXPONENT,
        [QUOTES]=handle_QUOTES
	}

    local function getLex(dummy1, dummy2)
    	if pos > program:len() then
    		return nil, nil
    	end
    	lexstr = ""
    	state = START
    	while state ~= DONE do
    		ch = currChar()
    		handlers[state]()
    	end
    	skipWhiteSpace()
    	prevstr	 = lexstr
    	return lexstr, category
    end
    pos = 1
    skipWhiteSpace()
    return getLex, nil, nil
end



return lexit
