import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

const kMainColor = Color(0xffE81E2A);
const kRedColor = Color(0xffE81E2A);
const kOpenColor = Color(0xffeabca2);
const kWhitColor = Color(0xffffffff);
const kBackColor = Color(0xFFE0DEDB);
const Color appRecentColor = Color(0xFFFFFFFF);

final box = GetStorage();

//String api = 'https://7bb9-94-57-121-144.ngrok-free.app/api/';
String api = 'https://panoramahome.ae/api/';
String api_image = 'https://panoramahome.ae/';

//Stripe Payment
String publishkey='pk_test_51N3apxLxtvuwVGTO1RC0LSjLyyErzZxbghisF57S5wfzJLpHFBjXtDxvsVVRlpioCQbiL3zJjHx5hMPLCm0jzId1004oUhhfrh';
String SECRET_KEY = 'sk_test_51N3apxLxtvuwVGTOl5w9sx5AyhznbQjjuz6SkjOrT22wZkgBmYWuUcAKrgCk4uqdhuhcDJZgFl2J8N3Qve2ezSRT006baXrN1H';

//Tamara Payment
String tamara_api = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiJlY2U5ZjljOS1lYzBkLTRjN2QtYmY4NS1hYzljNWU4M2QyMzgiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiMTc4NTI5NzIyOTY0YTEzNDc4MWNmMmVmNWQ0ZDcxZWEiLCJyb2xlcyI6WyJST0xFX01FUkNIQU5UIl0sImlhdCI6MTY5NDIwMDkwMCwiaXNzIjoiVGFtYXJhIn0.JirhD0fbGwCJvvDEbyQCJOlCN2agnsixlHjDcU-tLjHnMHNQZKJiEC58gbFR--V4-_Sqr_WhTwzmugPtb4Kh5P8kXSKqKyNQ3b_1TqaZPcA7HQj7JdcEleD-CQbMExQ2rTGAdfVpk60UOj2ZDRv-ytxcW0PY4GQ0UhBjA67kBm13r9rJpTaCgFb6T56SJYbkvtFteDmDAGsYrgDnawGz3NC-jzhdVQ-f9W2rbAsC2iWt4jMB1cynQPZRScwJVsbLhto68ArtohMzvDSNuIZW9IrBJdK6mzRgIL81q0M8B1V8Fg-guUJ4fNwunNHSfdEuwWic3JU114bq_8nO5dnwog';

var slideShowList = [
  "assets/images/img1.jpg",
  "assets/images/img2.jpg",
  "assets/images/img3.jpg",
  "assets/images/img4.jpg",
  "assets/images/img5.jpg",
];