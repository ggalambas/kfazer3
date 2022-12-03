import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/pending_group_card.dart';

//TODO create a new folder for pending files
class HorizontalPendingView extends StatelessWidget {
  final List<Group> groups;
  const HorizontalPendingView({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final group in groups)
              SizedBox(
                width: constraints.maxWidth * 4 / 5,
                child: PendingGroupCard(group: group),
              ),
          ],
        ),
      );
    });
  }
}

// import 'package:flutter_layout_grid/flutter_layout_grid.dart';

// /// A widget that displays the list of products that match the search query.
// class ProductsGrid extends ConsumerWidget {
//   const ProductsGrid({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final productsListValue = ref.watch(productsSearchResultsProvider);
//     return AsyncValueWidget<List<Product>>(
//       value: productsListValue,
//       data: (products) => products.isEmpty
//           ? Center(
//               child: Text(
//                 'No products found'.hardcoded,
//                 style: Theme.of(context).textTheme.headline4,
//               ),
//             )
//           : ProductsLayoutGrid(
//               itemCount: products.length,
//               itemBuilder: (_, index) {
//                 final product = products[index];
//                 return ProductCard(
//                   product: product,
//                   onPressed: () => context.goNamed(
//                     AppRoute.product.name,
//                     params: {'id': product.id},
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// /// Grid widget with content-sized items.
// /// See: https://codewithandrea.com/articles/flutter-layout-grid-content-sized-items/
// class ProductsLayoutGrid extends StatelessWidget {
//   const ProductsLayoutGrid({
//     super.key,
//     required this.itemCount,
//     required this.itemBuilder,
//   });

//   /// Total number of items to display.
//   final int itemCount;

//   /// Function used to build a widget for a given index in the grid.
//   final Widget Function(BuildContext, int) itemBuilder;

//   @override
//   Widget build(BuildContext context) {
//     // use a LayoutBuilder to determine the crossAxisCount
//     return LayoutBuilder(builder: (context, constraints) {
//       final width = constraints.maxWidth;
//       // 1 column for width < 500px
//       // then add one more column for each 250px
//       final crossAxisCount = max(1, width ~/ 250);
//       // once the crossAxisCount is known, calculate the column and row sizes
//       // set some flexible track sizes based on the crossAxisCount with 1.fr
//       final columnSizes = List.generate(crossAxisCount, (_) => 1.fr);
//       final numRows = (itemCount / crossAxisCount).ceil();
//       // set all the row sizes to auto (self-sizing height)
//       final rowSizes = List.generate(numRows, (_) => auto);
//       // Custom layout grid. See: https://pub.dev/packages/flutter_layout_grid
//       return LayoutGrid(
//         columnSizes: columnSizes,
//         rowSizes: rowSizes,
//         rowGap: Sizes.p24, // equivalent to mainAxisSpacing
//         columnGap: Sizes.p24, // equivalent to crossAxisSpacing
//         children: [
//           // render all the items with automatic child placement
//           for (var i = 0; i < itemCount; i++) itemBuilder(context, i),
//         ],
//       );
//     });
//   }
// }
