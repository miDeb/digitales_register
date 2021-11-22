import 'package:dr/utc_date_time.dart';
import 'package:flutter/material.dart';

class LastFetchedOverlay extends StatelessWidget {
  final bool noInternet;
  final Widget child;
  final UtcDateTime? lastFetched;
  final double rightPadding;
  const LastFetchedOverlay({
    Key? key,
    required this.child,
    required this.noInternet,
    required this.lastFetched,
    this.rightPadding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lastFetched == null || !noInternet) {
      return child;
    }
    return RawLastFetchedOverlay(
      message:
          "Offline-Modus aktiv. Zuletzt synchronisiert ${formatTimeAgo(lastFetched!)}.",
      rightPadding: rightPadding,
      child: child,
    );
  }
}

class RawLastFetchedOverlay extends StatelessWidget {
  final String? message;
  final Widget child;
  final double rightPadding;
  const RawLastFetchedOverlay({
    Key? key,
    required this.message,
    required this.child,
    this.rightPadding = 0,
  }) : super(key: key);

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
            ).copyWith(right: 8 + rightPadding),
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
  if (diff.inDays > 1) {
    return "vor ${diff.inDays} Tagen";
  } else if (diff.inHours > 1) {
    return "vor ${diff.inHours} Stunden";
  } else if (diff.inMinutes > 1) {
    return "vor ${diff.inMinutes} Minuten";
  } else {
    return "vor ${diff.inSeconds} Sekunden";
  }
}
