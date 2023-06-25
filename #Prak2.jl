#Prak2
# №1
function fast_pow(a::T, n::Int) where T<:Any
    k=n
    p=a
    t=1
    #ИНВАРИАНТ: p^k*t=a^n
    while k>0
        if iseven(Integer(k))
            k /=2
            p *= p # - это преобразование следует из инварианта
        else
            k -= 1
            t *= p
        end
    end
    return t
end

# №2
function fast_fib(a::Integer)
    matr = [0:1;; 1; 1]
    return ([0;;1]*fast_pow(matr, a))[1, 1]
end

# №4
function bisection(f::Function, a, b, epsilon)
    if f(a)*f(b) < 0 && a < b
        f_a = f(a)
        #ИНВАРИАНТ: f_a*f(b) < 0
        while b-a > epsilon
            t = (a+b)/2
            f_t = f(t)
            if f_t == 0
                return t
            elseif f_a*f_t < 0
                b=t
            else
                a, f_a = t, f_t
            end
        end  
        return (a+b)/2
    else
        @warn("На концах отрезка требуются разные символы")
    end
end

# №5
cos_(x) = cos(x) - x
bisection(x -> cos(x) - x , 0, 1, 1e-8)

# №6
function newton(f, df, x0, eps=1e-6, num_max=100)
    x = x0
    for i in 1:num_max
        fx = f(x)
        dfx = df(x)
        if abs(fx) < eps
            return x
        else
            x = x - fx / dfx
        end
    end

    error("Превышено максимальное количество итераций.")
end

# №7
println(newton(x -> cos(x) - x, x -> -sin(x) - 1, 0.5, 1e-3, 100))