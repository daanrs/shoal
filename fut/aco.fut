module type aco = {
  type solution
  type subsolutions

  val update: subsolutions -> subsolutions -> subsolutions
  val count: solution -> subsolution

  val create: subsolutions -> rng -> solution
}

import "./lib/github.com/diku-dk/cpprandom/random"
import "./tsp"

module tsp = traveling_salesman_problem minstd_rand f32

type subsolutions [n] = [n][n]i64

def gather_2d xs is =
  let index_2d x (i0, i1) = x[i0][i1]
  in map (index_2d xs) is

-- monoid: update & mempty
def update [n] (ss0: subsolutions [n]) (ss1: subsolutions [n]) =
  map2 (map2 (+)) ss0 ss1

def mempty (n: i64): subsolutions = replicate n (replicate n 0)

def count [n] (sol: solution [n]): *subsolutions [n] =
  let ss = replicate n (replicate n 0)
  let is = zip sol (rotate 1 sol)
  in scatter_2d ss is (replicate n 1)
