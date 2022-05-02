val score: final -> obj
val best: sol -> final

change_create :: sol -> change
change_apply :: sol -> change -> [sol]

-- (obj, sol) :: monoid
invalid :: (ojb, sol)
max :: (obj, sol) -> (obj, sol) -> (obj, sol)

-- val change: sol -> sol
-- val combine: sol -> sol -> sol

-- change :: monoid
-- val mempty: change
-- val op: change -> change -> change

-- val generate: state -> sol -> (state, change)
-- val apply: change -> sol -> sol

-- val gen_step: state -> set -> (state, a)
-- val reduce_step: (state, a) -> (state, a) -> (state, set)

fmap :: (a -> b) -> f a -> f b
fmap2 :: (a -> b -> c) -> f a -> f b -> f c

f a -> maybe b -> f (maybe c)

g: a -> b -> c
