using Documenter
using BracketedTrees

DocMeta.setdocmeta!(BracketedTrees,
                    :DocTestSetup, :(using ConstituencyTrees); recursive=true)

makedocs(
    sitename = "BracketedTrees.jl",
    format = Documenter.HTML(),
    modules = [ConstituencyTrees],
    pages = ["Home" => "index.md"],
    doctest = true)

deploydocs(repo = "github.com/dellison/BracketedTrees.jl.git")
