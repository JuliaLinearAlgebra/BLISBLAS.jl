module BLISBLAS

using blis32_jll
using blis_jll
using LinearAlgebra

function get_num_threads()
    ret = @ccall blis.bli_thread_get_num_threads()::Cint
    ret == -1 && throw(ErrorException("return value was -1"))
    return ret
end

function set_num_threads(nthreads)
    ret = @ccall blis.bli_thread_set_num_threads(nthreads::Cint)::Cvoid
    ret == -1 && throw(ErrorException("return value was -1"))
    return nothing
end

function __init__()
    if blis32_jll.is_available()
        BLAS.lbt_forward(blis32, clear=false)
    else
        @warn("blis32_jll artifact doesn't seem to be available for your platform!")
    end
    if blis_jll.is_available()
        BLAS.lbt_forward(blis, clear=false)
    else
        @warn("blis_jll artifact doesn't seem to be available for your platform!")
    end
end

end # module
