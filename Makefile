# author: Jordan Bourak & Tiffany Timbers
# date: 2021-11-22

all: results/horse_pop_plot_largest_sd.png \
	results/horse_pops_plot.png \
	results/horses_spread.csv \
	docs/qmd_example.html \
	docs/qmd_example.pdf \
	docs/index.html \
	docs/images/horse_pop_plot_largest_sd.png \
    docs/images/horse_pops_plot.png \
	docs/.nojekyll

# generate figures and objects for report
results/horse_pop_plot_largest_sd.png results/horse_pops_plot.png results/horses_spread.csv: source/generate_figures.R
	Rscript source/generate_figures.R --input_dir="data/00030067-eng.csv" \
		--out_dir="results"

# ensure docs/ exists before rendering
docs:
	mkdir -p docs

# render quarto report in HTML and PDF
docs/qmd_example.html: results reports/qmd_example.qmd docs/.nojekyll
	quarto render reports/qmd_example.qmd --to html --output-dir="$(PWD)/docs"

docs/qmd_example.pdf: results reports/qmd_example.qmd docs/.nojekyll
	quarto render reports/qmd_example.qmd --to pdf  --output-dir="$(PWD)/docs"

# create index.html as a copy of qmd_example.html
docs/index.html: docs/qmd_example.html
	cp docs/qmd_example.html docs/index.html

# Ensure docs/images exists
docs/images: docs
	mkdir -p docs/images

# Copy images into docs/images
docs/images/horse_pop_plot_largest_sd.png: results/horse_pop_plot_largest_sd.png | docs/images
	cp results/horse_pop_plot_largest_sd.png docs/images/

docs/images/horse_pops_plot.png: results/horse_pops_plot.png | docs/images
	cp results/horse_pops_plot.png docs/images/

# create .nojekyll to disable Jekyll processing on GitHub Pages
docs/.nojekyll: docs
	touch docs/.nojekyll

# clean
clean:
	rm -rf results
	rm -rf reports/qmd_example.html \
		reports/qmd_example.pdf \
		reports/qmd_example_files
	rm -rf reports/docs
	rm -rf docs
	rm -rf reports/docs/qmd_example.html \
		reports/docs/qmd_example.pdf
