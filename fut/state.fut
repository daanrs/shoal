module type monoid = {
  type m
  val op: m -> m -> m
  val mempty: m
}

module type functor = {
  type^ f 'a
  val fmap 'a 'b: (a -> b) -> f a -> f b
}

module type applicative = {
  type^ f 'a
  val pure 'a: a -> f a
  val op 'a 'b: f (a -> b) -> f a -> f b
}

module type monad = {
  type^ m 'a
  val pure 'a: a -> m a
  val bind 'a 'b: m a -> (a -> m b) -> m b
}

module state: monad = {
  type^ m 'a = i32 -> (a, i32)

  def pure a = \s -> (a, s)

  def bind state f s = (uncurry f) (state s)
}

module list: functor = {
  type~ f 'a = []a
  def fmap = map
}

module fun: functor = {
  type^ f 'a = i32 -> a
  def fmap = (<-<)
}
