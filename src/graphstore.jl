import Graphs: inclist, ExVertex, ExEdge, add_vertex!, add_edge!, AttributeDict, num_vertices, num_edges, GenericIncidenceList
import GraphViz: Graph
import Base: getindex, setindex!

export indexof, vertexof, edgeof

import Graphs: to_dot
export         to_dot

import Base: +
export       +


typealias Label AbstractString

type GraphStore
  graph::GenericIncidenceList  
  attributes::AttributeDict
  GraphStore(graph) = new(graph, AttributeDict())
end

getindex(g::GraphStore, label::Label) = vertexof(g, label)
function vertexof(g::GraphStore, label::Label)
  for v in g.graph.vertices 
    v.label == label && return v
  end
  nothing
end

function edgeof(g::GraphStore, from::Label, to::Label)
  for el in g.graph.inclist
    for e::ExEdge{ExVertex} in el
      e.source.label == from && e.target.label == to && return e
    end
  end
  nothing 
end

function indexof(g::GraphStore, label::Label)
  vtx = vertexof(g, label)
  isa(vtx, Void) ? 0 : vtx.index
end

function add_vertex!(g::GraphStore, label::Label)
  vtx = vertexof(g, label)
  if isa(vtx, Void)
    cnt = num_vertices(g.graph)+1
    vtx = ExVertex(cnt, label)
    vtx.attributes["label"] = label
    add_vertex!(g.graph, vtx)
  else
    vtx
  end
end

function +(a::GraphStore, b::GraphStore)
  for el in b.graph.inclist
    for e::ExEdge{ExVertex} in el
      vtxfrom, vtxto = add_vertex!(a, e.source.label), add_vertex!(a, e.target.label)
      edge = ExEdge{ExVertex}(num_edges(a.graph), vtxfrom, vtxto, e.attributes)
      add_edge!(a.graph, edge)
    end
  end
  if !issubset(map(x->x.label, b.graph.vertices), map(x->x.label, a.graph.vertices))
    for v in b.graph.vertices
      vtx = vertexof(a, v.label)
      isa(vtx, Void) && add_vertex!(a, v.label)
    end
  end
  if a.graph.is_directed != b.graph.is_directed
    a.graph.is_directed = true
  end
  a
end

function setindex!(ex::Union{ExVertex,ExEdge}, value, attr)
  ex.attributes[attr] = value
end


include("parse.jl")
macro graph(args...)
  list = []
  for el in args
    list = vcat(list, isa(el, Expr) ? adjacency(el.args...) : isa(el, Symbol) ? string(el) : el)
  end
  parse(list)
end


include("draw.jl")
