# Two sided matching market
# type definition and algorithms 
#
# author: @myuuuuun
# last update: 2017-06-30


type Agents
    size::Int
    prefs::Vector{Vector{Int}}
    caps::Vector{Int}
end

type TwoSidedMatchingMarket
    men::Agents
    women::Agents
end


@inbounds function make_ranking_from_prefs(proposer_size::Int, 
    non_proposer_size::Int, 
    non_proposer_prefs::Vector{Vector{Int}})
    
    rankings = zeros(Int64, proposer_size, non_proposer_size)
    
    for non_prop in 1:non_proposer_size
        for (ranking, prop) in enumerate(non_proposer_prefs[non_prop])
            rankings[prop, non_prop] = ranking
        end
    end
    
    return rankings
end


function deferred_acceptance(market::TwoSidedMatchingMarket, reversed=false)
    if reversed
        proposer_side = market.women
        non_proposer_side = market.men
    else
        proposer_side = market.men
        non_proposer_side = market.women
    end
    
    # ranking of proposers for each non-proposer
    rankings = make_ranking_from_prefs(proposer_side.size, non_proposer_side.size, non_proposer_side.prefs)
    
    # result matching container
    proposer_matched = zeros(Int64, proposer_side.size)
    non_proposer_matched = zeros(Int64, non_proposer_side.size)
    
    # lowest ranking of non-proposer that each proposer has already proposed to
    proposed_counter = Counter([size(p, 1) for p in proposer_side.prefs])

    # DA loop
    non_proposed = 1 # initial
    proposer = non_proposed

    while non_proposed <= proposer_side.size
        next_ranking = get_next!(proposed_counter, proposer)

        if next_ranking == 0
            non_proposed += 1
            proposer = non_proposed
        
        else
            @inbounds proposing_next = proposer_side.prefs[proposer][next_ranking]
            @inbounds proposer_ranking = rankings[proposer, proposing_next]
            if proposer_ranking > 0
                @inbounds matched = non_proposer_matched[proposing_next]

                if matched == 0
                    @inbounds proposer_matched[proposer] = proposing_next
                    @inbounds non_proposer_matched[proposing_next] = proposer
                    non_proposed += 1
                    proposer = non_proposed
                    
                else
                    @inbounds matched_ranking = rankings[matched, proposing_next]
                    if proposer_ranking < matched_ranking
                        @inbounds proposer_matched[proposer] = proposing_next
                        @inbounds proposer_matched[matched] = 0
                        @inbounds non_proposer_matched[proposing_next], proposer = proposer, matched
                    end
                end
            end
        end
    end
    
    return proposer_matched, non_proposer_matched
end


function test_da(m_prefs, f_prefs)
    m_size = size(m_prefs, 1)
    f_size = size(f_prefs, 1)
    m_caps = ones(Int64, m_size)
    f_caps = ones(Int64, f_size)
    m_side = Preferences(m_size, m_prefs, m_caps)
    f_side = Preferences(f_size, f_prefs, f_caps)
    market = TwoSidedMatchingMarket(m_side, f_side)
    return deferred_acceptance2(market)
end



