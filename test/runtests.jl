using Test
using LinearAlgebra
using Random
using Libdl

function blas()
    libs = BLAS.get_config().loaded_libs
    libs = map(lib -> lowercase(basename(lib.libname)), libs)
    if mapreduce(lib -> contains(lib, "openblas"), |, libs)
        return :openblas
    elseif mapreduce(lib -> contains(lib, "blis"), |, libs)
        return :blis
    else
        return :unknown
    end
end

@testset verbose=true "BLISBLAS.jl tests" begin
    @testset verbose=true "Sanity Tests" begin
        @test blas() == :openblas
        using BLISBLAS
        @test blas() == :blis
        @test LinearAlgebra.peakflops() > 0
    end

    @testset verbose=true "BLAS threads" begin
        @test isnothing(BLISBLAS.set_num_threads(1))
        @test BLISBLAS.get_num_threads() == 1
        @test isnothing(BLISBLAS.set_num_threads(2))
        @test BLISBLAS.get_num_threads() == 2
        @test isnothing(BLISBLAS.set_num_threads(3))
        @test BLISBLAS.get_num_threads() == 3
    end

    linalg_stdlib_test_path = joinpath(dirname(pathof(LinearAlgebra)), "..", "test")

    @testset verbose=true "LinearAlgebra.jl BLAS tests" begin
        joinpath(linalg_stdlib_test_path, "blas.jl") |> include
    end

    @testset verbose=true "LinearAlgebra.jl LAPACK tests" begin
        joinpath(linalg_stdlib_test_path, "lapack.jl") |> include
    end
end
