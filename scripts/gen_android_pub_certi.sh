cd android
keytool -export -rfc \
    -keystore ../../campy_secret/upload-keystore.jks \
    -alias CampyAndroidKey \
    -file ../../campy_secret/output_upload_certificate.pem

    
