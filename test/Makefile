# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
FST ?= -fst # Use more efficient FST format
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = \
mux_2_1.v \
mux_3_1.v \
mux_4_1.v \
encryption_rotation.v \
encryption_rotation_top.v \
decryption_rotation.v \
decryption_rotation_top.v \
xor.v \
round_registers.v \
round_function_top.v \
key_rotation_enc.v \
top_key_rotation_enc.v \
key_rotation_dec.v \
top_key_rotation_dec.v \
key_registers.v \
key_registers_top.v \
constant_generator.v \
constant_generator_top.v \
modular_subtraction.v \
modular_addition.v \
key_schedule_top.v \
lea_128_core.v \
counter_5_bits.v \
counter_2_bits.v \
state_machine.v \
logical_unit_top.v \
processed_data_storage.v \
lea_128_top.v \
input_handshake.v \
output_handshake.v \
tt_um_jct_lea_128.v

ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD				= sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate level simulation:
SIM_BUILD				= sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog/gf180mcu_fd_sc_mcu7t5v0.v

# this gets copied in by the GDS action workflow
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Allow sharing configuration between design and testbench via `include`:
COMPILE_ARGS 		+= -I$(SRC_DIR)

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# List test modules to run, separated by commas and without the .py suffix:
COCOTB_TEST_MODULES = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
