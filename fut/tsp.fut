import "./lib/github.com/diku-dk/cpprandom/random"
import "./lib/github.com/diku-dk/cpprandom/shuffle"
import "./lib/github.com/athas/vector/vspace"


module traveling_salesman_problem (E: rng_engine) (R: real) = {
  module dist = uniform_real_distribution R E
  module idist = uniform_int_distribution i64 E
  module shuf = mk_shuffle E
  module vspace_2 = mk_vspace_2d R

  type vec = {x: R.t, y: R.t}
  type rng_engine = E.rng

  type maybe 't = #nothing | #just t
  type solution [n] = maybe ([n]vec)

  def fmap 'a 'b (f: a -> b) (mx: maybe a): maybe b =
    match mx
    case #nothing -> #nothing
    case #just x -> #just (f x)

  -- TODO(daan): maybe change f from a -> state s a to state s a -> state s a
  def state_map 'a 's (f: a -> s -> (s, a)) (mx: maybe a) (st: s):
    (s, maybe a) =
    match mx
    case #nothing -> (st, #nothing)
    case #just x ->
      let (st, x) = f x st
      in (st, #just x)

  def mk_point rng: (rng_engine, vec) =
    let (rng, x) = dist.rand (R.i64 0, R.i64 1) rng
    let (rng, y) = dist.rand (R.i64 0, R.i64 1) rng
    in (rng, {x = x, y = y})

  def mk_problem (n: i64) (rng: rng_engine): (rng_engine, solution[n]) =
    let rngs = E.split_rng n rng
    let (rngs, xs) = unzip (map mk_point rngs)
    in (E.join_rng rngs, #just xs)

  def objective [n] (sol : solution[n]) =
    match sol
    case #nothing -> R.highest
    case #just sol ->
      let sol1 = rotate 1 sol
      let pairs = map vspace_2.norm (map2 (vspace_2.-) sol sol1)
      in R.sum pairs

  def initial_solutions [n] (k: i64) (initial: solution[n]) rng =
    let rngs = E.split_rng k rng
    let state_shuffle = state_map (flip shuf.shuffle)
    let (rngs, solutions) = unzip (map (state_shuffle initial) rngs)
    in (E.join_rng rngs, solutions)

  def invalid [n]: (R.t, solution [n]) = (R.lowest, #nothing)

  def max (obj0, sol0) (obj1, sol1) =
    if obj0 R.< obj1 then
      (obj0, sol0)
    else
      (obj1, sol1)

  def maximum = reduce max invalid
}
