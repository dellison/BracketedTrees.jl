using AbstractTrees
using BracketedTrees
using Test

@testset "BracketedTrees.jl" begin
    struct MyTree
        node
        children
    end
    MyTree(node) = MyTree(node, [])

    AbstractTrees.children(tree::MyTree) = tree.children
    BracketedTrees.data(tree::MyTree) = tree.node

    tree_reader = BracketedTrees.TreeReader(MyTree)

    tree = tree_reader("(Node child1 child2 child3)")
    @test tree.node == "Node"
    @test tree.children == ["child1", "child2", "child3"]

    tree = tree_reader("(0 (1 2 2) (1 2 2))")
    buf = IOBuffer()
    BracketedTrees.print_tree(buf, tree, multiline=true)
    str = String(take!(buf))

    @test str == """
                 (0
                   (1 2 2)
                   (1 2 2))
                 """ |> strip
end
