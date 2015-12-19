to_dot(g::GraphStore) = to_dot(g.graph, g.attributes)
function to_dot(g::GraphStore, ex::ExVertex)
  n = inclist(ExVertex, ExEdge{ExVertex}, is_directed=g.graph.is_directed)
  v = ExVertex(1, ex.label)
  v.attributes = ex.attributes
  add_vertex!(n, v)
  to_dot(n)
end
function to_dot(g::GraphStore, ex::ExEdge)
  n = inclist(ExVertex, ExEdge{ExVertex}, is_directed=g.graph.is_directed)
  vtxfrom = ExVertex(1, ex.source.label)
  vtxfrom.attributes = ex.source.attributes
  add_vertex!(n, vtxfrom)
  vtxto = ExVertex(2, ex.target.label)
  vtxto.attributes = ex.target.attributes
  add_vertex!(n, vtxto)
  add_edge!(n, ExEdge(1, vtxfrom, vtxto, ex.attributes))
  to_dot(n)
end

draw(g::GraphStore) = Graph(to_dot(g))
draw(g::GraphStore, ex::Union{ExVertex,ExEdge}) = Graph(to_dot(g, ex))
