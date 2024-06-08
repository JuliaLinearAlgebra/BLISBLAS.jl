module BLISBLAS

using blis32_jll, LAPACK32_jll
using blis_jll, LAPACK_jll
using LinearAlgebra

function get_num_threads()
    ret = @ccall blis.bli_thread_get_num_threads()::Cint
    ret == -1 && throw(ErrorException("return value was -1"))
    ret = @ccall blis32.bli_thread_get_num_threads()::Cint
    ret == -1 && throw(ErrorException("return value was -1"))
    return ret
end

function set_num_threads(nthreads)
    ret = @ccall blis.bli_thread_set_num_threads(nthreads::Cint)::Cvoid
    ret == -1 && throw(ErrorException("return value was -1"))
    ret = @ccall blis32.bli_thread_set_num_threads(nthreads::Cint)::Cvoid
    ret == -1 && throw(ErrorException("return value was -1"))
    return nothing
end

function __init__()
    blis_available = blis32_jll.is_available() && blis_jll.is_available()
    if blis_available
        BLAS.lbt_forward(blis32, clear=true)
        BLAS.lbt_forward(liblapack32)
        BLAS.lbt_forward(blis)
        BLAS.lbt_forward(liblapack)
    else
        @warn("The artifacts blis_jll and blis32_jll are not available for your platform!")
    end
end

end # module
