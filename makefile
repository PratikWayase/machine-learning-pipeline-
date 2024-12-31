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

hf-login:
	git pull origin main
	pip install -U "huggingface_hub[cli]"
	huggingface-cli login --token $(HF)

push-hub:
	huggingface-cli upload Galaxyman/drug-classification ./App --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload Galaxyman/drug-classification ./Model/drug_pipeline.skops --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload Galaxyman/drug-classification ./Result/metrics.txt --repo-type=space --commit-message="Sync Model"

deploy: hf-login push-hub

all: install format train eval update-branch deploy