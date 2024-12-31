install:
	pip install --upgrade pip &&\
	pip install -r requirements.txt

format:
	black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	ls ./Result
	if [ -f ./Result/metrics.txt ]; then cat ./Result/metrics.txt >> report.md; fi
	echo "## Confusion Matrix Plot" >> report.md
	echo "![Confusion Matrix](./Result/model_results.png)" >> report.md

update-branch:
	git fetch origin &&\
	git checkout main &&\
	git pull origin main &&\
	git checkout - &&\
	git merge main
