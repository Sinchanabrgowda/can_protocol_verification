simSetSimulator "-vcssv" -exec \
           "/fetools/work_area/frontend/Batch_10/sinchanabr/can_protocol_verification/src/simv" \
           -args "-ucli +UVM_TESTNAME=can_frame_dut_ack_virtual_seq_test"
debImport "-dbdir" \
          "/fetools/work_area/frontend/Batch_10/sinchanabr/can_protocol_verification/src/simv.daidir"
debLoadSimResult \
           /fetools/work_area/frontend/Batch_10/sinchanabr/can_protocol_verification/src/waveform.fsdb
wvCreateWindow
verdiDockWidgetSetCurTab -dock widgetDock_<Inst._Tree>
srcHBSelect "top.can_vif" -win $_nTrace1
verdiDockWidgetSetCurTab -dock widgetDock_<Decl._Tree>
srcTBBTreeSelect -win $_nTrace1 -path "can_interface.can_bus"
srcTBBTreeSelect -win $_nTrace1 -path "can_interface.can_clk"
srcTBBTreeSelect -win $_nTrace1 -path "can_interface.can_bus"
srcTBBTreeSelect -win $_nTrace1 -path "can_interface.can_clk"
srcTBBTreeSelect -win $_nTrace1 -path "can_interface.can_clk"
srcTBBTreeSelect -win $_nTrace1 -path "can_interface.can_clk"
wvRenameGroup -win $_nWave2 {G1} {can_clk}
wvSelectGroup -win $_nWave2 {can_clk}
wvSetCursor -win $_nWave2 528.999071
wvSelectGroup -win $_nWave2 {can_clk}
wvSetCursor -win $_nWave2 3505.915414
wvSetCursor -win $_nWave2 155.587962
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvChangeDisplayAttr -win $_nWave2 -c ID_GREEN5 -lw 0 -ls solid
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif"
wvSetPosition -win $_nWave2 {("can_clk" 1)}
wvSetPosition -win $_nWave2 {("can_clk" 1)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"can_clk" \
{/top/can_vif/can_bus} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "can_clk" 1 )} 
wvSetPosition -win $_nWave2 {("can_clk" 1)}
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/MONITOR"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/DRIVER"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/driver_cb"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/monitor_cb"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/driver_cb"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/monitor_cb"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/driver_cb"
wvSetPosition -win $_nWave2 {("can_clk" 5)}
wvSetPosition -win $_nWave2 {("can_clk" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"can_clk" \
{/top/can_vif/can_bus} \
{/top/can_vif/driver_cb/can_bus} \
{/top/can_vif/driver_cb/can_irq} \
{/top/can_vif/driver_cb/can_tx} \
{/top/can_vif/driver_cb/ext_tx} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "can_clk" 2 3 4 5 )} 
wvSetPosition -win $_nWave2 {("can_clk" 5)}
wvGetSignalSetScope -win $_nWave2 "/top/can_vif/monitor_cb"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif"
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 3.383228 -snap {("can_clk" 1)}
wvSelectSignal -win $_nWave2 {( "can_clk" 1 )} 
wvSelectSignal -win $_nWave2 {( "can_clk" 1 2 )} 
wvSelectSignal -win $_nWave2 {( "can_clk" 1 2 3 )} 
wvSelectSignal -win $_nWave2 {( "can_clk" 1 2 3 4 )} 
wvSelectSignal -win $_nWave2 {( "can_clk" 1 2 3 4 5 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("can_clk" 0)}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top"
wvGetSignalSetScope -win $_nWave2 "/top/apb_vif"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif"
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"can_clk" \
{/top/can_vif/can_bus} \
{/top/can_vif/can_clk} \
{/top/can_vif/can_irq} \
{/top/can_vif/can_resetn} \
{/top/can_vif/can_rx} \
{/top/can_vif/can_tx} \
{/top/can_vif/ext_tx} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "can_clk" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvSetCursor -win $_nWave2 2.056273 -snap {("G2" 0)}
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"can_clk" \
{/top/can_vif/can_bus} \
{/top/can_vif/can_clk} \
{/top/can_vif/can_irq} \
{/top/can_vif/can_resetn} \
{/top/can_vif/can_rx} \
{/top/can_vif/can_tx} \
{/top/can_vif/ext_tx} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "can_clk" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"can_clk" \
{/top/can_vif/can_bus} \
{/top/can_vif/can_clk} \
{/top/can_vif/can_irq} \
{/top/can_vif/can_resetn} \
{/top/can_vif/can_rx} \
{/top/can_vif/can_tx} \
{/top/can_vif/ext_tx} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "can_clk" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("can_clk" 7)}
wvGetSignalClose -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 1947.802822 -snap {("can_clk" 4)}
wvSetCursor -win $_nWave2 1596.073179
wvSetCursor -win $_nWave2 31189.476435
wvSetCursor -win $_nWave2 14712.017186
wvSetCursor -win $_nWave2 1797.866204
wvSetCursor -win $_nWave2 10570.912296 -snap {("can_clk" 5)}
wvZoom -win $_nWave2 10572.208862 10722.610559
wvSetCursor -win $_nWave2 10654.629414 -snap {("G2" 0)}
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
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
debExit
