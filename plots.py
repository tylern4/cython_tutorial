from matplotlib import pyplot as plt
import pandas as pd

df = pd.read_csv("results.csv")
df["Hz"] = df.num / (df.stop - df.start)
df["sec_event"] = (df.stop - df.start) / df.num
grouped = df.groupby("type")

# Plot
fig, ax = plt.subplots(figsize=(16, 9))
ax.set_ylabel("Events Per Second (Hz)")
ax.set_xlabel("Number of Iterations")
for name, group in grouped:
    ax.plot(group.num, group.Hz, marker="o", linestyle="", ms=5, label=name)
ax.legend()
plt.savefig("Hz_vs_num.png")

fig, ax = plt.subplots(figsize=(16, 9))
ax.set_ylabel("Time (Seconds)")
ax.set_xlabel("Number of Iterations")
for name, group in grouped:
    ax.plot(
        group.num,
        (group.stop - group.start),
        marker="o",
        linestyle="",
        ms=5,
        label=name,
    )
ax.legend()
plt.savefig("time_vs_num.png")


# Plot Only fast ones
df = df[df.type != "Python"]
df = df[df.type != "Cython"]
grouped = df.groupby("type")

fig, ax = plt.subplots(figsize=(16, 9))
ax.set_ylabel("Events Per Second (Hz)")
ax.set_xlabel("Number of Iterations")
for name, group in grouped:
    ax.plot(group.num, group.Hz, marker="o", linestyle="", ms=5, label=name)
ax.legend()
plt.savefig("Hz_vs_num_fast.png")

fig, ax = plt.subplots(figsize=(16, 9))
ax.set_ylabel("Time (Seconds)")
ax.set_xlabel("Number of Iterations")
for name, group in grouped:
    ax.plot(
        group.num,
        (group.stop - group.start),
        marker="o",
        linestyle="",
        ms=5,
        label=name,
    )
ax.legend()
plt.savefig("time_vs_num_fast.png")
