# Project #: Prolog

* Author: Broden Benson
* Class: CS354 
* Semester: Fall 2026

## Overview

This program does a few different things. meetone.pl finds individuals who can meet at given times. meet.pl
prints out compatible meeting times for Ann, Bob, and Carla. test.pl tests predicates I wrote.

## Reflection

This language is both fun and not fun at the same time. One moment you are on the top of the world 
writing simple predicates, doing some pattern matching, maybe even a little if then else statements 
and then you find a problem you don't know how to solve. For the first while of the assignment I would 
honestly look at it and then turn off my computer for the night and say "Thats a later me problem". It 
was just so confusing. I only managed to scrape my way to a solution for the meetone file after a few hours.
After that starting meet was a bit easier to do.
The bulk of meet went well. The overlap logic made sense after I drew some pictures of the problem. Once
I had overlaping figured out I went to actually write meet and realized I didn't know how to properly process
lists against my overlap logic. I struggled on this so long that I went to office hours and got help. I did eventually 
figure out a solution. Meet basically acts as a catalyst to get our first value. Then we have a second predicate in meet 
that takes that first value and tries to find an overlap. A simple solution but one that took me a very long time to figure
out. I love this language it is interesting, and it does things that I haven't seen before but it also is very hard to 
learn. Overall great assignment, a very enjoyable challenge.

## Compiling and Using

Before running make sure you chmod the file like so:
```bash
chmod +x <filename.pl>
```
Once executable you can simply run it like so:
```
./<filename.pl>
```
## Results

All of my tests pass. I couldn't figure out a good way to test meet, but all other
predicates are effectively working tested.

## Sources used
https://www.cs.cmu.edu/~fp/courses/15317-f17/lectures/15-prolog.pdf - most of this is over my head but still interesting
https://www.gprolog.org/manual/gprolog.html
https://stackoverflow.com/questions/64901531/how-to-read-from-a-list-in-gnu-prolog - found this from 5 years ago, not very helpful but interesting
https://stackoverflow.com/questions/2849045/if-in-prolog  - answer was for ISO prolog but much of this is universal between the two.


----------
