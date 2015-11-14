Exploring image corpora with t-SNE
==================================

This is a collection of small scripts that lay out images on a two
dimensional map in a way which sort of reflects their similarity
(according to one measure of similarity). There is also a script to
fetch images in the first place, for which you need a Digital-NZ api
key.

The `Makefile` sort of describes the various steps. Most of the
scripts should respond properly to `--help`.

## Instructions (recited from memory)

You can probably skip many of these steps because `make` will work it
out for you. Probably. I am not checking.

### Get some images

And put them in `images/`. The script `fetch/digital-nz` will do it if
you have a Digital NZ api key.

### See what shapes your images are

This is not strictly necessary, but is probably interesting.

    ./sort-by-shape -e jpg -H

### Sort your images into collections

The three collections are `landscape`, `square`, and `portrait`, named
after their aspect ratios. You can do this with:

    make collections/square-filelist.json

which actually makes the other collection file lists too (using
`sort-by-shape`).

Note that off-square images might be in both the square and another
collection, and this is completely OK.

### Extract features

Do something like

    make features/square.csv

after which `features/square.csv` will contain 400 numbers for each
image. There are no names or IDs in this files, but the order of the
images is the same as in `collections/square-filelist.json`.

### Do the t-SNE

This reduces the 400 numbers down to 2:

    make maps-2d/square.csv

### Convert the coordinates to JSON

This merges the coordinates from the 2d map csv back with the image
names.

    make datasets/square.json

### Look at the results

You need to start a web server because the javascript doesn't like
referring to local files. Out of habit I used `webfsd`:

    # possibly:
    sudo apt-get install webfs
    webfsd
    chromium 127.0.0.1:8000/tsne.html

    # tidy up
    killall webfsd

Chromium works better than Firefox/Iceweasel.


## prerequisites

This software uses
[py_bh_tsne](https://github.com/douglasbagnall/py_bh_tsne),
and probably other things.

## License

You can use this code under the GPL, version 2 or greater.
