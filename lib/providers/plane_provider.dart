import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/container.dart';
import '../models/aircraft.dart';
import '../models/plane.dart';

class PlaneState {
  final LoadingSequence? inboundSequence;
  final LoadingSequence? outboundSequence;
  final List<LoadingSequence> configs;
  final List<StorageContainer?> inboundSlots;
  final List<StorageContainer?> outboundSlots;
  final List<StorageContainer?> lowerInboundSlots;
  final List<StorageContainer?> lowerOutboundSlots;

  PlaneState({
    required this.inboundSequence,
    required this.outboundSequence,
    required this.configs,
    required this.inboundSlots,
    required this.outboundSlots,
    required this.lowerInboundSlots,
    required this.lowerOutboundSlots,
  });

  PlaneState copyWith({
    LoadingSequence? inboundSequence,
    LoadingSequence? outboundSequence,
    List<LoadingSequence>? configs,
    List<StorageContainer?>? inboundSlots,
    List<StorageContainer?>? outboundSlots,
    List<StorageContainer?>? lowerInboundSlots,
    List<StorageContainer?>? lowerOutboundSlots,
  }) {
    return PlaneState(
      inboundSequence: inboundSequence ?? this.inboundSequence,
      outboundSequence: outboundSequence ?? this.outboundSequence,
      configs: configs ?? this.configs,
      inboundSlots: inboundSlots ?? this.inboundSlots,
      outboundSlots: outboundSlots ?? this.outboundSlots,
      lowerInboundSlots: lowerInboundSlots ?? this.lowerInboundSlots,
      lowerOutboundSlots: lowerOutboundSlots ?? this.lowerOutboundSlots,
    );
  }
}

class PlaneNotifier extends StateNotifier<PlaneState> {
  PlaneNotifier()
    : super(
        PlaneState(
          inboundSequence: null,
          outboundSequence: null,
          configs: const [],
          inboundSlots: const [],
          outboundSlots: const [],
          lowerInboundSlots: const [],
          lowerOutboundSlots: const [],
        ),
      );

  void loadPlane(Plane plane, [List<LoadingSequence> configs = const []]) {
    final inboundSequence = LoadingSequence(
      plane.inboundSequenceLabel ?? '',
      plane.inboundSequenceLabel ?? '',
      plane.inboundSequenceOrder,
    );
    final outboundSequence = LoadingSequence(
      plane.outboundSequenceLabel,
      plane.outboundSequenceLabel,
      plane.outboundSequenceOrder,
    );
    state = PlaneState(
      inboundSequence: inboundSequence,
      outboundSequence: outboundSequence,
      configs: configs,
      inboundSlots: List.from(plane.inboundSlots),
      outboundSlots: List.from(plane.outboundSlots),
      lowerInboundSlots: List.from(plane.lowerInboundSlots),
      lowerOutboundSlots: List.from(plane.lowerOutboundSlots),
    );
  }

  Plane exportPlane(Plane original) {
    return Plane(
      id: original.id,
      name: original.name,
      aircraftTypeCode: original.aircraftTypeCode,
      inboundSequenceLabel:
          state.inboundSequence?.label ?? original.inboundSequenceLabel,
      inboundSequenceOrder:
          state.inboundSequence?.order ?? original.inboundSequenceOrder,
      inboundSlots: List.from(state.inboundSlots),
      outboundSequenceLabel:
          state.outboundSequence?.label ?? original.outboundSequenceLabel,
      outboundSequenceOrder:
          state.outboundSequence?.order ?? original.outboundSequenceOrder,
      outboundSlots: List.from(state.outboundSlots),
      lowerInboundSlots: List.from(state.lowerInboundSlots),
      lowerOutboundSlots: List.from(state.lowerOutboundSlots),
    );
  }

  void selectSequence(LoadingSequence sequence, {required bool outbound}) {
    final newSlots = List<StorageContainer?>.filled(
      sequence.order.length,
      null,
    );
    Future.microtask(() {
      if (outbound) {
        state = state.copyWith(
          outboundSequence: sequence,
          outboundSlots: newSlots,
        );
      } else {
        state = state.copyWith(
          inboundSequence: sequence,
          inboundSlots: newSlots,
        );
      }
    });
  }

  void placeContainer(
    int index,
    StorageContainer container, {
    required bool outbound,
  }) {
    if (outbound) {
      final updatedSlots = [...state.outboundSlots];
      updatedSlots[index] = container;
      state = state.copyWith(outboundSlots: updatedSlots);
    } else {
      final updatedSlots = [...state.inboundSlots];
      updatedSlots[index] = container;
      state = state.copyWith(inboundSlots: updatedSlots);
    }
  }

  void removeContainer(StorageContainer container, {required bool outbound}) {
    if (outbound) {
      final updatedSlots = [
        for (final slot in state.outboundSlots)
          if (slot?.id == container.id) null else slot,
      ];
      state = state.copyWith(outboundSlots: updatedSlots);
    } else {
      final updatedSlots = [
        for (final slot in state.inboundSlots)
          if (slot?.id == container.id) null else slot,
      ];
      state = state.copyWith(inboundSlots: updatedSlots);
    }
  }

  void placeLowerDeckContainer(
    int index,
    StorageContainer container, {
    required bool outbound,
  }) {
    if (outbound) {
      final updated = [...state.lowerOutboundSlots];
      updated[index] = container;
      state = state.copyWith(lowerOutboundSlots: updated);
    } else {
      final updated = [...state.lowerInboundSlots];
      updated[index] = container;
      state = state.copyWith(lowerInboundSlots: updated);
    }
  }

  void removeLowerDeckContainer(
    StorageContainer container, {
    required bool outbound,
  }) {
    if (outbound) {
      final updated = [
        for (final slot in state.lowerOutboundSlots)
          if (slot?.id == container.id) null else slot,
      ];
      state = state.copyWith(lowerOutboundSlots: updated);
    } else {
      final updated = [
        for (final slot in state.lowerInboundSlots)
          if (slot?.id == container.id) null else slot,
      ];
      state = state.copyWith(lowerInboundSlots: updated);
    }
  }
}

final planeProvider = StateNotifierProvider<PlaneNotifier, PlaneState>(
  (ref) => PlaneNotifier(),
);

/// Tracks wether the Plane page is showing the outbound view.
final isOutboundProvider = StateProvider<bool>((ref) => false);
