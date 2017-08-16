.PHONY: x, run, clean-1, clean-2, clean-3

x:
	@echo "There is no default make target. Use 'make run' to run the SLURM pipeline."

run:
	slurm-pipeline.py -s specification.json > status.json

# Keep a clean-1 target to match what we have in other pipeline Makefiles.
clean-1:
	@echo Nothing to do for clean-1

# Remove intermediate files.
clean-2: clean-1
	rm -f 01-panel/*.out

# Remove *all* intermediates, including the final panel output.
clean-3: clean-2
	rm -fr \
               01-panel/out \
               01-panel/summary-virus \
               01-panel/summary-proteins \
               slurm-pipeline.done \
               *.log \
               status.json
