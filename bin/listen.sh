mosquitto_sub --cert ./cfg/pub.crt --key ./cfg/pub.key --cafile ./cfg/RootCA.crt -h badass.home -t RES/# -u pub -P pub &
mosquitto_sub --cert ./cfg/pub.crt --key ./cfg/pub.key --cafile ./cfg/RootCA.crt -h badass.home -t DATA/# -u pub -P pub &

