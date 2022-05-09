module type aco = {
  type solution
  type components

  -- | Add heuristic info to the components, providing info on the
  -- objective value of particular components. An example is the distance
  -- of an edge u -> v in TSP.
  val heuristic_info: components -> components

  -- | Combine two component collections. This is assumed to be a monoid
  -- with empty.
  val combine: components -> components -> components
  val empty: components

  -- | Enumerate components in a solution
  val enumerate: solution -> subsolution

  -- | Create a random solution from components
  val create: components -> rng -> solution
}

import "./lib/github.com/diku-dk/cpprandom/random"
import "./tsp"

module tsp = traveling_salesman_problem minstd_rand f32
open tsp

type components [n] = [n][n]i64

def outer_product 'a 'b [u] (f: a -> a -> b) (xs: [n]a) (ys: [n]a) =
  map (\x -> map (\y -> f x y) ys) xs

def distance_matrix [n] (xs: [n]vec) (ys: [n]vec) = outer_product (-)

def gather_2d xs is =
  let index_2d x (i0, i1) = x[i0][i1]
  in map (index_2d xs) is

-- monoid: combine & mempty
def combine [n] (ss0: components [n]) (ss1: components [n]) =
  map2 (map2 (+)) ss0 ss1

def mempty (n: i64): components = replicate n (replicate n 0)

def enumerate [n] (sol: solution [n]): *components [n] =
  let ss = replicate n (replicate n 0)
  let is = zip sol (rotate 1 sol)
  in scatter_2d ss is (replicate n 1)
