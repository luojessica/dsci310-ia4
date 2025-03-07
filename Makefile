# author: Jordan Bourak & Tiffany Timbers
# date: 2021-11-22

all: results/horse_pop_plot_largest_sd.png \
	results/horse_pops_plot.png \
	results/horses_spread.csv \
	docs/qmd_example.html \
	docs/qmd_example.pdf



# generate figures and objects for report
results/horse_pop_plot_largest_sd.png results/horse_pops_plot.png results/horses_spread.csv: source/generate_figures.R
	Rscript source/generate_figures.R --input_dir="data/00030067-eng.csv" \
		--out_dir="results"

# render quarto report in HTML and PDF
docs/qmd_example.html: results reports/qmd_example.qmd 
	quarto render reports/qmd_example.qmd --to html --output-dir="$(PWD)/docs"

docs/qmd_example.pdf: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to pdf  --output-dir="$(PWD)/docs"

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
