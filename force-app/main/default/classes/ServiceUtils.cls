/**
 * Helpers used across multiple outward-facing API service classes.
 * SOME COMMENT 2
 */
public with sharing class ServiceUtils {
    public static void handleCors(RestRequest req, RestResponse res) {
        String[] allowedOrigins = new List<String>{
            'http://localhost:3000',
            'https://staging-budget-tracker.netlify.app/',
            'https://production-budget-tracker.netlify.app/'
        };

        for (String headerName : req.headers.keySet()) {
            if (headerName.equalsIgnoreCase('origin')) {
                String origin = req.headers.get(headerName);
                if (allowedOrigins.contains(origin)) {
                    res.addHeader('Access-Control-Allow-Origin', origin);
                }
            }
        }
    }
}