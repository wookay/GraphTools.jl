using GraphTools
using Base.Test

if VERSION.minor < 5
  macro testset(name, block)
    eval(block)
  end
end

@testset "GraphTools" begin
  @testset "Undirected Graph" begin
    include("undirected.jl")
  end
  @testset "Directed Graph" begin
    include("directed.jl")
  end
  @testset "GraphStore" begin
    include("graphstore.jl")
  end
end
