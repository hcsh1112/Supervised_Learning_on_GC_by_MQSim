CC        := g++
LD        := g++
CC_FLAGS := -std=c++11 -O3 -g

MODULES   := exec host nvm_chip nvm_chip/flash_memory sim ssd utils ext
SRC_DIR   := $(MODULES) 
BUILD_DIR := $(addprefix build/,$(MODULES)) build

SRC       := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.cpp))
SRC       := main.cpp $(SRC)
OBJ       := $(patsubst %.cpp,build/%.o,$(SRC) )
INCLUDES  := $(addprefix -I,$(SRC_DIR)) -I/usr/include/python3.5m -I/usr/include/python3.5m

vpath %.cpp $(SRC_DIR)

define make-goal
$1/%.o: %.cpp
	$(CC) $(CC_FLAGS) $(INCLUDES) -c $$< -o $$@
endef

.PHONY: all checkdirs clean

all: checkdirs MQSim

CP:
	cp ./src/build/temp.linux-x86_64-3.5/model.o ./build/model.o

MQSim: $(OBJ)
	$(LD) $(CC_FLAGS) $^ -o $@ -lpython3.5m -lpthread -ldl -lutil -lm  ./model.cpython-35m-x86_64-linux-gnu.so 

checkdirs: $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)
	rm -f MQSim

$(foreach bdir,$(BUILD_DIR),$(eval $(call make-goal,$(bdir))))
