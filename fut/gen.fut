import "./lib/github.com/diku-dk/cpprandom/random"
import "./lib/github.com/diku-dk/cpprandom/shuffle"

module dist = uniform_real_distribution f32 minstd_rand

module shuf = mk_shuffle minstd_rand

def fst (x, _) = x
def snd (_, y) = y

def gen_tuple rng =
  let (rng, x) = dist.rand (0, 1) rng
  let (rng, y) = dist.rand (0, 1) rng
  in (rng, [x, y])

def gen n =
  let rng = minstd_rand.rng_from_seed [123]
  let rngs = minstd_rand.split_rng n rng
  let (rngs, xs) = unzip (map gen_tuple rngs)
  in (minstd_rand.join_rng rngs, xs)

def distance [n] (x: [n]f32) (y: [n]f32) =
  map2 (-) x y
    |> map (**2)
    |> f32.sum
    |> f32.sqrt

def path_length [n] (xs : [n][2]f32) =
  let ys = rotate 1 xs
  let pairs = map2 distance xs ys
  in f32.sum pairs

def permutation rng x = shuf.shuffle rng x

def pick_tuple check (s1, v1) (s2, v2) =
  if check s1 s2 then
    (s1, v1)
  else
    (s2, v2)

def max_by_key [n] 'a 'b (k: a -> b) (gt: b -> b -> bool) (xs: [n]a): a =
  let xs = zip (map k xs) xs
  in xs
    |> reduce (pick_tuple gt)
    |> snd
