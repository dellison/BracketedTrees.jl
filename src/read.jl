import Automa
import Automa.RegExp: @re_str
const re = Automa.RegExp

struct Open end
struct Close end
struct Node; val end
struct Leaf; val end

function token!(stack, node::Node, T)
    push!(stack, T(node.val, []))
    return stack
end
function token!(stack, ::Close, T)
    node = pop!(stack)
    parent = pop!(stack)
    push!(stack, T(data(parent), [children(parent) ; node]))
    return stack
end
function token!(stack, leaf::Leaf, T)
    node = pop!(stack)
    push!(stack, T(data(node), [children(node); leaf.val]))
    return stack
end

"""
"""
struct TreeReader
    Tree
    tokenizer
    read
end

function TreeReader(T)
    close      = re"\)"
    node       = re"\([ \t\n]*[^ \)\(\t\n]*"
    leaf       = re"[^ \)\(\t\n]+"
    whitespace = re"[ \t\n]*"

    tokenizer = Automa.compile(
        node       => :(token!(stack, Node(data[ts+1:te]), $T)),
        close      => :(token!(stack, Close(), $T)),
        leaf       => :(token!(stack, Leaf(data[ts:te]), $T)),
        whitespace => :()
    )

    context = Automa.CodeGenContext()
    reader = @eval function (data)
        stack = Any[$T(nothing, [])]
        
        $(Automa.generate_init_code(context, tokenizer))
        p_end = p_eof = sizeof(data)
        while p ≤ p_eof && cs > 0
            $(Automa.generate_exec_code(context, tokenizer))
        end
        if cs != 0
            error("dangit", cs)
        end
        return last(children(last(stack)))
    end

    return TreeReader(T, tokenizer, reader)
end

read_tree(str) = READER.read(str)
read_bracketed_tree(reader, str) = reader.read(str)

(reader::TreeReader)(data) = reader.read(data)
