

sine: sinegen.py
	python $^

progsine: sine_np2.bin
	iceprog -o 1M $^

clean:
	rm -f sine_np2.bin
