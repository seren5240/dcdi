import re
import numpy as np

shds = []

for i in range(1, 11):
    with open(f'dag_{i}/log.txt') as f:
        content = f.read()
        match = re.search(r"shd:\s*(\d+)", content)
        if match:
            shd = int(match.group(1))
            print(f"SHD for dag_{i}: {shd}")
            shds.append(shd)
        else:
            print(f"Warning: No SHD found in dag_{i}/log.txt")

# mean: 3.2
print(f"Mean SHD: {np.mean(shds)}")
