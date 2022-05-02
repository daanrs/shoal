import "./lib/github.com/diku-dk/cpprandom/random"
import "./tsp"

module tsp = traveling_salesman_problem minstd_rand f32
open tsp

-- return a solution with k values cycled
def swap [n] (k: i64) (path: [n]vec) (rng: rng_engine) =
  let rngs = minstd_rand.split_rng k rng
  let (rngs, is) = unzip (map (idist.rand (0, n-1)) rngs)
  let vals = rotate 1 (map (\x -> path[x]) is)
  in (minstd_rand.join_rng rngs, scatter (copy path) is vals)

def gen_step [m] [n] rng (sols: [m]solution [n]) =
  let rngs = minstd_rand.split_rng m rng
  let (rngs, sols) = unzip (map2 (state_map (swap 2)) sols rngs)
  let rng = minstd_rand.join_rng rngs
  in (rng, sols)

def reduce_step sols sols_next =
  let sols = zip (map objective sols) sols
  let sols_next = zip (map objective sols_next) sols_next
  let (_, sols) = unzip (map2 max sols sols_next)
  in sols

entry start n = mk_problem n (minstd_rand.rng_from_seed [123])

entry solutions = initial_solutions

entry step rng sols =
  let (rng, sols_next) = gen_step rng sols
  in (rng, reduce_step sols sols_next)

entry map_obj = map objective

def print_vector {x, y} = [x, y]

def print [n] (sol: solution [n]) =
  match sol
  case #nothing -> replicate n [0, 0]
  case #just sol -> map print_vector sol

entry print_solutions = map print
