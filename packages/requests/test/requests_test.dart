import 'package:dr/requests/lib/requests.dart';
import 'package:test_api/test_api.dart';

void main() {
  group('A group of tests', () {
    final requests = Requests();
    test('plain http get', () async {
      String body = await requests.get("https://google.com");
      expect(body, isNotNull);
    }, skip: "fails");

    test('json http get list of objects', () async {
      dynamic body = await requests
          .get("https://jsonplaceholder.typicode.com/posts", json: true);
      expect(body, isNotNull);
      expect(body, isList);
    });

    test('json http post', () async {
      await requests.post("https://jsonplaceholder.typicode.com/posts", body: {
        "userId": 10,
        "id": 91,
        "title": "aut amet sed",
        "body":
            "libero voluptate eveniet aperiam sed\nsunt placeat suscipit molestias\nsimilique fugit nam natus\nexpedita consequatur consequatur dolores quia eos et placeat",
      });
    });

    test('json http get object', () async {
      dynamic body = await requests
          .get("https://jsonplaceholder.typicode.com/posts/1", json: true);
      expect(body, isNotNull);
      expect(body, isMap);
    });

    test('remove cookies', () async {
      String url = "https://jsonplaceholder.typicode.com/posts/1";
      String hostname = requests.getHostname(url);
      expect("jsonplaceholder.typicode.com", hostname);
      await requests.clearStoredCookies(hostname);
      await requests.setStoredCookies(hostname, {'session': 'bla'});
      var cookies = await requests.getStoredCookies(hostname);
      expect(cookies.keys.length, 1);
      await requests.clearStoredCookies(hostname);
      cookies = await requests.getStoredCookies(hostname);
      expect(cookies.keys.length, 0);
    });
  });
}
