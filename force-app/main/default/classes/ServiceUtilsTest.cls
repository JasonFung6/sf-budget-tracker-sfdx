/**
 * @test   This is a test comment not yet deployed to the org 4
 */
@isTest
public class ServiceUtilsTest {
    @isTest
    public static void testCorsHeaderAddedWhenInWhitelist() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/v1.0/someEndpoint';
        req.httpMethod = 'GET';
        req.addHeader('origin', 'http://localhost:3000');

        System.assert(!res.headers.containsKey('Access-Control-Allow-Origin'));

        ServiceUtils.handleCors(req, res);

        System.assertEquals(
            'http://localhost:3000',
            res.headers.get('Access-Control-Allow-Origin')
        );
    }

    @isTest
    public static void testCorsHeaderNotAddedWhenNotInWhitelist() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/v1.0/someEndpoint';
        req.httpMethod = 'GET';
        req.addHeader('origin', 'http://dodgy-origin.example.com');

        ServiceUtils.handleCors(req, res);

        System.assert(!res.headers.containsKey('Access-Control-Allow-Origin'));
    }
}