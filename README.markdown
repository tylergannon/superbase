# SuperBase!!

Simple Database as described in Thumbtack's [Job Posting](http://www.thumbtack.com/challenges)

##  To run:

    git clone git://github.com/tylergannon/superbase.git
    cd superbase
    ruby bin/superbase.rb
    
see http://www.thumbtack.com/challenges for the user manual.  :)

##  The Hax0r'd Search Tree

* I don't know the great search tree algorithms by heart, so I haxored this from scratch.
* It should perform better than *O(n)* but perhaps not as well as a Red-Black tree would.
    *  Especially on certain nodes where the depth could get somewhat large.

The search tree creates a node for each character in the stored key, so each operation should require
a worst case of `36 * n` character comparisons, for an n-character key.

I didn't take the time to benchmark it against the ruby Hash or against an RB Tree implementation.

On that note: *you mentioned the spirit of maintainability and extensibility.*
I think it's worth saying I broke a cardinal rule of maintainability, by not installing an RBTree gem
and just going with that.  ;-)  Just wanted to put it out there, in working with you I won't reinvent the
wheel when possible.

## More About Maintainability and Extensibility

My strategy with both is to stress test-first development, and KISS (Keep It Simple, Stupid)

This app is as simple as possible... no patterns, no extracted classes.  Not until the next requirements surface.

## Copyright

Copyright (c) 2013 Tyler Gannon. 
