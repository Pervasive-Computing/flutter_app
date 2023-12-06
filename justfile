buildmode := "--release"

default:
    just --list
    just --variables


system-info:
	@echo "This is an {{arch()}} machine".
	@echo "It has {{num_cpus()}} logical CPUs"
	@echo "Operating System is {{os()}}"
	
run mode='--debug':
	flutter run --device-id {{os()}} {{mode}}

