// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assignment_mapsense/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:assignment_mapsense/views/history_view/bloc/history_bloc.dart';
import 'package:assignment_mapsense/views/map_view/bloc/map_bloc.dart';

class HistoryView extends StatefulWidget {
  final GoogleMapController controller;
  final MapBloc mapBloc;
  const HistoryView({
    Key? key,
    required this.controller,
    required this.mapBloc,
  }) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryBloc historyBloc = HistoryBloc();
  @override
  void initState() {
    historyBloc.add(HistoryInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double initialChildSize = 0.35;
    return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: 0.15,
        maxChildSize: 0.65,
        builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        shrinkWrap: true,
                        controller: scrollController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Center(
                              child: Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                          Text(
                            "Saved Co-ordinates",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily:
                                    GoogleFonts.varelaRound().fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<HistoryBloc, HistoryState>(
                      bloc: historyBloc,
                      listenWhen: (previous, current) =>
                          current is HistoryActionState,
                      listener: (context, state) {
                        if (state is HistoryNavigateToPinActionState) {
                          Navigator.pop(context);
                          widget.mapBloc.add(MapIthLocationPressedEvent(
                              coordsModel: state.coords,
                              controller: state.controller));
                        } else if (state is HistoryUnableToDeleteActionState) {
                          Utils.flushBarErrorMsg(state.errorMsg, context);
                        } else if (state is HistoryDisplaySnackBarActionState) {
                          Navigator.pop(context);
                          Utils.snackBar(state.msg, context);
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is! HistoryActionState,
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case HistoryListEmptyState:
                            return const Expanded(
                              child: Center(
                                  child: Text(
                                      "No Co-ordinates Stored Previously...")),
                            );
                          case HistoryLoadingFailedState:
                            final successState =
                                state as HistoryLoadingFailedState;
                            return Expanded(
                                child:
                                    Center(child: Text(successState.errorMsg)));
                          case HistoryListLoadedSuccessState:
                            final successState =
                                state as HistoryListLoadedSuccessState;
                            return Expanded(
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: scrollController,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: successState.coordsList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 15),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: Colors.teal.shade900),
                                            boxShadow: List.filled(
                                                1,
                                                const BoxShadow(
                                                    blurRadius: 2,
                                                    offset: Offset(.5, 2))),
                                            color: Colors.grey.shade200),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: IconButton(
                                                    onPressed: () {
                                                      historyBloc.add(
                                                          HistoryIthCoordPinPressedEvent(
                                                              mapBloc: widget
                                                                  .mapBloc,
                                                              controller: widget
                                                                  .controller,
                                                              coords: successState
                                                                      .coordsList[
                                                                  index]));
                                                    },
                                                    icon: const Icon(Icons
                                                        .pin_drop_outlined))),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      successState
                                                          .coordsList[index]
                                                          .address!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: GoogleFonts
                                                                  .varelaRound()
                                                              .fontFamily)),
                                                  Text(
                                                      "Lat: ${successState.coordsList[index].lat}"),
                                                  Text(
                                                      "Long: ${successState.coordsList[index].long}"),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  historyBloc.add(
                                                      HistoryIthItemDeletedPressedEvent(
                                                          id: successState
                                                              .coordsList[index]
                                                              .id!));
                                                },
                                                icon: const Icon(
                                                    Icons
                                                        .delete_outline_outlined,
                                                    color: Colors.red))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                            onPressed: () {
                              historyBloc
                                  .add(HistoryGenerateCsvBtnClickedEvent());
                            },
                            label: const Text('Export .csv')),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
