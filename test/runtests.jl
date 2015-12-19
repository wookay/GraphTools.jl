using GraphTools
using Base.Test

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
