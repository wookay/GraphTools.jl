using GraphTools
using Base.Test

d = @graph A -> B
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n}\n" == to_dot(d)

d = @graph A -> B -> C
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n2 -> 3 \n3 [\"label\"=\"C\"]\n}\n" == to_dot(d)

d = @graph A -> B 50-> C
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n2 -> 3 [\"label\"=\"50\",\"weight\"=\"50\"]\n3 [\"label\"=\"C\"]\n}\n" == to_dot(d)

da = @graph A -> B 50-> C
db = @graph C 10-> A
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n2 -> 3 [\"label\"=\"50\",\"weight\"=\"50\"]\n3 [\"label\"=\"C\"]\n3 -> 1 [\"label\"=\"10\",\"weight\"=\"10\"]\n}\n" == to_dot(da + db)

da = @graph A
db = @graph B -> C
dc = @graph D -> A
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n2 [\"label\"=\"B\"]\n2 -> 3 \n3 [\"label\"=\"C\"]\n3 -> 2 \n4 [\"label\"=\"D\"]\n4 -> 1 \n}\n" == to_dot(da + db + dc)


d = @graph "A" -> "B"
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n}\n" == to_dot(d)

d = @graph "A" -> "B" -> "C"
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n2 -> 3 \n3 [\"label\"=\"C\"]\n}\n" == to_dot(d)

d = @graph "A" -> "B" 50-> "C"
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n2 -> 3 [\"label\"=\"50\",\"weight\"=\"50\"]\n3 [\"label\"=\"C\"]\n}\n" == to_dot(d)

da = @graph "A" -> "B" 50-> "C"
db = @graph "C" 10-> "A"
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n1 -> 2 \n2 [\"label\"=\"B\"]\n2 -> 3 [\"label\"=\"50\",\"weight\"=\"50\"]\n3 [\"label\"=\"C\"]\n3 -> 1 [\"label\"=\"10\",\"weight\"=\"10\"]\n}\n" == to_dot(da + db)

da = @graph "A"
db = @graph "B" -> "C"
dc = @graph "D" -> "A"
@test "digraph graphname {\n1 [\"label\"=\"A\"]\n2 [\"label\"=\"B\"]\n2 -> 3 \n3 [\"label\"=\"C\"]\n3 -> 2 \n4 [\"label\"=\"D\"]\n4 -> 1 \n}\n" == to_dot(da + db + dc)
