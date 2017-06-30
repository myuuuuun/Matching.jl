__precompile__()

module MyMatchingMarkets
	import Base: pop!, push!, length, isempty

    export TwoSidedMatchingMarket, Agents, Counter
    export deferred_acceptance, test_da, make_ranking_from_prefs, get_next!

    include("tools.jl")
    include("two_sided_matching.jl")

end