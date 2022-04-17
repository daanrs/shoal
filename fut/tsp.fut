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

def tsp_generate n =
  let rng = minstd_rand.rng_from_seed [123]
  let rngs = minstd_rand.split_rng n rng
  let (rngs, xs) = unzip (map gen_tuple rngs)
  in (minstd_rand.join_rng rngs, xs)

def distance [n] (x: [n]f32) (y: [n]f32) =
  map2 (-) x y |> map (**2) |> f32.sum |> f32.sqrt

def path_length [n] 't (xs : [n][2]f32) =
  let ys = rotate 1 xs
  let pairs = map2 distance xs ys
  in f32.sum pairs

def generate_change rng path =
  let n = length path
  let (rng, i_1) = idist.rand (0, n) rng
  let (rng, i_2) = idist.rand (0, n) rng
  in (
    rng,
    (
      [ i_1, i_2 ],
      [ path[i_1], path[i_2] ]
    )
  )

def apply_change path (indices, values) =
  scatter (copy path) indices values

def next_pop [n] 't rng (pop: [n][][2]f32) =
  let rngs = minstd_rand.split_rng n rng
  let (rngs, changes) = unzip (map2 generate_change rngs pop)
  let pop = map2 apply_change pop changes
  let rng = minstd_rand.join_rng rngs
  in (rng, pop)
