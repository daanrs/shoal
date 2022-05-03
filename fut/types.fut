module type metaheuristic = {
  type rng
  type sol

  type^ state 'a = rng -> (rng, a)
  type^ change = state sol -> state sol

  -- val change: state sol -> state sol
  val change: change
  val combine: sol -> change

  type obj
  type final
  val final: sol -> final
  val score: final -> obj

  -- (obj, sol) :: monoid
  val gt: obj -> obj -> bool
  val invalid: (obj, sol)
  val max: (obj, sol) -> (obj, sol) -> (obj, sol)

  -- val gen_step: state -> set -> (state, a)
  -- val reduce_step: (state, a) -> (state, a) -> (state, set)
}
