module type solution = {
  type t
  val score: t -> f32
}

def fst (x, _) = x
def snd (_, y) = y

def max_with_key 'a 'b
  (gt: b -> b -> bool)
  ((v1, s1): (a, b))
  ((v2, s2): (a, b))
  : (a, b) =

  if gt s1 s2 then
    (v1, s1)
  else
    (v2, s2)

def reduce_by_key [n] 'a 'b
  (k: a -> b)
  (op: (a, b) -> (a, b) -> (a, b))
  (ne: (a, b))
  (as: [n]a)
  : a =

  let as = zip as (map k as)
  in fst (reduce op ne as)
