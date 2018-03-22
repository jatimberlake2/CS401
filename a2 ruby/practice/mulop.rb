def mulop(arr)
    #print arr
    tempArray = Array.new
    parenCheck = Array.new
    #checks if just an identifier/integer
    if (arr.length == 1) then
        return factor(arr)
    #accounts for everything else
    else
        #check for parentheses around term before +/-/*// and shreds
        if (arr[0] == "(") then
            for i in 0..arr.length-1 do
                parenCheck << arr[i]
                if (parenCheck[i] == ")") then
                    return factor(parenCheck)
                end
            end
        end
        #read in first portion before *// after all parentheses have been removed
        while (!(arr[0] == "*" || arr[0] == "/" || arr.length == 0))
            tempArray << arr.shift
        end
        print tempArray
        print arr
        #if the first portion is a valid factor, continue reading
        if (!factor(tempArray).nil?) then
            #check if there's no operator involved at all first
            if (arr.length == 0) then
                puts "Hey!"
                #print tempArray
                return factor(tempArray)
            #move beyond the operator and into the mulop recursion
            else
                arr.shift
                tempArray = Array.new
                parenCheck = Array.new
                #exact same checking for parentheses for early handling
                if (arr[0] == "(") then
                    for i in 0..arr.length-1 do
                        parenCheck << arr[i]
                        if (parenCheck[i] == ")") then
                            return factor(parenCheck)
                        end
                    end
                end
                #read in all elements between operators or the end of the segment
                while (!(arr[0] == "*" || arr[0] == "/" || arr.length == 0))
                    tempArray << arr.shift
                end
                return mulop(tempArray)
            end
        end
    end
end