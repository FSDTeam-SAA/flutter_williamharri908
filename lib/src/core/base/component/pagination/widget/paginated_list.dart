// import 'package:flutter/material.dart';
// import '../pagination.dart';

// class PaginatedListWidget<T> extends StatefulWidget {
//   final ValueNotifier<Pagination<T>> pagination;
//   final Widget skeleton;

//   /// How many skeletons to show, when there is no data
//   final int skeletonCount;
//   final VoidCallback onRefresh;
//   final Widget Function(int index, T data) builder;
//   const PaginatedListWidget({
//     super.key,
//     required this.pagination,
//     required this.onRefresh,
//     required this.skeleton,
//     required this.skeletonCount,
//     required this.builder,
//   });

//   @override
//   State<PaginatedListWidget<T>> createState() => _PaginatedListWidgetState<T>();
// }

// class _PaginatedListWidgetState<T> extends State<PaginatedListWidget<T>> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: () async {
//           widget.onRefresh();
//         },
//         child: ValueListenableBuilder(
//           valueListenable: widget.pagination,
//           builder: (context d, w) {
//             final data = widget.pagination;
//             return ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: data.value.data.length,
//               itemBuilder: (context, index) {
//                 final element = data.value.data[index];
//                 return widget.builder(index, element);
//               },
//             );
//           },
//         ),
//         // child: ValueListenableBuilder(
//         //   valueListenable: widget.pagination,
//         //   builder: (context d, w) {
//         //     final data = widget.pagination;
//         //     return Container();
//         //     return ListView.builder(
//         //       physics: NeverScrollableScrollPhysics(),
//         //       itemCount: data.length + 1,
//         //       itemBuilder: (context, index) {
//         //         debugPrint(
//         //           "Index: $index, length: ${data.value.data.length}, data type ${data.value.runtimeType}",
//         //         );
//         //         if (index == data.value.data.length) {
//         //           if ((data.value is LoadingMorePage<T> ||
//         //               data.value is RefreshingPage<T>)) {
//         //             return Column(
//         //               children: [
//         //                 ...List.generate(
//         //                   widget.skeletonCount,
//         //                   (_) => Padding(
//         //                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//         //                     child: widget.skeleton,
//         //                   ),
//         //                 ),
//         //               ],
//         //             );
//         //           } else {
//         //             return Container();
//         //           }
//         //         }
//         //         final element = data.value.data[index];
//         //         return widget.builder(index, element);
//         //       },
//         //     );
//         //   }
//         // ),
//       ),
//     );
//   }
// }
