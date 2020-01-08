using Documenter
using BracketedTrees

DocMeta.setdocmeta!(BracketedTrees,
                    :DocTestSetup, :(using BracketedTrees); recursive=true)

makedocs(
    sitename = "BracketedTrees.jl",
    format = Documenter.HTML(),
    modules = [BracketedTrees],
    pages = ["Home" => "index.md"],
    doctest = true)

deploydocs(repo = "github.com/dellison/BracketedTrees.jl.git")
