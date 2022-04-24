import fut.tsp as tsp

t = tsp.tsp()
n = 1000
rng, problem = t.tsp_generate(10, 123)

print(problem)

rng, pop = t.initial_pop(n, problem, rng)

print(pop)

rng, next_pop = t.next_pop(rng, pop)
print(next_pop)
