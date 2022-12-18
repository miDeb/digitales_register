import 'package:dr/utc_date_time.dart';
import 'package:flutter/material.dart';

class LastFetchedOverlay extends StatelessWidget {
  final bool noInternet;
  final Widget child;
  final UtcDateTime? lastFetched;
  const LastFetchedOverlay({
    super.key,
    required this.child,
    required this.noInternet,
    required this.lastFetched,
  });

  @override
  Widget build(BuildContext context) {
    if (lastFetched == null || !noInternet) {
      return child;
    }
    return RawLastFetchedOverlay(
      message:
          "Offline-Modus aktiv. Zuletzt synchronisiert ${formatTimeAgo(lastFetched!)}.",
      child: child,
    );
  }
}

class RawLastFetchedOverlay extends StatelessWidget {
  final String? message;
  final Widget child;
  const RawLastFetchedOverlay({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return child;
    }
    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 8,
            ).copyWith(right: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              message!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

String formatTimeAgo(UtcDateTime dateTime) {
  final diff = UtcDateTime.now().difference(dateTime);
  if (diff.inDays >= 1) {
    return "vor ${diff.inDays} ${diff.inDays == 1 ? "Tag" : "Tagen"}";
  } else if (diff.inHours >= 1) {
    return "vor ${diff.inHours} ${diff.inHours == 1 ? "Stunde" : "Stunden"}";
  } else if (diff.inMinutes >= 1) {
    return "vor ${diff.inMinutes} ${diff.inMinutes == 1 ? "Minute" : "Minuten"}";
  } else {
    return "vor ${diff.inSeconds} ${diff.inSeconds == 1 ? "Sekunde" : "Sekunden"}";
  }
}
