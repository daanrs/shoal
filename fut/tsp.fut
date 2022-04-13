import "./lib/github.com/diku-dk/cpprandom/random"
import "./lib/github.com/diku-dk/cpprandom/shuffle"

module dist = uniform_real_distribution f32 minstd_rand
module idist = uniform_int_distribution i64 minstd_rand
module shuf = mk_shuffle minstd_rand

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

  -- val next_step: state -> population -> (state, population)
  -- val best_individual: population -> individual
  --
  -- val gen_step 'a : state -> population -> (state, a)
  -- val reduce_step 'a: (state, a) -> (state, population)
}

def fst (x, _) = x
def snd (_, y) = y

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
  map2 (-) x y
    |> map (**2)
    |> f32.sum
    |> f32.sqrt

def path_length [n] 't (xs : [n][2]f32) =
  let ys = rotate 1 xs
  let pairs = map2 distance xs ys
  in f32.sum pairs

def to_switch rng path =
  let n = length path
  let (rng, i_1) = idist.rand (0, n) rng
  let (rng, i_2) = idist.rand (0, n) rng
  in (rng, (i_1, i_2))

module tsp: pop = {
  type score = f32
  type~ individual = [][2]f32
  type~ population = [][][2]f32
  type state = minstd_rand.rng

  def gt = (f32.>)
  def score = path_length
}
