

sine_np2.bin: sinegen.py
	python $^

sineprog: sine_np2.bin
	iceprog -p -o  1M $^

clean:
	rm -f sine_np2.bin
