using Test
using LinearAlgebra
using Random
using Libdl

function blas()
    libs = BLAS.get_config().loaded_libs
    lib = lowercase(basename(last(libs).libname))
    if contains(lib, "openblas")
        return :openblas
    elseif contains(lib, "blis")
        return :blis
    else
        return :unknown
    end
end

@testset "BLISBLAS.jl" begin
    @testset "Sanity Tests" begin
        @test blas() == :openblas
        using BLISBLAS
        @test blas() == :blis
        @test LinearAlgebra.peakflops() > 0
    end

    @testset "BLAS threads" begin
        @test isnothing(BLISBLAS.set_num_threads(1))
        @test BLISBLAS.get_num_threads() == 1
        @test isnothing(BLISBLAS.set_num_threads(2))
        @test BLISBLAS.get_num_threads() == 2
        @test isnothing(BLISBLAS.set_num_threads(3))
        @test BLISBLAS.get_num_threads() == 3
    end

    @testset "BLAS" begin
        # run all BLAS tests of the LinearAlgebra stdlib (i.e. LinearAlgebra/test/blas.jl)
        linalg_stdlib_test_path = joinpath(dirname(pathof(LinearAlgebra)), "..", "test")
        include(joinpath(linalg_stdlib_test_path, "blas.jl"))
    end
end
