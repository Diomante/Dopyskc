#Prac4
# using Plots
include("practice_2.jl")
using LinearAlgebra

# №1
function macloren_e_x(x :: Float64, n :: Int, eps :: Float64 = 1e-7)
    S :: Float64 = 1.
    a :: Float64 = abs(x)
    k :: Int = 2
    while k-2<n && S+a!=S && abs(a)>eps
        S+=a
        a = a*abs(x)/k
        k+=1
    end
    x<0 && return 1/S
    return S
end

# №2
function exp_(x::Float64)#e^x
    S :: Float64 = 1
    negative :: Bool = x<0
    if abs(x)>1
        S = fast_pow(exp_(1.), Int(trunc(abs(x))))
        x -= trunc(x)
    end
    S1 :: Float64 = 1
    a :: Float64 = abs(x)
    k :: Int = 2
    while S1+a!=S1
        S1+=a
        a = a*abs(x)/k
        k+=1
    end
    
    negative && return 1/(S*S1)
    return S*S1
end

# №3 
function bessel(x,α)
    α *= (-1) ^ (α < 0)
    s = 0.0; a = ((x/2)^α)/factorial(α); k = 0;
    while (s+a)!=s
        s+=a
        a = (a*(-1)*(fast_pow((x/2),2)))/((k+1)*(k+α+1))
        k+=1
    end
    return s
end

# №4
function reverse_gauss1(A::AbstractMatrix{T}, b::AbstractVector{T}) where T
    x = similar(b)
    N = size(A, 1)
    for k in 0:N-1
    x[N-k] = (b[N-k] - sum(A[N-k,N-k+1:end] .* x[N-k+1:end])) / A[N-k,N-k]
    end
    return x
   end

function reverse_gauss2(A::AbstractMatrix{T}, b::AbstractVector{T}) where T
    x = similar(b)
    N = size(A,1)
    for k in 0:N-1
        @views x[N-k] = (b[N-k] - sum(A[N-k,N-k+1:end] .* x[N-k+1:end])) / A[N-k,N-k]
    end
    return x
end

function swap!(A,B)
    for i in eachindex(A)
        A[i],B[i] = B[i], A[i]
    end
end

# №5 
function transform_to_steps!(A::AbstractMatrix; epsilon = 1e-7,degenerate_exeption = true)
    @inbounds for k in 1:size(A,1)
        absval, dk = findmax(abs,@view(A[k:end,k]))#max element -> index
        (degenerate_exeption && absval <= epsilon) && throw("вырожденная матрица")
        dk > 1 && swap!(@view(A[k,k:end]),@view(A[k+dk-1,k:end]))
        for i in k+1:size(A,1)
            t = A[i,k]/A[k,k]
            @. @views A[i,k:end] = A[i,k:end] - t * A[k,k:end]#без точек будет копия при всех операциях
            #@. - расставляет точки во всех местах
        end
    end
    return A
end