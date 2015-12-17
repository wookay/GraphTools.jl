import Graphs: inclist, ExVertex, ExEdge, add_vertex!, add_edge!, AttributeDict, num_vertices, num_edges, GenericIncidenceList
import GraphViz: Graph
import Base: getindex

export indexof

import Graphs: to_dot
export         to_dot

import Base: +
export       +


typealias Label AbstractString

type GraphStore
  graph::GenericIncidenceList  
end

# WEdge
type WEdge
  direction::Symbol
  weight::Union{Number,Void}
  WEdge(direction::Symbol) = new(direction, nothing)
  WEdge(direction::Symbol, weight) = new(direction, weight)
end

function Base.show(io::IO, e::WEdge)
  print(io, string(isa(e.weight, Void) ? "" : e.weight, e.direction))
end

# Undirected
adjacency(e::Symbol, w::Number, b::Label) = [WEdge(e, w); b]
adjacency(e::Symbol, a::Label, w::Number) = [a; WEdge(e, w)]
adjacency(e::Symbol, a::Label, b::Label) = [a; WEdge(e); b]
adjacency(e::Symbol, ex::Expr, b::Label) = [adjacency(ex.args...); WEdge(e); b]

# Directed
function adjacency(w::Number, ex::Expr)
  if ex.head == :block
    for el in ex.args
      if isa(el, Expr)
        if el.head == :->
          return [WEdge(:->, w); adjacency(el.args...)]
        end
      else
        return [WEdge(:->, w); el]
      end
    end
  end
end
function adjacency(a::Label, ex::Expr)
  if ex.head == :block
    for el in ex.args
      if isa(el, Expr)
        if el.head == :->
          return [a; WEdge(:->, nothing); adjacency(el.args...)]
        end
      else
        return [a; WEdge(:->, nothing); el]
      end
    end
  end
end

function parse(list::AbstractArray)
  range = 1:2:length(list)
  is_directed = range.stop>1 && list[2].direction==:->
  g = inclist(ExVertex, ExEdge{ExVertex}, is_directed=is_directed)
  dv = Dict()
  cnt = 0
  weights = []
  if range.stop==1
    v = first(list)
    vtx = ExVertex(1, v)
    vtx.attributes["label"] = v 
    add_vertex!(g, vtx)
  else
    for idx in range[1:end-1]
      from,edge,to = list[idx:idx+2]
      for v in [from to]
        if !haskey(dv, v)
          cnt += 1
          vtx = ExVertex(cnt, v)
          vtx.attributes["label"] = v 
          dv[v] = add_vertex!(g, vtx)
        end
      end
      attrs = AttributeDict()
      if !isa(edge.weight, Void)
        attrs["label"] = edge.weight
        attrs["weight"] = edge.weight
      end
      e = ExEdge{ExVertex}(num_edges(g), dv[from], dv[to], attrs)
      add_edge!(g, e)
    end
  end
  GraphStore(g)
end

function vertexof(g::GraphStore, label::Label)
  for v in g.graph.vertices 
    v.label == label && return v
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
    if !isempty(el)
      e::ExEdge{ExVertex} = first(el)
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

macro graph(args...)
  list = []
  for el in args
    list = vcat(list, isa(el, Expr) ? adjacency(el.args...) : el)
  end
  parse(list)
end

to_dot(g::GraphStore) = to_dot(g.graph)
draw(g::GraphStore) = Graph(to_dot(g))
