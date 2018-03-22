def fact (n)            #not tail recursive, space complexity O(n)
    if (n == 1) then
        return n
    end
    return n*fact(n-1)
end

def factR (n, part)     #tail recursive, space complexity O(1)
    if (n == 1) then
        return n*part
    end
    return factR(n-1, n*part)
end

fact(5)
factR(5, 1)