wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/fetools/work_area/frontend/Batch_10/sinchanabr/can_protocol_verification/src/waveform.fsdb}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top"
wvGetSignalSetScope -win $_nWave2 "/top/can_vif"
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
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
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
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
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("G1" 7)}
wvGetSignalClose -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
debExit
