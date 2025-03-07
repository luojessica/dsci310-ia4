# author: Jordan Bourak & Tiffany Timbers
# date: 2021-11-22

all: results/horse_pop_plot_largest_sd.png \
	results/horse_pops_plot.png \
	results/horses_spread.csv \
	reports/qmd_example.html \
	reports/qmd_example.pdf



# generate figures and objects for report
results/horse_pop_plot_largest_sd.png results/horse_pops_plot.png results/horses_spread.csv: source/generate_figures.R
	Rscript source/generate_figures.R --input_dir="data/00030067-eng.csv" \
		--out_dir="results"

# render quarto report in HTML and PDF
reports/qmd_example.html: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to html

reports/qmd_example.pdf: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to pdf

index.html: reports/report.qmd
	quarto render reports/qmd_example.qmd --to html --output index.html
	mv index.html docs/index.html

docs/images: docs
	mkdir -p docs/images

# Copy images into docs/images
docs/images/horse_pop_plot_largest_sd.png: results/horse_pop_plot_largest_sd.png | docs/images
	cp results/horse_pop_plot_largest_sd.png docs/images/

docs/images/horse_pops_plot.png: results/horse_pops_plot.png | docs/images
	cp results/horse_pops_plot.png docs/images/

# Ensure images are included in the build
all: docs/images/horse_pop_plot_largest_sd.png \
     docs/images/horse_pops_plot.png

# clean
clean:
	rm -rf results
	rm -rf reports/qmd_example.html \
		reports/qmd_example.pdf \
		reports/qmd_example_files
