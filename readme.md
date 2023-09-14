# Pocket C.H.I.P unfucker

This is a script and a series of fixes intended to restore basic funcionality on the now mostly busted image that was last created for the Pocket CHIP.
Very little of this is my original work, and this is mostly a compilation of fixes I've found and used from across the web that seem to work, made into one convenient script

When this is complete all you should have to do is:
```bash
curl sh.universe.dog/chip -o chip
chmod +x chip
bash chip
```
(note: this could be reduced down to `curl https://sh.universe.dog/chip | bash` but the above is made to avoid using keys that aren't accessibly before the keyboard is fixed)
For best results, please run this on a freshly flashed chip - good rule of thumb is that if you've managed to get the repos working, you probably don't need this.

Though, it really is NOT ready yet. I will let you know when it is!

# What does it do?

1. Backups system files that will be changed
2. Fixes the broken repos ( please note package security will have to be disabled but this is the world we live in with this stuff )
3. Fixes the Keyboard
4. Updates, Upgrades packages, and downloads a few required packages
5. Fixes the touchscreen
6. Optionally changes the hostname
7. Whatever else I can think of by the time I finish this project

# CREDITS
This is a compilation of work presented I found around the web:

## [a comprehensive guide to setting up a pocketchip](https://nytpu.com/gemlog/2021-04-15.gmi) by Alex
This is the post that got me closest to figuring out the repo situation, though it does seem to have become outdated in a few places.. It also contains the most easy to understand flashing instructions

## [NextThingCo Pocket C.H.I.P. Flashing Guide](https://medium.com/@0x1231/nextthingco-pocket-c-h-i-p-flashing-guide-3445492639e) by 0x1231
This post contained the most meat-and-potatoes of the content in this script - it contains the keyboard and touchscreen fixes which would have otherwise been quite a pain to cook up, and also served as the main inspriation for this little project

## [JF Possibilies Repo Mirror](http://chip.jfpossibilities.com/chip/debian/) by JF Possibilies
This whole shabang wouldn't be possible without the work done here, They are playing an essential role in keeping these things kicking by keeping a backup of the original repo up and running, and by hosting backups of the firmware images

## And more...
The work done in here is mostly a hodgepodge of random fixes I've found, above are the main sources, but I expect that I have missed a few spots from random reddit comments and forum posts, mixed in with some of my own work
