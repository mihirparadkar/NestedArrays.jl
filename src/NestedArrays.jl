module NestedArrays

import Base
import Base: undef, UndefInitializer, @propagate_inbounds
import ElasticArrays
const ea = ElasticArrays

struct NestedArray{T} <: DenseVector{Vector{T}}
    data::ea.ElasticArray{T, 2, 1}
end

function NestedArray{T}(::UndefInitializer, dim::Integer) where {T}
    data = ea.ElasticArray{T}(undef, dim, 0)
    NestedArray{T}(data)
end

function NestedArray{T}(::UndefInitializer, innerdim::Integer, outerdim::Integer) where {T}
    data = ea.ElasticArray{T}(undef, innerdim, outerdim)
    NestedArray{T}(data)
end

function NestedArray(A::AbstractMatrix{T}) where {T}
    NestedArray{T}(ea.ElasticArray(A))
end

Base.size(A::NestedArray) = size(A.data)[end:end]

Base.@propagate_inbounds Base.getindex(A::NestedArray, i::Int) = A.data[:,i]

#TODO: Implement getindex for UnitRange and Colon to return a NestedArray
Base.@propagate_inbounds function Base.getindex(A::NestedArray{T}, I::OrdinalRange) where {T}
    NestedArray{T}(A.data[:,I])
end

Base.@propagate_inbounds function Base.getindex(A::NestedArray{T}, I::Colon) where {T}
    NestedArray{T}(A.data[:,I])
end

Base.@propagate_inbounds function Base.setindex!(
    A::NestedArray{T}, 
    x::Vector{T}, 
    i::Integer,
) where {T}
    A.data[:,i] = x
end

Base.@propagate_inbounds function Base.setindex!(
    A::NestedArray{T},
    x::Matrix{T},
    I
) where {T}
    A[I] = NestedArray(x)
end

#push! and append!
function Base.push!(A::NestedArray{T}, v::Vector{T}) where {T}
    append!(A.data, v)
    A
end

end # module
