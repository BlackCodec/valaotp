#!/bin/bash
pass_resource="${1}"
pass_data=$(pass "${pass_resource}" | grep "otpauth")
otptool "${pass_data}"
exit 0
