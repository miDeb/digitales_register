import 'package:dr/utc_date_time.dart';
import 'package:flutter/material.dart';

import 'package:dr/l10n/l10n.dart' as l10n;

class LastFetchedOverlay extends StatelessWidget {
  final bool noInternet;
  final Widget child;
  final UtcDateTime? lastFetched;
  const LastFetchedOverlay({
    Key? key,
    required this.child,
    required this.noInternet,
    required this.lastFetched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lastFetched == null || !noInternet) {
      return child;
    }
    return RawLastFetchedOverlay(
      message:
          "${l10n.offlineModeActive()}. ${l10n.lastSynced()} ${formatTimeAgo(lastFetched!)}.",
      child: child,
    );
  }
}

class RawLastFetchedOverlay extends StatelessWidget {
  final String? message;
  final Widget child;
  const RawLastFetchedOverlay({
    Key? key,
    required this.message,
    required this.child,
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
  final String unit;
  final int howMany;
  if (diff.inDays >= 1) {
    howMany = diff.inDays;
    unit = l10n.formatDays(diff.inDays);
  } else if (diff.inHours >= 1) {
    howMany = diff.inHours;
    unit = l10n.formatHours(diff.inHours);
  } else if (diff.inMinutes >= 1) {
    howMany = diff.inMinutes;
    unit = l10n.formatMinutes(diff.inMinutes);
  } else {
    howMany = diff.inSeconds;
    unit = l10n.formatMinutes(diff.inSeconds);
  }
  return l10n.formatTimeAgo(howMany, unit);
}
