using GraphTools
using Base.Test

g = @graph A -> B
@test 1 == g["A"].index
@test "A" == g["A"].label


g = @graph "A" -> "B"
@test 1 == g["A"].index
@test "A" == g["A"].label
