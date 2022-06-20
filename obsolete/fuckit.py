#!/usr/bin/env python

import glob
from pathlib import Path

def rename_disc(disc, cue):
  with open(cue) as f:
    for l in f:
      if "FILE" not in l:
        continue

      name = l.strip("FILE \"").rstrip("\" WAVE\n")
      match = glob.glob(f"{disc}/{glob.escape('[' + name[0] + name[2:4] + ']')}*.flac")
      if not len(match):
        print(f"! {name}")
        continue

      fr = Path(match[0])
      to = Path(disc, f"{name[:-4]}.flac")
      print(f"{str(fr).ljust(115)} -> {to}")
      fr.rename(to)

rename_disc("Disc 1", "Walking Wounded (Deluxe Edition) Disc 1.cue")
rename_disc("Disc 2", "Walking Wounded (Deluxe Edition) Disc 2.cue")




