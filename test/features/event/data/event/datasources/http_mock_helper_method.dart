import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:mockito/mockito.dart';
import '../../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;


Uri setUpMockHttpClientSuccessDelayedResponse(
    String jsonPath, String endpoint, http.Client mockHttpClient,[Map<String,dynamic> queryParams]) {

  Uri uri;

  if(queryParams != null){
    uri = Uri.https(BASE_URL, endpoint, queryParams);
  }else {
    uri = Uri.https(BASE_URL, endpoint);
  }

  when(mockHttpClient.get(uri,
      headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
      .thenAnswer((_) async => Future.delayed(Duration(seconds: 8),() => http.Response(fixture(jsonPath), 200)));

  return uri;
}

Uri setUpMockHttpClientSuccessResponse(
    String jsonPath, String endpoint, http.Client mockHttpClient,[Map<String,dynamic> queryParams]) {

  Uri uri;

  if(queryParams != null){
    uri = Uri.https(BASE_URL, endpoint, queryParams);
  }else {
    uri = Uri.https(BASE_URL, endpoint);
  }

  when(mockHttpClient.get(uri,
      headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
      .thenAnswer((_) async => http.Response(fixture(jsonPath), 200));

  return uri;
}

void setUpMockHttpClientFailure404(String jsonPath, http.Client mockHttpClient) {
  when(mockHttpClient.get(any, headers: anyNamed('headers')))
      .thenAnswer((_) async => http.Response(fixture(jsonPath),404));
}

void setUpMockHttpClientException(String jsonPath,http.Client mockHttpClient){

  when(mockHttpClient.get(any,
      headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
      .thenThrow(ServerExceptions(message: SERVER_FAILURE_MESSAGE));
}

