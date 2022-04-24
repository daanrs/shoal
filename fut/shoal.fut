module type comparable = {
  type~ objective
  val gt: objective -> objective -> bool
}

module type problem = {
  include comparable

  type~ solution
  type~ final
  val score: final -> objective
  val best: solution -> final

  -- val change: state -> solution -> (state, solution)
  -- val combine: state -> solution -> solution -> (state, solution)

  -- change :: monoid
  -- val mempty: change
  -- val op: change -> change -> change

  -- val generate 'change : state -> solution -> (state, change)
  -- val apply 'change : change -> solution -> solution

  -- val gen_step 'a : state -> set -> (state, a)
  -- val reduce_step 'a: (state, a) -> (state, a) -> (state, set)
}

def fst (x, _) = x
def snd (_, y) = y
