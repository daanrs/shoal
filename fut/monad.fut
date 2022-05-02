module type monad = {
  type^ m 'a

  val pure 'a: a -> m a
  val >>= 'a 'b: m a -> (a -> m b) -> m b
}

module state (S: { type s }): monad = {
  open S
  type^ m 'a = s -> (s, a)

  def pure a s = (s, a)

  -- (s -> (s, a)) -> (a -> s -> (s, b)) -> (s -> (s, b))
  def (>>=) ma f s = let (s, a) = ma s in f a s
}

module maybe: monad = {
  type m 'a = #nothing | #just a

  def pure 'a (x: a): m a = #just x

  def (>>=) 'a 'b (mx: m a) (f: a -> m b) =
    match mx
    case #nothing -> #nothing
    case #just x -> f x
}
