import "./lib/github.com/diku-dk/cpprandom/random"
import "./lib/github.com/diku-dk/cpprandom/shuffle"
import "./score"

module dist = uniform_real_distribution f32 minstd_rand
module idist = uniform_int_distribution i64 minstd_rand
module shuf = mk_shuffle minstd_rand

def gen_tuple rng =
  let (rng, x) = dist.rand (0, 1) rng
  let (rng, y) = dist.rand (0, 1) rng
  in (rng, [x, y])

entry tsp_generate (n: i64) (s: i32) =
  let rng = minstd_rand.rng_from_seed [s]
  let rngs = minstd_rand.split_rng n rng
  let (rngs, xs) = unzip (map gen_tuple rngs)
  in (minstd_rand.join_rng rngs, xs)

def distance [n] (x: [n]f32) (y: [n]f32) =
  map2 (-) x y |> map (**2) |> f32.sum |> f32.sqrt

def path_length [n] 't (xs : [n][2]f32) =
  let ys = rotate 1 xs
  let pairs = map2 distance xs ys
  in f32.sum pairs

def random_individual rng problem =
  shuf.shuffle rng problem

entry initial_pop (n: i64) (problem: [][2]f32) rng =
  let rngs = minstd_rand.split_rng n rng
  let (rngs, pop) = unzip (map (flip random_individual problem) rngs)
  in (minstd_rand.join_rng rngs, pop)

def generate_change rng path =
  let n = length path
  let (rng, i_1) = idist.rand (0, n-1) rng
  let (rng, i_2) = idist.rand (0, n-1) rng
  in (
    rng,
    (
      [ i_1, i_2 ],
      [ path[i_1], path[i_2] ]
    )
  )

def apply_change path (indices, values) =
  scatter (copy path) indices values

def gen_step [n] rng (pop: [n][][2]f32) =
  let rngs = minstd_rand.split_rng n rng
  let (rngs, changes) = unzip (map2 generate_change rngs pop)
  let pop = map2 apply_change pop changes
  let rng = minstd_rand.join_rng rngs
  in (rng, pop)

def reduce_step (rng, pop) =
  (rng, pop)

-- entry next_pop [n] rng (pop: [n][][2]f32) =
--   gen_step >-> reduce_step
entry next_pop rng pop = reduce_step (gen_step rng pop)
