using GraphTools
using Base.Test

u = @graph
@test "graph graphname {\n}\n" == to_dot(u)

u = @graph A
@test "graph graphname {\n1 [\"label\"=\"A\"]\n}\n" == to_dot(u)

u = @graph A - B
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 \n2 [\"label\"=\"B\"]\n}\n" == to_dot(u)

u = @graph A - B - C
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 \n2 [\"label\"=\"B\"]\n2 -- 3 \n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)

u = @graph A - B - C - A
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 \n1 -- 3 \n2 [\"label\"=\"B\"]\n2 -- 3 \n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)
@test 1 == indexof(u, "A")
@test 2 == indexof(u, "B")
@test 0 == indexof(u, "Z")

u = @graph A 50- B 60- C
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 [\"label\"=\"50\",\"weight\"=\"50\"]\n2 [\"label\"=\"B\"]\n2 -- 3 [\"label\"=\"60\",\"weight\"=\"60\"]\n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)

u = @graph A 0.5- B 0.6- C
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 [\"label\"=\"0.5\",\"weight\"=\"0.5\"]\n2 [\"label\"=\"B\"]\n2 -- 3 [\"label\"=\"0.6\",\"weight\"=\"0.6\"]\n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)

ua = @graph A
ub = @graph B
@test "graph graphname {\n1 [\"label\"=\"A\"]\n2 [\"label\"=\"B\"]\n}\n" == to_dot(ua + ub)


u = @graph "A"
@test "graph graphname {\n1 [\"label\"=\"A\"]\n}\n" == to_dot(u)

u = @graph "A" - "B"
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 \n2 [\"label\"=\"B\"]\n}\n" == to_dot(u)

u = @graph "A" - "B" - "C"
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 \n2 [\"label\"=\"B\"]\n2 -- 3 \n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)

u = @graph "A" - "B" - "C" - "A"
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 \n1 -- 3 \n2 [\"label\"=\"B\"]\n2 -- 3 \n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)
@test 1 == indexof(u, "A")
@test 2 == indexof(u, "B")
@test 0 == indexof(u, "Z")

u = @graph "A" 50- "B" 60- "C"
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 [\"label\"=\"50\",\"weight\"=\"50\"]\n2 [\"label\"=\"B\"]\n2 -- 3 [\"label\"=\"60\",\"weight\"=\"60\"]\n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)

u = @graph "A" 0.5- "B" 0.6- "C"
@test "graph graphname {\n1 [\"label\"=\"A\"]\n1 -- 2 [\"label\"=\"0.5\",\"weight\"=\"0.5\"]\n2 [\"label\"=\"B\"]\n2 -- 3 [\"label\"=\"0.6\",\"weight\"=\"0.6\"]\n3 [\"label\"=\"C\"]\n}\n" == to_dot(u)

ua = @graph "A"
ub = @graph "B"
@test "graph graphname {\n1 [\"label\"=\"A\"]\n2 [\"label\"=\"B\"]\n}\n" == to_dot(ua + ub)
