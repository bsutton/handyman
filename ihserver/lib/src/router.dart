import 'package:shelf_router/shelf_router.dart';

import 'handle_booking.dart';
import 'handle_starts.dart';
import 'handle_static.dart';

Router buildRouter() {
  final router =
      Router()
        ..get('/', handleDefault)
        ..get('/start', handleStart)
        ..get('/css/<.*>', handleStatic)
        ..get('/js/<.*>', handleStatic)
        ..get('/images/<.*>', handleStatic)
        ..get('/images/samples/<.*>', handleStatic)
        ..get('/<*.html>', handleStatic)
        ..get('/hmb/<*.html>', handleStatic)
        // validates deep links used by the hmb app.
        ..get('/.well-known/assetlinks.json', handleStatic)
        // New route for the start records page.
        ..post('/booking', handleBooking);
  return router;
}
