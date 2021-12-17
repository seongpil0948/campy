# 보안 강화를 위해 새 업로드 키를 생성합니다(선택사항)
# 각 버전당 pem?: https://support.google.com/googleplay/android-developer/answer/9842756?visit_id=637748270382978155-1095164401&rd=1#create
# 출시단계 appbundle 업로드 서명단계에서 변경되던데..
# keytool -export -rfc \
#     -keystore ../../campy_secret/upload-keystore.jks \
#     -alias CampyAndroidKey \
#     -file ../../campy_secret/output_upload_certificate.pem

# 비공개 키
# java -jar pepk.jar --keystore=/Users/sp/Codes/Camps/campy_secret/upload-keystore.jks --alias=CampyAndroidKey --output=output.zip --include-cert --encryptionkey=eb10fe8f7c7c9df715022017b00c6471f8ba8170b13049a11e6c09ffe3056a104a3bbe4ac5a955f4ba4fe93fc8cef27558a3eb9d2a529a2092761fb833b656cd48b9de6a

keytool -list -v  -keystore /Users/sp/Codes/Camps/campy_secret/upload-keystore.jks -alias CampyAndroidKey