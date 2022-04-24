val score: final -> objective
val best: solution -> final

generate :: solution -> change
apply :: solution -> change -> solution

-- val change: solution -> solution
-- val combine: solution -> solution -> solution

-- change :: monoid
-- val mempty: change
-- val op: change -> change -> change

-- val generate: state -> solution -> (state, change)
-- val apply: change -> solution -> solution

-- val gen_step: state -> set -> (state, a)
-- val reduce_step: (state, a) -> (state, a) -> (state, set)
