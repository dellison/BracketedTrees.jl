print_tree(tree; kws...) = print_tree(stdout, tree; kws...)
print_tree(io::IO, tree; kws...) = print(io, brackets(tree; kws...))

function brackets(tree; depth=0, indent=2, multiline=true)
    s = "(" * label(tree)
    if !isleaf(tree)
        for child in children(tree)
            if !isleaf(child)
                if multiline
                    s *= "\n"
                    s *= repeat(" ", (depth + 1) * indent)
                else
                    if !isempty(label(tree))
                        s *= " "
                    end
                end
                kws = (depth=depth + 1, indent=indent, multiline=multiline)
                s *= brackets(child; kws...)
            else
                if !isempty(label(child))
                    s *= " " * label(child)
                else
                    @show child label(child)
                end
            end
        end
    end
    return s * ")"
end

isleaf(tree) = isempty(children(tree))

label(x) = x === nothing || data(x) === nothing ? "" : string(data(x))
