import fut.tsp as tsp

t = tsp.tsp()
n = 1000
rng, problem = t.tsp_generate(10, 123)

rng, pop = tsp.initial_pop(n, problem, rng)

rng, next_pop = tsp.next_pop(rng, pop)
