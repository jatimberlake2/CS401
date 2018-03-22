def addop(arr)
    #print arr
    tempArray = Array.new
    parenCheck = Array.new
    #checks if just an identifier/integer
    if (arr.length == 1) then
        return mulop(arr)
    #accounts for everything else
    else
        #check for parentheses around term before +/- and shreds
        if (arr[0] == "(") then
            for i in 0..arr.length-1 do
                parenCheck << arr[i]
                if (parenCheck[i] == ")") then
                    return mulop(parenCheck)
                end
            end
        end
    #checking for invalid usage of operators
        #first check to see if this section invalidly ends in +/-
        if (arr[-1] == '+' || arr[-1] == '-') then
            return nil
        end
        #second determines if there are any consecutive operators, also invalid
        consArray = arr.each_cons(2).to_a
        for i in 0..consArray.length-1 do
            #puts consArray[i][0].to_s + ", " + consArray[i][1].to_s
            if (consArray[i][0] == '+' && consArray[i][1] == '+' || consArray[i][0] == '+' && consArray[i][1] == '-' || consArray[i][0] == '-' && consArray[i][1] == '+' || consArray[i][0] == '-' && consArray[i][1] == '-') then
                #print "noooo"
                return nil
            end
        end
        #read in first portion before +/- after all parentheses have been removed
        while (!(arr[0] == "+" || arr[0] == "-" || arr.length == 0))
            tempArray << arr.shift
        end
        #print tempArray
        #print arr
        #if the first portion is a valid mulop, continue reading
        if (!mulop(tempArray).nil?) then
            #check if there's no operator involved at all first
            if (arr.length == 0) then
                #puts "Hey!"
                #print tempArray
                return mulop(tempArray)
            #move beyond the operator and into the addop recursion
            else
                arr.shift
                tempArray = Array.new
                parenCheck = Array.new
                #exact same checking for parentheses for early handling
                if (arr[0] == "(") then
                    for i in 0..arr.length-1 do
                        parenCheck << arr[i]
                        if (parenCheck[i] == ")") then
                            return addop(parenCheck)
                        end
                    end
                end
                #read in all elements between operators or the end of the segment
                while (!(arr[0] == "+" || arr[0] == "-" || arr.length == 0))
                    tempArray << arr.shift
                end
                return addop(tempArray)
            end
        end
    end
end