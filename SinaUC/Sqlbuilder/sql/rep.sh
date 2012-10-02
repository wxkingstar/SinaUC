#!/bin/bash
     for fl in *.php; do
     mv $fl $fl.old
     sed 's/operator/oper/g' $fl.old > $fl
     rm -f $fl.old
     done
