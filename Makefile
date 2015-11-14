data_dirs = features names thumbnails

$(data_dirs):
	mkdir -p $@

.PHONY: get-some-images

get-some-images:
	fetch/digital-nz -s 100 -d 0.05 -n 10000

features/landscape.csv: collections/landscape-filelist.json $(data_dirs)
	./extract-image-features -c $< -d $@ -D names/landscape.txt -H16 -W25 \
	     --margin-height 0.04 --margin-width 0.06 --big-thumbnails


features/portrait.csv: collections/portrait-filelist.json  $(data_dirs)
	./extract-image-features -c $< -d $@ -D names/portrait.txt -W16 -H25 \
	      --margin-width 0.04 --margin-height 0.06 --big-thumbnails


features/square.csv: collections/square-filelist.json  $(data_dirs)
	./extract-image-features -c $< -d $@ -D names/square.txt -W20 -H20 \
	      --margin-width 0.05 --margin-height 0.05 --big-thumbnails

names/%.txt: features/%.csv
	stat $@

collections/%-filelist.json:
	mkdir -p  $(@D)
	./sort-by-shape -e jpg --min-size=100 --limit 5000 --max-size=500


maps-2d/%.csv: features/%.csv
	mkdir -p  $(@D)
	./tsne -i $< -o $@ -p50 --no-figure

datasets/%.json: maps-2d/%.csv names/%.txt
	mkdir -p  $(@D)
	./compose-json-dataset -i $*

.PRECIOUS: maps-2d/%.csv features/%.csv names/%.txt

# reduce `make -d` noise
%: %,v
%: RCS/%,v
%: RCS/%
%: s.%
%: SCCS/s.%
