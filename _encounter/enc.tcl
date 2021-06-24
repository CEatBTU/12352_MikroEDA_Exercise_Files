set init_lef_file lef/NangateOpenCellLibrary.lef
set init_lib_file lib/NangateOpenCellLibrary_typical_conditional_ccs.lib
set init_sdc_file ../lib/sdc/mult.sdc
set init_verilog verilog_input/mult_rtl_synth_tech_mapped.v
set init_gnd_net VSS
set init_pwr_net VDD
set init_design_settop 0
set init_top_cell mult_rtl
set init_mmmc_file MMMC.tcl

setDesignMode -process 45

init_design
win

# set floorplan margins and core utilization
setFPlanRowSpacingAndType 1.0 1
floorPlan -site NCSU_FreePDK_45nm -r 0.997514498757 0.699948 10.0 10.0 10.0 10.0
fit

# set global nets
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *

# set power rings
#addRing -stacked_via_top_layer metal10 -around core -jog_distance 0.095 -threshold 0.095 -nets {GND VDD} -stacked_via_bottom_layer metal1 -layer {bottom metal1 top metal1 right metal2 left metal2} -width 0.8 -spacing 0.8 -offset 0.095
#@rsegabinazzi
addRing -stacked_via_top_layer metal10  -follow core -type core_rings -jog_distance 0.095 -threshold 0.095 -nets {VSS VDD} -stacked_via_bottom_layer metal1 -layer {bottom metal1 top metal1 right metal2 left metal2} -width 0.8 -spacing 0.8 -offset 0.095


# set power stripes
#addStripe -block_ring_top_layer_limit metal3 -max_same_layer_jog_length 1.6 -padcore_ring_bottom_layer_limit metal1 -set_to_set_distance 5 -stacked_via_top_layer metal10 -padcore_ring_top_layer_limit metal3 -spacing 0.8 -merge_stripes_value 0.095 -layer metal2 -block_ring_bottom_layer_limit metal1 -width 0.8 -nets {GND VDD} -stacked_via_bottom_layer metal1
#@rsegabinazzi
addStripe -block_ring_top_layer_limit metal3 -max_same_layer_jog_length 1.6 -padcore_ring_bottom_layer_limit metal1 -set_to_set_distance 5 -stacked_via_top_layer metal10 -padcore_ring_top_layer_limit metal3 -spacing 0.8 -merge_stripes_value 0.095 -layer metal2 -block_ring_bottom_layer_limit metal1 -width 0.8 -nets {VSS VDD} -stacked_via_bottom_layer metal1

## set multiple threads option to speed up placement process
#setReleaseMultiCpuLicense 0
#setMultiCpuUsage -numThreads 4 -numHosts 1 -superThreadsNumThreads 1 -superThreadsNumHosts 1


## run placement of required design cells
placeDesign -inPlaceOpt -prePlaceOpt

# add filler objects
getFillerMode -quiet
findCoreFillerCells
addFiller -cell FILLCELL_X8 FILLCELL_X4 FILLCELL_X32 FILLCELL_X2 FILLCELL_X16 FILLCELL_X1 -prefix FILLER -markFixed

# special route for VDD and VSS
##sroute -jogControl { preferWithChanges differentLayer }
#sroute -allowJogging 1 -allowLayerChange 1 

#Routing using NanoRoute
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail 


## post route timing analysis
setAnalysisMode -analysisType onChipVariation -cppr both
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix mult_rtl_fixed_point_postRoute -outDir timingReports


## export verilog netlist with clk buffers and possible re-powering structuress
saveNetlist verilog_output/mult_synth_logic_flatten_layout.v

## export SDF file for delay simulation
#delayCal -sdf verilog_output/mult_synth_logic_flatten_layout.sdf
write_sdf verilog_output/mult_synth_logic_flatten_layout.sdf



