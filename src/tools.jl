# general tools for Matching.jl library
#
# author: @myuuuuun
# last update: 2017-06-15


"""
Custom stack
"""
type FixedSizeStack{T}
    stack::Vector{T}
    size::Int
    
    function FixedSizeStack{T}(stack::Vector{T}, size::Integer) where T
        new{T}(stack, size)
    end
end

function FixedSizeStack{T}(size::Integer) where T
    return FixedSizeStack{T}(Vector{T}(size), 0)
end

@inbounds function push!(f::FixedSizeStack, x)
    f.size += 1
    f.stack[f.size] = x
end

@inbounds function pop!(f::FixedSizeStack)
    f.size -= 1
    return f.stack[f.size+1]
end

function top(f::FixedSizeStack)
    return f.stack[f.size]
end

function length(f::FixedSizeStack)
    return f.size
end

function isempty(f::FixedSizeStack)
    return f.size == 0
end


"""
Custom counter
"""
type Counter
    counters::Vector{Int64}
    max_counts::Vector{Int64}
    
    function Counter(counters::Vector{Int64}, max_counts::Vector{Int64})
        new(counters, max_counts)
    end
end

function Counter(max_counts::Vector{Int64})
    return Counter(zeros(Int64, size(max_counts, 1)), max_counts)
end

@inbounds function get_next!(c::Counter, index::Int64)
    c.counters[index] += 1
    if c.counters[index] <= c.max_counts[index]
        return c.counters[index]
    else
        return 0
    end
end


