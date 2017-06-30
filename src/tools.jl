# general tools for MyMatchingMarkets.jl library
#
# author: @myuuuuun
# last update: 2017-06-30


"""
Custom counter
"""
type Counter
    counters::Vector{Int}
    max_counts::Vector{Int}
    
    function Counter(counters::Vector{Int}, max_counts::Vector{Int})
        new(counters, max_counts)
    end
end

function Counter(max_counts::Vector{Int})
    return Counter(zeros(Int, size(max_counts, 1)), max_counts)
end

@inbounds function get_next!(c::Counter, index::Int)
    c.counters[index] += 1
    if c.counters[index] <= c.max_counts[index]
        return c.counters[index]
    else
        return 0
    end
end


