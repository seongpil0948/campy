import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, List<dynamic>>> loadPlaces() async {
  return (json.decode(
              await rootBundle.loadString('assets/mocks/camping_places.json'))
          as Map)
      .cast<String, List<dynamic>>();
}

class CampPlace {
  String? name;
  String? ctgr;
  String? latitude;
  String? longitude;
  String? roadAddr;
  String? jibeonAddr;
  String? campPhone;
  String? campManagePhone;
  String? numOfSites;
  String? areaSize;
  String? capacity;
  String? numOfParkingSpaces;
  String? convenienceFacility;
  String? safetyFacility;
  String? etcFacility;
  String? availHours;
  String? price;

  CampPlace.fromJson(Map<String, dynamic> j)
      : this.name = j['야영(캠핑)장명'] ?? null,
        this.ctgr = j['야영(캠핑)장구분'] ?? null,
        this.latitude = j['위도'] ?? null,
        this.longitude = j['경도'] ?? null,
        this.roadAddr = j['소재지도로명주소'] ?? null,
        this.jibeonAddr = j['소재지지번주소'] ?? null,
        this.campPhone = j['야영장전화번호'] ?? null,
        this.campManagePhone = j['관리기관전화번호'] ?? null,
        this.numOfSites = j['야영사이트수'] ?? null,
        this.areaSize = j['부지면적'] ?? null,
        this.capacity = j['1일최대수용인원수'] ?? null,
        this.numOfParkingSpaces = j['주차장면수'] ?? null,
        this.convenienceFacility = j['편의시설'] ?? null,
        this.safetyFacility = j['안전시설'] ?? null,
        this.etcFacility = j['기타부대시설'] ?? null,
        this.availHours = j['이용시간'] ?? null,
        this.price = j['이용요금'] ?? null;
}
