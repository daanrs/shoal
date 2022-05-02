import numpy as np
import fut.ea as ea

fut_ea = ea.ea()
n = 20
rng, problem = fut_ea.start(20)

# print(problem)

rng, pop = fut_ea.solutions(n, problem, rng)

# print(pop)

rng, next_pop = fut_ea.step(rng, pop)
for i in range(1000):
    rng, next_pop = fut_ea.step(rng, next_pop)

print("p")
scores = fut_ea.map_obj(pop)
best = np.min(scores)
print(scores)

print("np")
next_scores = fut_ea.map_obj(next_pop)
next_best = np.min(next_scores)
print(next_scores)

next_pop = fut_ea.print_solutions(next_pop)
pop = fut_ea.print_solutions(pop)
