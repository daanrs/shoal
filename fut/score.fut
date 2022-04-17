module type comparable = {
  type score
  val gt: score -> score -> bool
}

module type solution = {
  include comparable

  type~ individual
  val score: individual -> score
}

module type pop = {
  include solution
  type~ population
  type state

  -- val generate_changes 'change : state -> individual -> (state, []change)
  -- val apply_change 'change : change -> individual -> individual

  -- val next_step: state -> population -> (state, population)
  -- val best_individual: population -> individual
  --
  -- val gen_step 'a : state -> population -> (state, a)
  -- val reduce_step 'a: (state, a) -> (state, population)
}

def fst (x, _) = x
def snd (_, y) = y
