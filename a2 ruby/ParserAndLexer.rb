#Jonathan Luetze / J. Anthony Timberlake
#Assignment 2 - Ruby
#CS 401
#Spring 2018

def getTokenKind(token)                         #returns what kind an operator is
    if(token == "EOF") then
        return token
    elsif(whatOperator(token)!= "noOperator") then
        return "operator"
    elsif(whatKeyword(token)!= "noKeyword") then
        return "keyword"
    elsif(token.match(/^[[:alpha:]]+$/)) then
        return "identifier"
    elsif(Integer(token)rescue false) then
        return "integer"
    else
        return token
    end
end

def getTokenText(tokenArray, text,i)                         #returns if token is in array or not
    while i < tokenArray.length
        if(tokenArray[i] == text) then
            return i
        end
        i = i + 1
    end
    return -1
end

def printArray(thisArray,message)
    puts message
    print thisArray
    puts " "
end

# NOTE: regex needs parenthesis around it to keep it in the array

def whatOperator(tempString)        #determines if string/token contains an operator
    String operator = ""
    if(tempString.include? "(") then        #.include needed for Lexer to determine if another split is needed
        operator = "("
    elsif(tempString.include? ")") then
        operator = ")"
    elsif(tempString.include? "+") then 
        operator = "+"
    elsif(tempString.include? "-") then
        operator = "-"
    elsif(tempString.include? "*") then
        operator = "*"
    elsif(tempString.include? "/") then
        operator = "/"
    elsif(tempString.include? ":=") then
        operator = ":="
    elsif(tempString.include? "<=") then
        operator = "<="
    elsif(tempString.include? "<") then
        operator = "<"
    elsif(tempString.include? "=") then
        operator = "="
    else
        operator = "noOperator"
    end
    return operator
end

def whatKeyword(tempString)        #determines if string/token contains an operator
    String keyword = ""
    if(tempString == "if" || tempString == "then" || tempString == "end" || tempString == "else" || tempString == "for" || tempString == "from" || tempString == "to" || tempString == "by") then
        keyword = tempString
    else
        keyword = "noKeyword"
    end
    return keyword
end

def splitOperator(tempString, tokenArray)    #splits strings containing operators if necessary
    i = 0
    while i < tempString.length
        if(tempString[i] == ":") then
            operator = whatOperator(tempString[i..i+1])
        else
            operator = whatOperator(tempString[i])          # getting next char, testing for operator
        end
        if(operator != "noOperator") then               
            if(i > 0) then                             # if there was something before the operator, send it to array first
                tokenArray << tempString[0..tempString.index(operator)-1]
            end
            tokenArray << operator                      #send operator to array

            tempString = tempString[tempString.index(operator)+operator.length..tempString.length]  #remove added elements from tempString
            i = -1
        end
        i = i + 1
    end
    if(removeOnlySpace(tempString)!= "") then
        tokenArray << tempString
    end
    return tokenArray
end

def removeOnlySpace(tempString) #removes strings that contain only spaces
    i = 0
    while i < tempString.length
        if(tempString[i] != " ") then
            return tempString
        end
    end
    return ""
end

def removeNewLine (tempString)
    i = 0
    while i < tempString.length
        if(tempString[i..i+1] == "\n") then
            if(i == 0) then                                 # if \n is at the beginning of the String
                return tempString[2..tempString.length]     # return everything but \n
            else
                return tempString[0..tempString.length-2]   # \n must be at the end, return everything else
            end
        end
        i += 1
    end
    return tempString
end

def nextToken(tokenArray)
    File.open("simpleTest.simpl").each do |line|        #move through every line
        i = 0
        String tempString = ""                          #initializing temporary string for next token
        while i <= line.length                           #move through every char in line
            
            if(line[i] == " " || line[i] == ";"||i == line.length|| line[i..i+1] == "//") then   #split token upon space and ;
                isop = whatOperator(tempString)         #if operator, return what operator
                if(isop != "noOperator")
                    tokenArray = splitOperator(tempString, tokenArray)     #check if operator is in the same token as value and variable, split if necessary
                else
                    tempString = removeOnlySpace(tempString)    #if token is contained of only spaces, remove token
                    if(tempString != "" && tempString != "\n") then
                        tempString = removeNewLine(tempString)
                        tokenArray << tempString                 #No operator, so add value or variable
                    end
                end 
                if(line[i] == ";") then                 #if semicolon, add it since we just saw it
                    tokenArray << ";"
                end
                tempString = ""                         #reset tempString
                if(line[i..i+1] == "//") then
                    break
                end
            else
                tempString += line[i]
            end
            i = i + 1                                   #move to next char
        end
    end
    tokenArray << "EOF"
    return tokenArray
end

def exitMessage(valid)
    if(valid == "valid")
        puts "\nThis is a valid program!"
    else
        puts "\nThis program is invalid!"
    end
    exit
end

def program(arr)
    if (stmts(arr)) then        #if there is a statement
        exitMessage("valid")
    else
        exitMessage("")
    end
end

def stmts (arr)
    # TEST FOR ; OR EOF OR EMPTY ARRAY
    if((arr[-1] != ";" && arr[-1] != "EOF" && arr.length != 0) || arr[-1] == "EOF" && arr[-2] != ";") then
       exitMessage("invalid")
    end

    tempArray = Array.new
    if (arr[0] == "if" || arr[0] == "for") then         # IF Statement or FOR Statement
        endIndex = ifForEndBalance(arr,0)               # Find matching end

        if (endIndex != -1 && arr[endIndex+1] == ";") then  # If valid END statement (including following ;)
            tempArray = arr.shift(endIndex+2)
            if (!stmt(tempArray).nil?) then                 # Send IF Statement to STMT
                if (arr[0] == "EOF") then
                    return true
                else
                    return stmts(arr)                       # Send rest of array back up
                end
            end
        else
            exitMessage("")
        end        
    else
        print ""
        while (arr.length > 0)             #if array element is not EOF
            tempArray << arr.shift          #get next element in array and remove it
            if (tempArray[-1] == ";") then  #if last element is ; then send it off
                tempArray.pop               #consume the ; before sending statement to stmt method
                if (stmt(tempArray)) then
                    if (arr[0] == "EOF") then
                        return true
                    else
                        return stmts(arr)
                    end
                else
                    return false
                end           
            end
        end
        return true
    end
end

def stmt(arr)
    if(arr.length == 1 && arr[0] == "end") then return true end

    if (!/identifier:=/.match(getTokenKind(arr[0].to_s) + arr[1].to_s).nil?) then
        arr.shift(2)
        if (!addop(arr).nil?)
            return true
        else
            exitMessage("no")
        end
    elsif (!/if/.match(whatKeyword(arr[0].to_s)).nil?) then # See an IF
        arr.shift
        tempArray = Array.new
        while (!(arr[0] == "then" || arr.length == 0))      # Take following THEN
            tempArray << arr.shift
        end
        if (!lexpr(tempArray).nil?) then                    # LEXPR of between IF and THEN
            if (arr.length == 0) then
                return false
            else
                matchingEnd = ifForEndBalance(arr,0)                       #find correct END
                if(matchingEnd == -1) then                          #if we consumed the beginning already, find the next end
                    matchingEnd = getTokenText(arr,"end", 0)
                end
                arr.shift
                tempArray = Array.new 

                i = 0
                while (!(arr.length == 0))   #find end and else
                    if(arr[0] == "else") then
                        if(!(arr[1] == "else" || arr[1] == "end")) then  # check to see if we have already seen an else
                            arr.shift
                        else
                            exitMessage("invalid")
                        end
                    end
                    i += 1
                   tempArray << arr.shift
                end

                if(arr[0] == "end" && arr[1] == ";") then
                     tempArray << arr.shift                                  #shift "end" and ;
                     tempArray << arr.shift
                end

                if (stmts(tempArray)) then
                    if (arr.length == 0) then
                        return false
                    elsif (arr.length == 1 && arr[0] == "end") then
                        return true
                    elsif (arr.length == 1 && arr[0] != "end") then
                        return false
                    else
                        arr.shift
                        tempArray = Array.new
                        while (!(arr[0] == "end" || arr.length == 0))
                            tempArray << arr.shift
                        end
                        if (arr.length == 0) then
                            return false
                        elsif (stmts(tempArray) && arr[0] == "end") then
                            return true
                        else
                            return false
                        end
                    end
                else
                    exitMessage("invalid")
                end
            end
        else
            return false
        end
    elsif (!/foridentifierfrom/.match(arr[0].to_s + getTokenKind(arr[1].to_s) + arr[2].to_s).nil?) then # See a FOR
        arr.shift(3)
        tempArray = Array.new
        while (!(arr[0] == "to" || arr.length == 0))      # Take following TO
            tempArray << arr.shift                          #tempArray will be from FROM to TO
        end
        if (!addop(tempArray).nil?) then                    # ADDOP of between FROM and TO
            if (arr.length == 0) then                       #incomplete FOR statement, this program sucks!
                exitMessage("")
            else
                #CONTINUE HERE
                arr.shift                                   #shift the TO out
                tempArray = Array.new

               # printArray(arr, "mid STMT 1 FOR SECTION")
                while (!(arr[0] == "do" || arr[0] == "by" || arr.length == 0))   #find end and else
                    tempArray << arr.shift
                end
                if (!addop(tempArray).nil?) then
                    if (arr.length == 0) then
                        exitMessage("")
                    elsif (arr[0] == "do") then
                        arr.shift
                        if (arr.length == 0) then
                            return false
                        elsif (stmts(arr)) then
                            return true
                        else
                            return false
                        end
                    elsif (arr[0] == "by") then
                        arr.shift
                        tempArray = Array.new
                        while (!(arr[0] == "do" || arr.length == 0))
                            tempArray << arr.shift
                        end                        
                        if (arr.length == 0 || tempArray[-1] == ";") then       #invalid for statment or invalid addop part
                            exitMessage("")
                        elsif (!addop(tempArray).nil? && arr[0] == "do") then   #valid addop between by and do
                            arr.shift
                            if (arr.length == 0) then
                                return false
                            elsif (stmts(arr)) then
                                return true
                            else
                                return false
                            end
                        end
                    else
                        exitMessage("")
                    end
                else
                    exitMessage("") #if from TO to DO or TO to BY is not valid addop   
                end
            end
        else
            exitMessage("")     #if from FROM to TO is not valid addop
        end
    else
        exitMessage("")     #if your whole program is just quatch!
    end
end

def isPrimaryOp(str)
    if (whatOperator(str) == "+" || whatOperator(str) == "-" || whatOperator(str) == "*" || whatOperator(str) == "/" )
        return true
    end
end

def ifForEndBalance(arr,i)
     iffors = 0
     flag = 0
     while (i < arr.length)    #avoid the last element
         if(arr[i] == "if" || arr[i] == "for") then
             iffors += 1 
             flag = 1
         elsif(arr[i] == "end")
             iffors -= 1
         end
         if(iffors == 0 && flag == 1)    #if the original ( ever closes with a ) before the end, then it's not fully wrapped
             if(i > 0) then
                 return i
             end
         end
         i = i + 1
     end
     return -1
 end

def parenthesisBalance(arr,i)
     openParenthesis = 0
     flag = 0
     while (i < arr.length)    #avoid the last element
         if(arr[i] == "(") then
             openParenthesis += 1 
             flag = 1
         elsif(arr[i] == ")")
             openParenthesis -= 1
         end
         if(openParenthesis == 0 && flag == 1)    #if the original ( ever closes with a ) before the end, then it's not fully wrapped
             if(i > 0) then
                 return i
             end
         end
         i = i + 1
     end
     return -1
 end

def addop(arr)
    tempArray = Array.new
    parenCheck = Array.new
    closeIndex = 0

    #printArray(arr, "ADDOP ENTRY")
    #checks if just an identifier/integer
    if (arr.length == 1) then
        return mulop(arr)
    
    #accounts for everything else
    else
        #check for parentheses around term before +/- and shreds
        if (arr[-1] == '*' || arr[-1] == '/' || arr[-1] == '+' || arr[-1] == '-') then
            return nil
        end  
        if (arr[0] == "(") then                         #if we see (), send that to mulop
            closeIndex = parenthesisBalance(arr,0)
            i = 0
            while (i <= closeIndex)
                tempArray <<  arr.shift
                i = i + 1
            end
        else
        #checking for invalid usage of operators
            #first check to see if this section invalidly ends in +/-/*//
            #second determines if there are any consecutive operators, also invalid
            for i in 1..arr.length-1 do
                if (isPrimaryOp(arr[i-1]) && isPrimaryOp(arr[i])) then
                    return nil
                end
            end
            #read in first portion before +/- after all parentheses have been removed
            while (!(arr[0] == "+" || arr[0] == "-" || arr[0] == "*" || arr[0] == "/" || arr.length == 0))
                tempArray << arr.shift
            end
        end
        
        #Recursive Calls#
        if(arr.length > 0 && (arr[0] == "+" || arr[0] == "-")) then               #if there's a + or - after the ()
            return mulop(tempArray) + addop(arr[1..arr.length])
        else
            return mulop(tempArray.concat arr)
        end
    end
end

def mulop(arr)
  #  printArray(arr,"MULOP ENTRY")
    tempArray = Array.new
    parenCheck = Array.new
    #checks if just an identifier/integer
    if (arr.length == 1) then
        return factor(arr)
    #accounts for everything else
    else
        #check for parentheses around term before +/-/*///
        if (arr[0] == "(") then
            closeIndex = parenthesisBalance(arr,0)
            i = 0
            while (i <= closeIndex)
                tempArray <<  arr.shift
                i = i + 1
            end
        else
        #checking for invalid usage of operators
            #first check to see if this section invalidly ends in +/-/*//
            if (arr[-1] == '*' || arr[-1] == '/' || arr[-1] == '+' || arr[-1] == '-') then
                return nil
            end
            #second determines if there are any consecutive operators, also invalid
            consArray = arr.each_cons(2).to_a
            for i in 0..consArray.length-1 do
                #puts consArray[i][0].to_s + ", " + consArray[i][1].to_s
                if (consArray[i][0] == '*' && consArray[i][1] == '*' || consArray[i][0] == '*' && consArray[i][1] == '/' || consArray[i][0] == '/' && consArray[i][1] == '*' || consArray[i][0] == '/' && consArray[i][1] == '/') then
                    return nil
                end
            end
            #read in first portion before *// after all parentheses have been removed
            while (!(arr[0] == "*" || arr[0] == "/" || arr.length == 0))
                tempArray << arr.shift
            end
        end

        #Recursive Calls#
        if(arr.length > 0 && (arr[0] == "*" || arr[0] == "/")) then               #if there's a * or / after the ()
            return factor(tempArray) + mulop(arr[1..arr.length])
        elsif(arr.length > 0)       #greater than 0 but no operator behind it = invalid
            exitMessage("")
        else
            return factor(tempArray.concat arr)
        end        
    end
end

def factor(arr)
    if (arr.length == 1 && (getTokenKind(arr[0].to_s) == "integer" || getTokenKind(arr[0].to_s) == "identifier")) then
        return getTokenKind(arr[0].to_s)
    elsif (arr[0] == '(' && arr[-1] == ')') then
        arr.shift
        arr.pop
        return addop(arr)
    else
        exitMessage("")
    end
end

def lexpr(arr)
    tempArray = Array.new
    while (!(arr[0] == "and" || arr.length == 0))
        tempArray << arr.shift
    end
    if (!lterm(tempArray).nil?)
        if (arr.length == 0)
            return "done here"
        elsif (arr.length == 1 && arr[0] == "and")
            return nil
        else
            arr.shift
            tempArray = Array.new
            while (!(arr[0] == "and" || arr.length == 0))
                tempArray << arr.shift
            end
            if (arr.length == 1 && arr[0] == "and")
                return nil
            else
                return lexpr(tempArray)
            end
        end
    else
        return nil
    end
end

def lterm(arr)
    if (arr.length > 1 && arr[0] == "not")
        arr.shift
        return lfactor(arr)
    else
        return lfactor(arr)
    end
end

def lfactor(arr)
    if (arr.length == 1 && (arr[0] == 'true' || arr[0] == 'false')) then
        return arr[0]
    elsif (arr.length == 1 && !(arr[0] == 'true' || arr[0] == 'false')) then
        return nil
    else
        return relop(arr)
    end
end

def relop(arr)
    tempArray = Array.new
    parenCheck = Array.new
    while (!(arr[0] == "<=" || arr[0] == "<" || arr[0] == "=" || arr.length == 0))
        tempArray << arr.shift
    end
    if(!addop(tempArray).nil?)
        if (arr.length == 0) then
            return nil
        else
            arr.shift
            tempArray = Array.new
            parenCheck = Array.new
            #read in all elements between operators or the end of the segment
            while (!(arr[0] == "<=" || arr[0] == "<" || arr[0] == "=" || arr.length == 0))
                tempArray << arr.shift
            end
            if(!addop(tempArray).nil?)
                return addop(tempArray)
            end
        end
    else
        return nil
    end 
end

tokenArray = Array.new
tokenArray = nextToken(tokenArray)
program(tokenArray)