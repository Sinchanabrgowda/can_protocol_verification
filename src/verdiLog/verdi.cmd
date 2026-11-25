simSetSimulator "-vcssv" -exec \
           "/fetools/work_area/frontend/Batch_10/sinchanabr/can_protocol_verification/src/simv" \
           -args "-ucli +UVM_TESTNAME=can_ext_frame_loopback_virtual_seq_test"
debImport "-dbdir" \
          "/fetools/work_area/frontend/Batch_10/sinchanabr/can_protocol_verification/src/simv.daidir"
debLoadSimResult \
           /fetools/work_area/frontend/Batch_10/sinchanabr/can_protocol_verification/src/waveform.fsdb
wvCreateWindow
verdiDockWidgetSetCurTab -dock widgetDock_<Inst._Tree>
srcHBSelect "top.can_vif" -win $_nTrace1
verdiDockWidgetSetCurTab -dock widgetDock_<Decl._Tree>
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif"
wvSetPosition -win $_nWave2 {("G1" 6)}
wvSetPosition -win $_nWave2 {("G1" 6)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/top/can_vif/can_bus} \
{/top/can_vif/can_clk} \
{/top/can_vif/can_resetn} \
{/top/can_vif/can_rx} \
{/top/can_vif/can_tx} \
{/top/can_vif/ext_tx} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 )} 
wvSetPosition -win $_nWave2 {("G1" 6)}
wvSetPosition -win $_nWave2 {("G1" 6)}
wvSetPosition -win $_nWave2 {("G1" 6)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/top/can_vif/can_bus} \
{/top/can_vif/can_clk} \
{/top/can_vif/can_resetn} \
{/top/can_vif/can_rx} \
{/top/can_vif/can_tx} \
{/top/can_vif/ext_tx} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 )} 
wvSetPosition -win $_nWave2 {("G1" 6)}
wvGetSignalClose -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 4739.727575 -snap {("G1" 2)}
wvSetCursor -win $_nWave2 2085.480133 -snap {("G1" 2)}
debExit
