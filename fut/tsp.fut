import "./lib/github.com/diku-dk/cpprandom/random"
import "./lib/github.com/diku-dk/cpprandom/shuffle"
import "./lib/github.com/athas/vector/vspace"

type myfloat = myfloat
module vspace_2 = mk_vspace_2d myfloat
type solution = #nothing | #just []vspace_2.vector

module dist = uniform_real_distribution myfloat minstd_rand
module idist = uniform_int_distribution i64 minstd_rand
module shuf = mk_shuffle minstd_rand

def gen_tuple rng: vspace_2d.vector =
  let (rng, x) = dist.rand (0, 1) rng
  let (rng, y) = dist.rand (0, 1) rng
  in (rng, {x = x, y = y})

entry tsp_generate (n: i64) (s: i32) =
  let rng = minstd_rand.rng_from_seed [s]
  let rngs = minstd_rand.split_rng n rng
  let (rngs, xs) = unzip (map gen_tuple rngs)
  in (minstd_rand.join_rng rngs, xs)

def objective [n] 't (xs : solution) =
  match solution
  case #nothing -> f32.lowest
  case #just xs ->
    let ys = rotate 1 xs
    let pairs = map vspace_2.norm (map2 (-) xs ys)
    in myfloat.sum pairs

entry initial_solutions (n: i64) (initial: solution) rng =
  let rngs = minstd_rand.split_rng n rng
  let (rngs, solutions) = unzip (map (flip shuf.shuffle initial) rngs)
  in (minstd_rand.join_rng rngs, solutions)
