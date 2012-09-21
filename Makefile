SHELL=/bin/bash

local:
	./local_server.sh

setup:
	./setup.sh

import_menlo:
	PYTHONPATH=.. python data/processor.py

import_critiques:
	PYTHONPATH=.. python data/evals/conversion/eng.py data/evals/output/results_testing.txt

aggregate_data:
	PYTHONPATH=.. python data/aggregator.py all

init_data: import_menlo import_critiques aggregate_data

deploy:
	@if [ `whoami` = 'rmc' ]; then \
		./deploy.sh; \
	else \
		cat deploy.sh | ssh rmc sh; \
	fi

clean:
	find . -name '*.pyc' -delete
	rm -rf server/static/css
