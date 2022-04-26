import "./tsp"

-- create 2 indices and values to swap
def mk_swap rng path =
  let n = length path
  let (rng, i_1) = idist.rand (0, n-1) rng
  let (rng, i_2) = idist.rand (0, n-1) rng
  in (
    rng,
    (
      [ i_1, i_2 ],
      [ path[i_2], path[i_1] ]
    )
  )

def apply_swap (indices, values) path =
  scatter (copy path) indices values

def gen_step [n] rng (sols: [n]solution) =
  let rngs = minstd_rand.split_rng n rng
  let (rngs, swaps) = unzip (map2 mk_swap rngs sols)
  let sols = map2 apply_swap swaps sols
  let rng = minstd_rand.join_rng rngs
  in (rng, sols)

def invalid: (f32, solution) = (f32.lowest, #nothing)

def max (obj0, sol0) (obj1, sol1) =
  if gt obj0 obj1 then
    (obj0, sol0)
  else
    (obj1, sol1)

def reduce_step sol0 sol1 =
  let sol0 = zip (map objective sol0) sol0
  let sol1 = zip (map objective sol1) sol1
