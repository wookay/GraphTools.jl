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
adjacency(e::Symbol, w::Number, b::Symbol) = adjacency(e, w, string(b))
adjacency(e::Symbol, w::Number, b::Label) = [WEdge(e, w); b]
adjacency(e::Symbol, a::Label, w::Number) = [a; WEdge(e, w)]
adjacency(e::Symbol, a::Label, b::Label) = [a; WEdge(e); b]
adjacency(e::Symbol, ex::Expr, b::Label) = [adjacency(ex.args...); WEdge(e); b]
adjacency(e::Symbol, ex::Expr, b::Symbol) = adjacency(e, ex, string(b))
adjacency(e::Symbol, a::Symbol, b::Symbol) = [string(a); WEdge(e); string(b)]


# Directed
function adjacency(w::Number, ex::Expr)
  if ex.head == :block
    for el in ex.args
      if isa(el, Expr)
        if el.head == :->
          return [WEdge(:->, w); adjacency(el.args...)]
        end
      elseif isa(el, Symbol)
        return [WEdge(:->, w); string(el)]
      else
        return [WEdge(:->, w); el]
      end
    end
  end
end

adjacency(sym::Symbol, ex::Expr) = adjacency(string(sym), ex)
function adjacency(a::Label, ex::Expr)
  if ex.head == :block
    for el in ex.args
      if isa(el, Expr)
        if el.head == :->
          return [a; WEdge(:->, nothing); adjacency(el.args...)]
        end
      elseif isa(el, Symbol)
        return [a; WEdge(:->, nothing); string(el)]
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
