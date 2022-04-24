import "./tsp"

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

entry next_pop rng pop = reduce_step (gen_step rng pop)
