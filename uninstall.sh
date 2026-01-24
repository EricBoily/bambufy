#!/bin/sh

CONF=/opt/config/printer.base.cfg

#uninstall g28_tenz
awk '
/^\[stepper_z\]/ {
    in_z = 1
    print
    next
}
/^\[/ && in_z {
    in_z = 0
    print
    next
}
/^\[/ && !in_z {
    print
    next
}
in_z && /position_endstop[[:space:]]*:/ {
    next
}
{ print }
' ${CONF} > tmp.cfg && \
awk '
/^\[stepper_z\]/ {
    print
    print "position_endstop: 220"
    next
}
{ print }
' tmp.cfg > ${CONF} && rm tmp.cfg && echo "Enable position_endstop in [stepper_z] printer.base.cfg"