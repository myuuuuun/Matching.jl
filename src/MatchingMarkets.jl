__precompile__()

module MatchingMarkets
	import Base: pop!, push!, length, isempty

    export TwoSidedMatchingMarket, Preferences, FixedSizeStack, Counter
    export deferred_acceptance2, deferred_acceptance3, test_da, make_ranking_from_prefs, push!, pop!, top, length, isempty, get_next!, change_user!

    include("tools.jl")
    include("two_sided_matching.jl")

end